import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/mongodb/products/product_repositories.dart';
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
          return !uploadedProductIds.contains(product.id);
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
      await getTotalProductsCount();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

}