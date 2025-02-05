import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/woocommerce_repositories/products/woo_product_repositories.dart';
import '../../models/product_model.dart';

class SearchQueryController extends GetxController {
  static SearchQueryController get instance => Get.find();

  //Variable
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxInt currentPage = 1.obs;
  RxString searchQuery = ''.obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  final wooProductRepository = Get.put(WooProductRepository());



  Future<void> getProductsBySearchQuery(String query) async {
    try {
      if(query.isNotEmpty){
        final newFavorites = await wooProductRepository.fetchProductsBySearchQuery(query: query,  page: currentPage.toString());
        products.addAll(newFavorites);
      }
    } catch (e) {
      throw TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> refreshSearch(String query) async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      products.clear(); // Clear existing orders
      await getProductsBySearchQuery(query);
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }
}