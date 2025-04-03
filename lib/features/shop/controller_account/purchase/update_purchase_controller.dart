import 'dart:io';

import 'package:fincom/features/shop/models/cart_item_model.dart';
import 'package:fincom/utils/formatters/formatters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/image/image_kit_repo.dart';
import '../../../../data/repositories/mongodb/products/product_repositories.dart';
import '../../../../data/repositories/mongodb/purchase/purchase_repositories.dart';
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
import 'purchase_controller.dart';

class UpdatePurchaseController extends GetxController {
  static UpdatePurchaseController get instance => Get.find();

  // Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  RxBool isUploadingImage = false.obs;
  RxBool isDeletingImage = false.obs;

  RxBool isGettingCount = false.obs;
  RxInt purchaseCounts = 0.obs;

  RxList<PurchaseModel> purchases = <PurchaseModel>[].obs;

  late String id = '';
  RxDouble purchaseTotal = 0.0.obs;
  RxInt productCount = 0.obs;
  RxInt purchaseNumber = 0.obs;
  final RxList<CartModel> selectedProducts = <CartModel>[].obs;
  Rx<VendorModel> selectedVendor = VendorModel().obs;

  final RxString searchQuery = ''.obs;

  RxList<ImageModel> purchaseInvoiceImages = <ImageModel>[].obs;

  Rx<File?> image = Rx<File?>(null);
  RxString uploadedImageUrl = ''.obs;
  final ImageKitService imageKitService = ImageKitService();

  final vendorController = Get.put(VendorController());
  final mongoProductRepo = Get.put(MongoProductRepo());
  final mongoPurchasesRepo = Get.put(MongoPurchasesRepo());
  final purchaseController = Get.put(PurchaseController());
  final transactionController = Get.put(TransactionController());

  TextEditingController dateController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();

  @override
  Future<void> onInit() async {
    super.onInit();
    dateController.text = DateTime.now().toString();
    updatePurchaseTotal();
  }

  @override
  void onClose() {
    dateController.dispose();
    invoiceNumberController.dispose();
    super.onClose();
  }

  void resetValue(PurchaseModel purchase) {
    id = purchase.id ?? '';
    purchaseNumber.value = purchase.purchaseID ?? 0;
    dateController.text = purchase.date.toString();
    invoiceNumberController.text = purchase.invoiceNumber ?? '';
    selectedVendor.value = purchase.vendor ?? VendorModel();
    selectedProducts.value = purchase.purchasedItems ?? [];
    purchaseInvoiceImages.value = purchase.purchaseInvoiceImages ?? [];
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
      // update(); // Update Gets state
      // Trigger UI update
      (context as Element).markNeedsBuild();
    }
  }

  // This function converts a productModel to a cartItemModel
  CartModel convertProductToCart({required ProductModel product, required int quantity, int variationId = 0}) {
    return CartModel(
      id: 1,
      name: product.name,
      productId: product.productId,
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

  void updatePurchase({required PurchaseModel previousPurchase}) {
    // Validate purchase fields
    if (!validatePurchaseFields()) {
      return; // Error messages are already shown inside validatePurchaseFields()
    }

    PurchaseModel purchase = PurchaseModel(
      id: previousPurchase.id,
      purchaseID: purchaseNumber.value,
      date: DateTime.tryParse(dateController.text) ?? previousPurchase.date,
      vendor: selectedVendor.value,
      invoiceNumber: invoiceNumberController.text.trim(),
      purchasedItems: selectedProducts,
      purchaseInvoiceImages: purchaseInvoiceImages,
      total: purchaseTotal.value,
    );

    TransactionModel transaction = TransactionModel(
      amount: purchaseTotal.value,
      date: DateTime.tryParse(dateController.text) ?? DateTime.now(),
      fromEntityId: selectedVendor.value.vendorId,
      fromEntityName: selectedVendor.value.company,
      fromEntityType: EntityType.vendor,
      transactionType: TransactionType.purchase,
      purchaseId: purchaseNumber.value,
    );

    uploadEditPurchase(purchase: purchase, transaction: transaction);
  }

  // Upload purchase
  Future<void> uploadEditPurchase({required PurchaseModel purchase, required TransactionModel transaction}) async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('We are updating purchase...', Images.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        throw 'Internet Not Connected';
      }

      // Update the purchase record
      await mongoPurchasesRepo.updatePurchase(id: purchase.id! , purchase: purchase);

      // Update the associated transaction
      await transactionController.updateTransactionByPurchaseId(purchaseId: purchase.purchaseID!, transaction: transaction);

      // Update product quantities
      await updateProductQuantity(products: purchase.purchasedItems ?? [], isAddition: true);

      // Refresh the purchase list
      await purchaseController.refreshPurchases();

      // Stop loading and show success message
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Purchase updated successfully!');

      // Navigate back
      Navigator.of(Get.context!).pop();
    } catch (e) {
      // Remove loader and show error message
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
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

  Future<void> updateProductQuantity({required List<CartModel> products, required bool isAddition}) async {
    try {
      if (products.isEmpty) {
        throw Exception("Product list is empty. Cannot update quantity.");
      }
      // Convert CartModel list to PurchaseHistory list
      List<ProductPurchaseHistory> purchaseHistoryList = products.map((product) {
        return ProductPurchaseHistory(
          productId: product.product_id, // Assuming purchaseId can be productId
          quantity: product.quantity,
          price: (product.price ?? 0).toDouble(),
          purchaseDate: DateTime.now().toIso8601String(),
        );
      }).toList();
      await mongoProductRepo.updateProductQuantities(purchaseHistoryList: purchaseHistoryList, isAddition: isAddition);
    } catch(e) {
      rethrow;
    }
  }

}