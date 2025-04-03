import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box/dialog_massage.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/products/product_repositories.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../controllers/product/product_controller.dart';
import '../../models/product_model.dart';

class ProductsVoucherController extends GetxController{
  static ProductsVoucherController get instance => Get.find();

  // Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isStopped = false.obs; // New: Track if the user wants to stop syncing
  RxBool isSyncing = false.obs;
  RxBool isGettingCount = false.obs;
  RxInt processedProducts = 0.obs;
  RxInt totalProcessedProducts = 0.obs;
  RxInt fincomProductsCount = 0.obs;
  RxInt wooProductsCount = 0.obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  final mongoProductRepo = Get.put(MongoProductRepo());
  final productController = Get.put(ProductController());

  // Form Key
  final GlobalKey<FormState> productFormKey = GlobalKey<FormState>();

  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();


  Future<void> syncProducts() async {
    try {
      isSyncing(true);
      isStopped(false); // Reset stop flag
      processedProducts.value = 0; // Reset progress
      totalProcessedProducts.value = 0; // Reset total compared product count

      int batchSize = 500; // Adjust based on API limits and DB capacity

      // **Step 1: Fetch Existing Product IDs Efficiently**
      Set<int> uploadedProductIds = await mongoProductRepo.fetchProductsIds(); // Consider paginating this

      int currentPage = 1;
      while (!isStopped.value) {
        // **Step 2: Fetch a batch of products from API**
        List<ProductModel> products = await productController.getAllProducts(currentPage.toString());

        if (products.isEmpty) break; // Stop if no more products are available

        totalProcessedProducts.value += products.length; // Track total compared products

        // **Step 3: Filter only new products**
        List<ProductModel> newProducts = products.where((product) {
          return !uploadedProductIds.contains(product.productId);
        }).toList();

        // **Step 4: Bulk Insert**
        if (newProducts.isNotEmpty) {
          for (int i = 0; i < newProducts.length; i += batchSize) {
            if (isStopped.value) {
              TLoaders.warningSnackBar(title: 'Sync Stopped', message: 'Syncing stopped by user.');
              return;
            }

            int end = (i + batchSize < newProducts.length) ? i + batchSize : newProducts.length;
            List<ProductModel> chunk = newProducts.sublist(i, end);

            await mongoProductRepo.pushProducts(products: chunk); // Upload chunk

            processedProducts.value += chunk.length; // Update progress
          }
        }

        currentPage++; // Move to the next page
      }

      if (!isStopped.value) {
        TLoaders.successSnackBar(title: 'Sync Complete', message: 'All new products uploaded.');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Sync Error', message: e.toString());
    } finally {
      isSyncing(false);
    }
  }

  void stopSyncing() {
    isStopped(true);
  }

  // Get total customer count
  Future<void> getTotalProductsCount() async {
    try {
      isGettingCount(true);
      int fincomProductsCounts = await mongoProductRepo.fetchProductsCount();
      fincomProductsCount.value = fincomProductsCounts; // Assuming totalCustomers is an observable or state variable
      int wooProductsCounts = await productController.getTotalProductCount();
      wooProductsCount.value = wooProductsCounts; // Assuming totalCustomers is an observable or state variable
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in products Count Fetching', message: e.toString());
    } finally {
      isGettingCount(false);
    }
  }

  // Get All products
  Future<void> getAllProducts() async {
    try {
      final fetchedProducts = await mongoProductRepo.fetchProducts(page: currentPage.value);
      products.addAll(fetchedProducts);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
    }
  }

  Future<void> refreshProducts() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      products.clear(); // Clear existing orders
      await getAllProducts();
      // await getTotalProductsCount();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  // Get All products
  Future<void> updateProductQuantities({required List<ProductPurchaseHistory> purchaseHistoryList, required bool isAddition}) async {
    try {
      await mongoProductRepo.updateProductQuantities(purchaseHistoryList: purchaseHistoryList, isAddition: isAddition);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Get Product by ID
  Future<ProductModel> getProductByID({required String id}) async {
    try {
      final fetchedProduct = await mongoProductRepo.fetchProductById(id: id);
      return fetchedProduct;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in getting product', message: e.toString());
      return ProductModel.empty(); // Return an empty product model in case of failure
    }
  }

  // Delete Product
  Future<void> deleteProduct({required String id, required BuildContext context}) async {
    try {
      DialogHelper.showDialog(
        context: context,
        title: 'Delete Product',
        message: 'Are you sure you want to delete this product?',
        function: () async {
          await mongoProductRepo.deleteProduct(id: id);
          Get.back();
        },
        toastMessage: 'Product deleted successfully!',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Add and updated function

  /// Save Updated Product (New Function)
  void saveUpdatedProduct({required ProductModel previousProduct}) {
    ProductModel product = ProductModel(
      id: previousProduct.id,
      name: productNameController.text,
      price: double.tryParse(productPriceController.text) ?? 0.0,
      dateCreated: previousProduct.dateCreated,
      productId: 123,
    );

    updateProduct(product: product);
  }

  /// Update Product (New Function)
  Future<void> updateProduct({required ProductModel product}) async {
    try {
      TFullScreenLoader.openLoadingDialog('Updating product...', '');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await mongoProductRepo.updateProduct(id: product.id ?? '', product: product);

      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Product updated successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Reset Product Values (New Function)
  void resetProductValues(ProductModel product) {
    productNameController.text = product.name ?? '';
    productPriceController.text = product.price.toString();
  }

  /// Save Product (New Function)
  void saveProduct() {
    ProductModel product = ProductModel(
      id: '', // Will be set when adding to DB
      name: productNameController.text,
      price: double.tryParse(productPriceController.text) ?? 0.0,
      dateCreated: DateTime.now().toIso8601String(),
      productId: 123,
    );

    addProduct(product: product);
  }

  /// Add Product (New Function)
  Future<void> addProduct({required ProductModel product}) async {
    try {
      TFullScreenLoader.openLoadingDialog('Adding new product...', '');

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final fetchedProductId = await mongoProductRepo.fetchProductGetNextId();
      if (fetchedProductId != product.productId) {
        throw 'Product ID is not unique';
      }

      await mongoProductRepo.pushProduct(product: product);

      clearProductFields();
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Product added successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  /// Clear Product Fields (New Function)
  void clearProductFields() {
    productNameController.text = '';
    productPriceController.text = '';
  }

}
