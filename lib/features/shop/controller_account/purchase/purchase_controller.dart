import 'dart:io';

import 'package:fincom/features/shop/models/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/dialog_box/dialog_massage.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/image/image_kit_repo.dart';
import '../../../../data/repositories/mongodb/products/product_repositories.dart';
import '../../../../data/repositories/mongodb/purchase/purchase_repositories.dart';
import '../../../../data/repositories/mongodb/transaction/transaction_repo.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../models/image_model.dart';
import '../../models/payment_method.dart';
import '../../models/product_model.dart';
import '../../models/purchase_model.dart';
import '../../models/transaction_model.dart';
import '../../models/vendor_model.dart';
import '../product/product_controller.dart';
import '../transaction/transaction_controller.dart';
import '../vendor/vendor_controller.dart';

class PurchaseController extends GetxController {
  static PurchaseController get instance => Get.find();

  // Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  RxBool isUploadingImage = false.obs;
  RxBool isDeletingImage = false.obs;

  RxBool isGettingCount = false.obs;
  RxInt purchaseCounts = 0.obs;

  RxList<PurchaseModel> purchases = <PurchaseModel>[].obs;

  RxDouble purchaseTotal = 0.0.obs;
  RxInt productCount = 0.obs;
  RxInt purchaseNumber = 0.obs;
  final RxList<CartModel> selectedProducts = <CartModel>[].obs;
  Rx<VendorModel> selectedVendor = VendorModel().obs;
  // Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel().obs;

  final RxString searchQuery = ''.obs;

  RxList<ImageModel> purchaseInvoiceImages = <ImageModel>[].obs;

  Rx<File?> image = Rx<File?>(null);
  RxString uploadedImageUrl = ''.obs;
  final ImageKitService imageKitService = ImageKitService();

  final vendorController = Get.put(VendorController());
  final mongoProductRepo = Get.put(MongoProductRepo());
  final mongoPurchasesRepo = Get.put(MongoPurchasesRepo());
  final transactionController = Get.put(TransactionController());
  final mongoTransactionRepo = Get.put(MongoTransactionRepo());


  TextEditingController dateController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();
  // TextEditingController paymentAmountController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    purchaseNumber.value = await mongoPurchasesRepo.fetchPurchaseGetNextId();
    dateController.text = DateTime.now().toString();
    refreshPurchases();
    updatePurchaseTotal();
  }

  @override
  void onClose() {
    dateController.dispose();
    invoiceNumberController.dispose();
    super.onClose();
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
          TLoaders.customToast(message: 'Image Upload successfully');
        }
      }
    } catch(e) {
      TLoaders.errorSnackBar(title: 'Error Upload Image', message: e.toString());
    } finally {
      isUploadingImage(false);
    }
  }

  Future<void> deleteImage(ImageModel image) async {
    try {
      isDeletingImage(true);
      if (image.imageId != null && image.imageId!.isNotEmpty) {
        await imageKitService.deleteImage(image.imageId!);
        TLoaders.customToast(message: 'Image Deleted successfully');
      }
      purchaseInvoiceImages.removeWhere((img) => img.image == image.image);
    } catch(e) {
      TLoaders.errorSnackBar(title: 'Error Delete Image', message: e.toString());
    } finally {
      isDeletingImage(false);
    }
  }

  // Get All products
  Future<PurchaseModel> getPurchaseByID({required String id}) async {
    try {
      final fetchedPurchase = await mongoPurchasesRepo.fetchPurchaseById(id: id);
      return fetchedPurchase;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in purchase getting', message: e.toString());
      return PurchaseModel();
    }
  }

  // Get All products
  Future<void> getAllPurchases() async {
    try {
      final fetchedPurchase = await mongoPurchasesRepo.fetchAllPurchases(page: currentPage.value);
      purchases.addAll(fetchedPurchase);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in purchase getting', message: e.toString());
    }
  }

  Future<void> refreshPurchases() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      purchases.clear(); // Clear existing orders
      await getAllPurchases();
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Errors', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  void addProducts(List<ProductModel> getSelectedProducts) {
    bool isUpdated = false;

    for (var product in getSelectedProducts) {
      // Check if the product already exists in the selected products list
      bool alreadyExists = selectedProducts.any((item) => item.productId == product.id);

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

  // Add single item to cart
  void updateQuantity({required CartModel item, required int quantity}) {
    int index = selectedProducts.indexWhere((cartItem) => cartItem.productId == item.productId);
    if(index >= 0){
      //This quantity is already added or updated/remove from the design
      selectedProducts[index].quantity = quantity;
      selectedProducts[index].total = (selectedProducts[index].quantity * selectedProducts[index].price!).toStringAsFixed(0);
    }
    updatePurchaseTotal();
  }

  // Add single item to cart
  void updatePrice({required CartModel item, required double price}) {
    int index = selectedProducts.indexWhere((cartItem) => cartItem.productId == item.productId);
    if(index >= 0){
      //This quantity is already added or updated/remove from the design
      selectedProducts[index].price = price.toInt();
      selectedProducts[index].total = (selectedProducts[index].quantity * selectedProducts[index].price!).toStringAsFixed(0);
    }
    updatePurchaseTotal();
  }

  // Update cart total
  void updatePurchaseTotal(){
    double calculateTotalPrice = 0.0;
    int calculatedNoOfItems = 0;

    for(var item in selectedProducts){
      calculateTotalPrice += (item.price!) * item.quantity;
      calculatedNoOfItems += item.quantity;
    }
    purchaseTotal.value = calculateTotalPrice;
    productCount.value = calculatedNoOfItems;
    selectedProducts.refresh();
  }

  void addVendor(VendorModel getSelectedVendor) {
    selectedVendor.value = getSelectedVendor;
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

  // This function converts a productModel to a cartItemModel
  CartModel convertProductToCart({required ProductModel product, required int quantity, int variationId = 0}) {
    return CartModel(
      id: 1,
      name: product.name,
      productId: product.id,
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

  Future<void> clearPurchase() async {
    purchaseNumber.value = await mongoPurchasesRepo.fetchPurchaseGetNextId();
    dateController.text = DateTime.now().toString();
    invoiceNumberController.text = '';
    selectedVendor.value = VendorModel();
    selectedProducts.value = [];
    purchaseInvoiceImages.value = [];
    updatePurchaseTotal();
  }


  bool validatePurchaseFields() {
    try {
      if (selectedProducts.isEmpty) {
        throw Exception('Please select at least one product.');
      }
      if (selectedVendor.value.company == null || selectedVendor.value.company!.isEmpty) {
        throw Exception('Please select a vendor.');
      }
      if (dateController.text.isEmpty) {
        throw Exception('Please enter a date.');
      }
      // Validate purchaseInvoiceImages
      for (var imageModel in purchaseInvoiceImages) {
        if (imageModel.image != null && imageModel.imageUrl == null) {
          throw Exception('One or more images are not uploaded');
        }
      }
      return true;
    } catch (e) {
      // Show validation error in a snack bar
      TLoaders.errorSnackBar(title: 'Validation Error', message: e.toString());
      return false;
    }
  }

  Future<void> updateProductQuantity({required bool isAddition}) async {
    try {
      // Convert selectedProducts to product-quantity pairs
      List<Map<String, dynamic>> productQuantityPairs = selectedProducts
          .map((cartItem) => {
            'productId': cartItem.productId,
            'quantity': cartItem.quantity,
          }).toList();
      // true for addition, false for subtraction
      await mongoProductRepo.updateProductQuantities(productQuantityPairs: productQuantityPairs, isAddition: isAddition);
    } catch(e) {
      rethrow;
    }
  }

  Future<void> savePurchase() async {
    // Validate purchase fields
    if (!validatePurchaseFields()) {
      return; // Error messages are already shown inside validatePurchaseFields()
    }

    PurchaseModel purchase = PurchaseModel(
      purchaseID: purchaseNumber.value,
      date: DateTime.tryParse(dateController.text) ?? DateTime.now(),
      vendor: selectedVendor.value,
      invoiceNumber: invoiceNumberController.text.trim(),
      purchasedItems: selectedProducts,
      purchaseInvoiceImages: purchaseInvoiceImages,
      total: purchaseTotal.value,
    );

    TransactionModel transaction = TransactionModel(
        amount: purchaseTotal.value,
        date:  DateTime.tryParse(dateController.text) ?? DateTime.now(),
        fromEntityId: selectedVendor.value.vendorId,
        fromEntityName: selectedVendor.value.company,
        fromEntityType: EntityType.vendor,
        transactionType: TransactionType.purchase,
        purchaseId: purchaseNumber.value
    );

    await uploadPurchase(purchase: purchase, transaction: transaction);
  }

  Future<void> uploadPurchase({required PurchaseModel purchase, required TransactionModel transaction}) async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are adding purchase...', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        throw 'Internet Not connected';
      }
      final fetchedPurchaseId = await mongoPurchasesRepo.fetchPurchaseGetNextId();
      if (fetchedPurchaseId != purchaseNumber.value) {
        purchase.purchaseID = fetchedPurchaseId;
        transaction.purchaseId = fetchedPurchaseId;
      }

      Future<void> updateTransaction = transactionController.processTransaction(transaction: transaction);

      Future<void> updateProductQuantities = updateProductQuantity(isAddition: true);

      Future<void> uploadPurchase = mongoPurchasesRepo.pushPurchase(purchase: purchase); // Use batch insert function

      // Execute all three operations
      await Future.wait([updateTransaction, updateProductQuantities, uploadPurchase]);

      await clearPurchase();
      await refreshPurchases();
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Purchase uploaded successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> deletePurchase ({required PurchaseModel purchase, required BuildContext context}) async {
    try {
      DialogHelper.showDialog(
          context: context,
          title: 'Delete Purchase',
          message: 'Are you sure to delete this Purchase',
          function: () async {
            // Reverse product quantities before deleting the purchase
            await updateProductQuantity(isAddition: false);
            // Delete the associated transaction (if any)
            await transactionController.deleteTransactionByPurchaseId(purchaseId: purchase.purchaseID ?? 0);
            // Delete purchase record
            await mongoPurchasesRepo.deletePurchase(id: purchase.id ?? '');
            // Refresh purchase list
            await refreshPurchases();
            // Close the current screen after successful deletion
            Navigator.pop(context);
            },
          toastMessage: 'Purchase deleted successfully!'
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

}