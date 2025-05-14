import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/products/product_repositories.dart';
import '../../models/product_model.dart';

class AddProductController extends GetxController {
  static AddProductController get instance => Get.find();


  // Form Key
  TextEditingController productTitleController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  final GlobalKey<FormState> productFormKey = GlobalKey<FormState>();

  final mongoProductRepo = Get.put(MongoProductRepo());

  // Save Product
  void saveProduct() {
    ProductModel product = ProductModel(
      id: '', // Will be set when adding to DB
      name: productTitleController.text,
      price: double.tryParse(purchasePriceController.text) ?? 0.0,
      dateCreated: DateTime.now().toIso8601String(),
      productId: 123,
    );

    addProduct(product: product);
  }

  // Add Product
  Future<void> addProduct({required ProductModel product}) async {
    try {
      FullScreenLoader.openLoadingDialog('Adding new product...', '');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      final fetchedProductId = await mongoProductRepo.fetchProductGetNextId();
      if (fetchedProductId != product.productId) {
        throw 'Product ID is not unique';
      }

      await mongoProductRepo.pushProduct(product: product);

      clearProductFields();
      FullScreenLoader.stopLoading();
      AppMassages.showToastMessage(message: 'Product added successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Clear Product Fields
  void clearProductFields() {
    productTitleController.text = '';
    purchasePriceController.text = '';
  }

  // Reset Product Values
  void resetProductValues(ProductModel product) {
    productTitleController.text = product.name ?? '';
    purchasePriceController.text = product.purchasePrice.toString();
    stockController.text = product.stockQuantity.toString();
  }

  // Save Updated Product
  void saveUpdatedProduct({required ProductModel previousProduct}) {
    ProductModel product = ProductModel(
      id: previousProduct.id,
      name: productTitleController.text,
      purchasePrice: double.tryParse(purchasePriceController.text) ?? 0.0,
      stockQuantity: int.tryParse(stockController.text) ?? 0,
    );

    updateProduct(product: product);
  }

  // Update Product
  Future<void> updateProduct({required ProductModel product}) async {
    try {
      FullScreenLoader.openLoadingDialog('Updating product...', '');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      await mongoProductRepo.updateProduct(id: product.id ?? '', product: product);

      FullScreenLoader.stopLoading();
      AppMassages.showToastMessage(message: 'Product updated successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

}