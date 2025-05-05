import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/dialog_massage.dart';
import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/products/product_repositories.dart';
import '../../../../data/repositories/woocommerce/orders/woo_orders_repository.dart';
import '../../../../data/repositories/woocommerce/products/woo_product_repositories.dart';
import '../../models/cart_item_model.dart';
import '../../models/product_model.dart';

class ProductController extends GetxController{
  static ProductController get instance => Get.find();

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
  final wooProductRepository = Get.put(WooProductRepository());

  // Form Key
  final GlobalKey<FormState> productFormKey = GlobalKey<FormState>();

  TextEditingController productTitleController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController stockController = TextEditingController();


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
        List<ProductModel> products = await wooProductRepository.fetchAllProducts(page: currentPage.toString());

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
              AppMassages.warningSnackBar(title: 'Sync Stopped', message: 'Syncing stopped by user.');
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
        AppMassages.successSnackBar(title: 'Sync Complete', message: 'All new products uploaded.');
      }
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Sync Error', message: e.toString());
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
      int wooProductsCounts = await wooProductRepository.fetchProductCount();
      wooProductsCount.value = wooProductsCounts; // Assuming totalCustomers is an observable or state variable
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in products Count Fetching', message: e.toString());
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
      AppMassages.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
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
      AppMassages.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  // Get Product by ID
  Future<ProductModel> getProductByID({required String id}) async {
    try {
      final fetchedProduct = await mongoProductRepo.fetchProductById(id: id);
      return fetchedProduct;
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in getting product', message: e.toString());
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
        onSubmit: () async {
          await mongoProductRepo.deleteProduct(id: id);
          Get.back();
        },
        toastMessage: 'Product deleted successfully!',
      );
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Add and updated function

  /// Save Updated Product (New Function)
  void saveUpdatedProduct({required ProductModel previousProduct}) {
    ProductModel product = ProductModel(
      id: previousProduct.id,
      name: productTitleController.text,
      purchasePrice: double.tryParse(purchasePriceController.text) ?? 0.0,
      stockQuantity: int.tryParse(stockController.text) ?? 0,
    );

    updateProduct(product: product);
  }

  /// Update Product (New Function)
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

  /// Reset Product Values (New Function)
  void resetProductValues(ProductModel product) {
    productTitleController.text = product.name ?? '';
    purchasePriceController.text = product.purchasePrice.toString();
    stockController.text = product.stockQuantity.toString();
  }

  /// Save Product (New Function)
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

  /// Add Product (New Function)
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

  /// Clear Product Fields (New Function)
  void clearProductFields() {
    productTitleController.text = '';
    purchasePriceController.text = '';
  }

  Future<void> updateProductQuantity({
    required List<CartModel> cartItems,
    List<CartModel>? previousCartItems,
    bool? isUpdate,
    bool isAddition = false,
    bool isPurchase = false
  }) async {
    try {
      if((isUpdate ?? false) && (previousCartItems != null)) {
        if (cartItems.isEmpty && previousCartItems.isEmpty) {
          throw Exception("Product list is empty. Cannot update quantity.");
        }
        final List<CartModel> updatedProducts = (cartItems).map((currentProduct) {
          final previousProduct = previousCartItems.firstWhere(
                (item) => item.productId == currentProduct.productId,
            orElse: () => CartModel(productId: currentProduct.productId, quantity: 0),
          );

          int previousQty = int.tryParse(previousProduct.quantity.toString()) ?? 0;
          int currentQty = int.tryParse(currentProduct.quantity.toString()) ?? 0;

          return currentProduct.copyWith(quantity: currentQty - previousQty);
        }).toList();
        await mongoProductRepo.updateQuantities(cartItems: updatedProducts, isAddition: isAddition, isPurchase: isPurchase);

      } else{
        if (cartItems.isEmpty) {
          throw Exception("Product list is empty. Cannot update quantity.");
        }
        // Convert CartModel list to PurchaseHistory list
        await mongoProductRepo.updateQuantities(cartItems: cartItems, isAddition: isAddition, isPurchase: isPurchase);
      }
    } catch (e) {
      rethrow; // Preserve original exception
    }
  }

  // This function converts a productModel to a cartItemModel
  CartModel convertProductToCart({
    required ProductModel product, required int quantity, int variationId = 0, double? purchasePrice}) {
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
      purchasePrice: purchasePrice ?? product.purchasePrice,
      image: product.mainImage,
      parentName: '0',
      isCODBlocked: product.isCODBlocked,
    );
  }

}
