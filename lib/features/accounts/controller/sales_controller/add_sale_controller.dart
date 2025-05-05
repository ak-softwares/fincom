import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/orders/orders_repositories.dart';
import '../../../../data/repositories/woocommerce/orders/woo_orders_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/models/user_model.dart';
import '../../models/cart_item_model.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import '../product/product_controller.dart';
import 'sales_controller.dart';

class AddSaleController extends GetxController {
  static AddSaleController get instance => Get.find();

  final OrderType orderType = OrderType.sale;
  var isScanning = false.obs;
  RxList<OrderModel> orders = <OrderModel>[].obs;
  RxDouble saleTotal = 0.0.obs;
  RxInt productCount = 0.obs;
  RxInt invoiceId = 0.obs;

  TextEditingController dateController = TextEditingController();

  final wooOrdersRepository = Get.put(WooOrdersRepository());
  final saleController = Get.put(SaleController());
  final mongoOrderRepo = Get.put(MongoOrderRepo());
  final productsVoucherController = Get.put(ProductController());
  final userController = Get.put(UserController());

  RxList<CartModel> selectedProducts = <CartModel>[].obs;
  Rx<UserModel> selectedCustomer = UserModel().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    invoiceId.value = await mongoOrderRepo.fetchOrderGetNextId(orderType: orderType);
    dateController.text = DateTime.now().toString();
    updateSaleTotal();
  }


  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  final MobileScannerController cameraController = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.all],
  );

  void addProducts(List<ProductModel> getSelectedProducts) {
    bool isUpdated = false;

    for (var product in getSelectedProducts) {
      // Check if the product already exists in the selected products list
      bool alreadyExists = selectedProducts.any((item) => item.productId == product.productId);

      if (!alreadyExists) {
        // Convert each product to a cart item with default quantity, variationId, and pageSource
        final cartItem = convertProductToCart(
          product: product,
          quantity: 1,
          variationId: 0,
        );

        selectedProducts.add(cartItem);
        isUpdated = true; // Flag to update total only if a new item was added
      }
    }

    if (isUpdated) {
      updateSaleTotal();
    }
  }

  void removeProducts(CartModel item) {
    int index = selectedProducts.indexWhere((cartItem) => cartItem.productId == item.productId);
    if(index >= 0) {
      selectedProducts.removeAt(index);
    }
    updateSaleTotal();
  }

  void addCustomer(UserModel getSelectedCustomer) {
    selectedCustomer.value = getSelectedCustomer;
  }

  void selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      dateController.text = pickedDate.toString();

      // Trigger UI update
      (context as Element).markNeedsBuild();
    }
  }

  Future<void> handleDetection(BarcodeCapture capture) async {
    if (isScanning.value) return;
    try {
      FullScreenLoader.onlyCircularProgressDialog('Fetching Order...');
      isScanning.value = true;

      for (final barcode in capture.barcodes) {
        final value = barcode.rawValue;
        bool exists = orders.any((order) => order.orderId.toString() == value);
        if (value != null && !exists) {
          HapticFeedback.mediumImpact();
          final OrderModel sale = await wooOrdersRepository.fetchOrderById(orderId: value);
          // checkIsSaleExist
          final OrderModel checkIsSaleExist = await saleController.getSaleByOrderId(orderId: sale.orderId!);
          if(checkIsSaleExist.id != null) {
            throw 'Sale already exist';
          }
          orders.add(sale);
        }
      }

      Future.delayed(const Duration(seconds: 2), () {
        isScanning.value = false;
      });
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in Order Fetching', message: e.toString());
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  // This function converts a productModel to a cartItemModel
  CartModel convertProductToCart({required ProductModel product, required int quantity, int variationId = 0}) {
    return CartModel(
      id: 1,
      name: product.name,
      product_id: product.id,
      productId: product.productId ?? 0,
      variationId: variationId,
      quantity: quantity,
      category: product.categories?[0].name,
      subtotal: (quantity * product.getPrice()).toStringAsFixed(0),
      total: (quantity * product.getPrice()).toStringAsFixed(0),
      subtotalTax: '0',
      totalTax: '0',
      sku: product.sku,
      price: product.getPrice().toInt(),
      image: product.mainImage,
      parentName: '0',
      isCODBlocked: product.isCODBlocked,
    );
  }

  Future<void> clearSale() async {
    invoiceId.value = await mongoOrderRepo.fetchOrderGetNextId(orderType: orderType);
    dateController.text = DateTime.now().toString();
    selectedCustomer.value = UserModel();
    selectedProducts.value = [];
    updateSaleTotal();
  }

  bool validateSaleFields() {
    try {
      if (selectedProducts.isEmpty) {
        throw Exception('Please select at least one product.');
      }
      if (selectedCustomer.value.name == null || selectedCustomer.value.name!.isEmpty) {
        throw Exception('Please select a customer.');
      }
      if (dateController.text.isEmpty) {
        throw Exception('Please enter a date.');
      }
      return true;
    } catch (e) {
      // Show validation error in a snack bar
      AppMassages.errorSnackBar(title: 'Validation Error', message: e.toString());
      return false;
    }
  }

  Future<void> saveSale() async {
    // Validate purchase fields
    if (!validateSaleFields()) {
      return; // Error messages are already shown inside validatePurchaseFields()
    }

    OrderModel sale = OrderModel(
      invoiceNumber: invoiceId.value,
      dateCreated: DateTime.tryParse(dateController.text),
      userId: selectedCustomer.value.userId,
      lineItems: selectedProducts,
      total: saleTotal.value,
      status: OrderStatus.inTransit,
      orderType: orderType
    );

    await pushSale(sale: sale);
  }

  Future<void> pushSale({required OrderModel sale}) async {
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog('We are adding sale...', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        throw 'Internet Not connected';
      }

      final fetchedInvoiceId = await mongoOrderRepo.fetchOrderGetNextId(orderType: orderType);
      if (fetchedInvoiceId != invoiceId.value) {
        sale.invoiceNumber = fetchedInvoiceId;
      }

      await pushSales(sales: [sale]);

      await clearSale();
      FullScreenLoader.stopLoading();
      AppMassages.showToastMessage(message: 'Purchase uploaded successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      //remove Loader
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> addBarcodeSale() async {
    try {
      FullScreenLoader.onlyCircularProgressDialog('Fetching Order...');
      await pushSales(sales: orders);
      orders.clear();
      AppMassages.showToastMessage(message: 'Sale Added Successfully');
    } catch(e) {
      AppMassages.errorSnackBar(title: 'Error sale Sale', message: e.toString());
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  Future<void> pushSales({required List<OrderModel> sales}) async {
    try {

      // Check if any invoiceId is null
      final hasMissingInvoice = sales.any((sale) => sale.invoiceNumber == null);

      if (hasMissingInvoice) {
        int nextInvoiceId = await mongoOrderRepo.fetchOrderGetNextId(orderType: orderType);

        for (var sale in sales) {
          if (sale.invoiceNumber == null) {
            sale.invoiceNumber = nextInvoiceId;
            nextInvoiceId++; // increment for the next one
          }
        }
      }

      // Flatten all line items from each sale
      final List<CartModel> allLineItems = sales.expand<CartModel>((sale) => sale.lineItems ?? []).toList();

      // Define the async operations
      final updateProductQuantities = productsVoucherController.updateProductQuantity(cartItems: allLineItems);

      Future<void> uploadSales = mongoOrderRepo.pushOrders(orders: sales); // Use batch insert function

      // Execute all three operations
      await Future.wait([updateProductQuantities, uploadSales]);

      await saleController.refreshSales();

    } catch(e) {
      rethrow;
    }
  }

  // Add single item to cart
  void updateQuantity({required CartModel item, required int quantity}) {
    int index = selectedProducts.indexWhere((cartItem) => cartItem.productId == item.productId);
    if(index >= 0){
      //This quantity is already added or updated/remove from the design
      selectedProducts[index].quantity = quantity;
      selectedProducts[index].total = (selectedProducts[index].quantity * selectedProducts[index].price!).toStringAsFixed(0);
    }
    updateSaleTotal();
  }

  // Add single item to cart
  void updatePrice({required CartModel item, required double purchasePrice}) {
    int index = selectedProducts.indexWhere((cartItem) => cartItem.productId == item.productId);
    if(index >= 0){
      //This quantity is already added or updated/remove from the design
      selectedProducts[index].price = purchasePrice.toInt();
      selectedProducts[index].total = (selectedProducts[index].quantity * selectedProducts[index].price!).toStringAsFixed(0);
    }
    updateSaleTotal();
  }

  void updateSaleTotal(){
    double calculateTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for(var item in selectedProducts){
      calculateTotalPrice += (item.price!) * item.quantity;
      calculatedNoOfItems += item.quantity;
    }
    saleTotal.value = calculateTotalPrice;
    productCount.value = calculatedNoOfItems;
    selectedProducts.refresh();
  }

  void resetValue({required OrderModel sale}) {
    invoiceId.value = sale.orderId ?? 0;
    dateController.text = sale.dateCreated.toString();
    // selectedCustomer.value = sale.userId,
    selectedProducts.value = sale.lineItems ?? [];
    updateSaleTotal();
  }

  Future<void> saveUpdatedSale({required OrderModel previousSale}) async {
    // Validate purchase fields
    if (!validateSaleFields()) {
      return; // Error messages are already shown inside validatePurchaseFields()
    }
    OrderModel sale = OrderModel(
        id: previousSale.id,
        invoiceNumber: previousSale.invoiceNumber,
        dateCreated: DateTime.tryParse(dateController.text),
        userId: selectedCustomer.value.userId,
        lineItems: selectedProducts,
        total: saleTotal.value,
        orderType: orderType
    );

    await updateSale(newSale: sale, previousSale: previousSale);
  }

  Future<void> updateSale({required OrderModel newSale, required OrderModel previousSale}) async {
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog('We are updating sale...', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        throw 'Internet Not connected';
      }

      // Create a new list with updated product quantities
      final List<CartModel> updatedProducts = (newSale.lineItems ?? []).map((currentProduct) {
        final previousProduct = (previousSale.lineItems ?? []).firstWhere(
              (item) => item.productId == currentProduct.productId,
          orElse: () => CartModel(productId: currentProduct.productId, quantity: 0), // fallback with 0 quantity
        );

        int previousQty = int.tryParse(previousProduct.quantity.toString()) ?? 0;
        int currentQty = int.tryParse(currentProduct.quantity.toString()) ?? 0;

        // Return a copy with adjusted quantity
        return currentProduct.copyWith(quantity: currentQty - previousQty);
      }).toList();

      final updateProductQuantities = productsVoucherController.updateProductQuantity(cartItems: updatedProducts);

      final updateSale = mongoOrderRepo.updateOrder(order: newSale);

      await Future.wait([updateProductQuantities, updateSale]);

      // Update in RxList
      final index = saleController.sales.indexWhere((c) => c.id == newSale.id);
      if (index != -1) {
        saleController.sales[index] = newSale;
      }
      await saleController.refreshSales();

      FullScreenLoader.stopLoading();
      AppMassages.showToastMessage(message: 'Purchase uploaded successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      //remove Loader
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
