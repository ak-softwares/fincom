import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/image_kit/image_kit_repo.dart';
import '../../../../data/repositories/mongodb/orders/orders_repositories.dart';
import '../../../../data/repositories/woocommerce/orders/woo_orders_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/models/user_model.dart';
import '../../models/cart_item_model.dart';
import '../../models/image_model.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import '../product/product_controller.dart';
import 'purchase_controller.dart';

class AddPurchaseController extends GetxController {
  static AddPurchaseController get instance => Get.find();

  final OrderType orderType = OrderType.purchase;
  var isScanning = false.obs;
  RxList<OrderModel> orders = <OrderModel>[].obs;
  RxDouble purchaseTotal = 0.0.obs;
  RxInt productCount = 0.obs;
  RxInt invoiceId = 0.obs;

  RxBool isUploadingImage = false.obs;
  RxBool isDeletingImage = false.obs;
  Rx<File?> image = Rx<File?>(null);
  RxString uploadedImageUrl = ''.obs;
  final ImageKitService imageKitService = ImageKitService();
  RxList<ImageModel> purchaseInvoiceImages = <ImageModel>[].obs;

  TextEditingController dateController = TextEditingController();

  final wooOrdersRepository = Get.put(WooOrdersRepository());
  final purchaseController = Get.put(PurchaseController());
  final mongoOrderRepo = Get.put(MongoOrderRepo());
  final productsVoucherController = Get.put(ProductController());
  final userController = Get.put(UserController());

  RxList<CartModel> selectedProducts = <CartModel>[].obs;
  Rx<UserModel> selectedSupplier = UserModel().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    invoiceId.value = await mongoOrderRepo.fetchOrderGetNextId(orderType: orderType);
    updatePurchaseTotal();
  }

  Future<void> pickImage() async {
    final pickedImage = await imageKitService.pickImage();
    if (pickedImage != null) {
      purchaseInvoiceImages.add(ImageModel(
          image: pickedImage
      ));
    }
  }

  Future<void> uploadImage(ImageModel image) async {
    try {
      isUploadingImage(true);
      if (image.image != null) {
        final fetchImage = await imageKitService.uploadImage(image.image!);
        if (fetchImage.imageUrl != null) {
          int index = purchaseInvoiceImages.indexWhere((img) => img.imageId == image.imageId);
          if (index != -1) {
            purchaseInvoiceImages[index].imageUrl = fetchImage.imageUrl; // Directly update the property
            purchaseInvoiceImages[index].imageId = fetchImage.imageId; // Directly update the property
            purchaseInvoiceImages.refresh(); // Notify listeners about the change
          }
          AppMassages.showToastMessage(message: 'Image Upload successfully');
        }
      }
    } catch(e) {
      AppMassages.errorSnackBar(title: 'Error Upload Image', message: e.toString());
    } finally {
      isUploadingImage(false);
    }
  }

  Future<void> deleteImage(ImageModel image) async {
    try {
      isDeletingImage(true);
      if (image.imageId != null && image.imageId!.isNotEmpty) {
        await imageKitService.deleteImage(image.imageId!);
        AppMassages.showToastMessage(message: 'Image Deleted successfully');
      }
      purchaseInvoiceImages.removeWhere((img) => img.image == image.image);
    } catch(e) {
      AppMassages.errorSnackBar(title: 'Error Delete Image', message: e.toString());
    } finally {
      isDeletingImage(false);
    }
  }

  void addProducts(List<ProductModel> getSelectedProducts) {
    bool isUpdated = false;

    for (var product in getSelectedProducts) {
      bool alreadyExists = selectedProducts.any((item) => item.productId == product.productId);

      if (!alreadyExists) {
        final cartItem = convertProductToCart(
          product: product,
          quantity: 1,
          variationId: 0,
        );

        selectedProducts.add(cartItem);
        isUpdated = true;
      }
    }

    if (isUpdated) {
      updatePurchaseTotal();
    }
  }

  void removeProducts(CartModel item) {
    int index = selectedProducts.indexWhere((cartItem) => cartItem.productId == item.productId);
    if(index >= 0) {
      selectedProducts.removeAt(index);
    }
    updatePurchaseTotal();
  }

  void addSupplier(UserModel getSelectedSupplier) {
    selectedSupplier.value = getSelectedSupplier;
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
      (context as Element).markNeedsBuild();
    }
  }

  CartModel convertProductToCart({required ProductModel product, required int quantity, int variationId = 0}) {
    return CartModel(
      id: 1,
      name: product.name,
      product_id: product.id,
      productId: product.productId ?? 0,
      variationId: variationId,
      quantity: quantity,
      category: product.categories?[0].name,
      subtotal: (quantity * (product.purchasePrice ?? 0)).toStringAsFixed(0),
      total: (quantity * (product.purchasePrice ?? 0)).toStringAsFixed(0),
      subtotalTax: '0',
      totalTax: '0',
      sku: product.sku,
      price: product.purchasePrice?.toInt(),
      purchasePrice: product.purchasePrice,
      image: product.mainImage,
      parentName: '0',
      isCODBlocked: product.isCODBlocked,
    );
  }

  Future<void> clearPurchase() async {
    invoiceId.value = await mongoOrderRepo.fetchOrderGetNextId(orderType: orderType);
    dateController.text = DateTime.now().toString();
    selectedSupplier.value = UserModel();
    selectedProducts.value = [];
    updatePurchaseTotal();
  }

  bool validatePurchaseFields() {
    try {
      if (selectedProducts.isEmpty) {
        throw Exception('Please select at least one product.');
      }
      if (selectedSupplier.value.name == null || selectedSupplier.value.name!.isEmpty) {
        throw Exception('Please select a supplier.');
      }
      if (dateController.text.isEmpty) {
        throw Exception('Please enter a date.');
      }
      // Check if any image does not have a URL
      if (purchaseInvoiceImages.any((image) => image.imageUrl == null || image.imageUrl!.isEmpty)) {
        throw Exception('One of the Invoice images is not uploaded');
      }
      return true;
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Validation Error', message: e.toString());
      return false;
    }
  }

  Future<void> savePurchase() async {
    if (!validatePurchaseFields()) {
      return;
    }

    OrderModel purchase = OrderModel(
        invoiceNumber: invoiceId.value,
        dateCreated: DateTime.tryParse(dateController.text),
        user: selectedSupplier.value,
        lineItems: selectedProducts,
        total: purchaseTotal.value,
        purchaseInvoiceImages: purchaseInvoiceImages,
        orderType: orderType
    );
    await pushPurchase(purchase: purchase);
  }

  Future<void> pushPurchase({required OrderModel purchase}) async {
    try {
      FullScreenLoader.openLoadingDialog('We are adding purchase...', Images.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        throw 'Internet Not connected';
      }

      final fetchedInvoiceId = await mongoOrderRepo.fetchOrderGetNextId(orderType: orderType);
      if (fetchedInvoiceId != invoiceId.value) {
        purchase.invoiceNumber = fetchedInvoiceId;
      }
      await pushPurchases(purchases: [purchase]);

      await clearPurchase();
      FullScreenLoader.stopLoading();
      AppMassages.showToastMessage(message: 'Purchase uploaded successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> pushPurchases({required List<OrderModel> purchases}) async {
    try {
      final hasMissingInvoice = purchases.any((purchase) => purchase.invoiceNumber == null);

      if (hasMissingInvoice) {
        int nextInvoiceId = await mongoOrderRepo.fetchOrderGetNextId(orderType: orderType);

        for (var purchase in purchases) {
          if (purchase.invoiceNumber == null) {
            purchase.invoiceNumber = nextInvoiceId;
            nextInvoiceId++;
          }
        }
      }

      final List<CartModel> allLineItems = purchases.expand<CartModel>((purchase) => purchase.lineItems ?? []).toList();

      Future<void> updateProductQuantities = productsVoucherController.updateProductQuantity(cartItems: allLineItems, isAddition: true, isPurchase: true);
      Future<void> updateVendorBalance = userController.updateUserBalance(userID: selectedSupplier.value.userId ?? 0, balance: purchaseTotal.value, isAddition: false);
      Future<void> uploadPurchases = mongoOrderRepo.pushOrders(orders: purchases);

      await Future.wait([updateProductQuantities, updateVendorBalance, uploadPurchases]);

      await purchaseController.refreshPurchases();

    } catch(e) {
      rethrow;
    }
  }

  void updateQuantity({required CartModel item, required int quantity}) {
    int index = selectedProducts.indexWhere((cartItem) => cartItem.productId == item.productId);
    if(index >= 0){
      selectedProducts[index].quantity = quantity;
      selectedProducts[index].total = (selectedProducts[index].quantity * selectedProducts[index].price!).toStringAsFixed(0);
    }
    updatePurchaseTotal();
  }

  void updatePrice({required CartModel item, required double purchasePrice}) {
    int index = selectedProducts.indexWhere((cartItem) => cartItem.productId == item.productId);
    if(index >= 0){
      selectedProducts[index].purchasePrice = purchasePrice;
      selectedProducts[index].total = (selectedProducts[index].quantity * selectedProducts[index].price!).toStringAsFixed(0);
    }
    updatePurchaseTotal();
  }

  void updatePurchaseTotal(){
    double calculateTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for(var item in selectedProducts){
      calculateTotalPrice += (item.purchasePrice!) * item.quantity;
      calculatedNoOfItems += item.quantity;
    }
    purchaseTotal.value = calculateTotalPrice;
    productCount.value = calculatedNoOfItems;
    selectedProducts.refresh();
  }

  void resetValue({required OrderModel purchase}) {
    dateController.value = TextEditingValue(
      text: purchase.dateCreated.toString(),
      selection: TextSelection.fromPosition(
        TextPosition(offset: purchase.dateCreated.toString().length),
      ),
    );
    invoiceId.value = purchase.orderId ?? 0;
    selectedSupplier.value = purchase.user ?? UserModel();
    selectedProducts.value = purchase.lineItems ?? [];
    purchaseInvoiceImages.value = purchase.purchaseInvoiceImages ?? [];
    updatePurchaseTotal();
  }

  Future<void> saveUpdatedPurchase({required OrderModel previousPurchase}) async {
    if (!validatePurchaseFields()) {
      return;
    }
    OrderModel purchase = OrderModel(
        id: previousPurchase.id,
        invoiceNumber: previousPurchase.invoiceNumber,
        dateCreated: DateTime.tryParse(dateController.text),
        user: selectedSupplier.value,
        lineItems: selectedProducts,
        total: purchaseTotal.value,
        orderType: orderType
    );

    await updatePurchase(newPurchase: purchase, previousPurchase: previousPurchase);
  }

  Future<void> updatePurchase({required OrderModel newPurchase, required OrderModel previousPurchase}) async {
    try {
      FullScreenLoader.openLoadingDialog('We are updating purchase...', Images.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        throw 'Internet Not connected';
      }

      // Calculate balance difference
      double currentTotal = newPurchase.total ?? 0;
      double previousTotal = previousPurchase.total ?? 0;

      final updateProductQuantities = productsVoucherController.updateProductQuantity(
        cartItems: newPurchase.lineItems ?? [],
        previousCartItems: previousPurchase.lineItems ?? [],
        isUpdate: true,
        isPurchase: true,
        isAddition: true,
      );

      Future<void> updateVendorBalance = userController.updateUserBalance(
          userID: selectedSupplier.value.userId ?? 0,
          balance: currentTotal,
          previousBalance: previousTotal,
          isUpdate: true,
          isAddition: false
      );
      final updatePurchase = mongoOrderRepo.updateOrder(order: newPurchase);

      await Future.wait([updateProductQuantities, updateVendorBalance, updatePurchase]);

      final index = purchaseController.purchases.indexWhere((c) => c.id == newPurchase.id);
      if (index != -1) {
        purchaseController.purchases[index] = newPurchase;
        purchaseController.purchases.refresh();
      }
      await purchaseController.refreshPurchases();

      FullScreenLoader.stopLoading();
      AppMassages.showToastMessage(message: 'Purchase updated successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}