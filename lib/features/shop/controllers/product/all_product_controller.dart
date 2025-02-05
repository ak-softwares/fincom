import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../models/product_model.dart';

class AllProductController extends GetxController {
  static AllProductController get instance => Get.find();
  //Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  final RxString selectedSortOption = 'Name'.obs;

  Future<void> getAllProducts(Future<List<ProductModel>> Function(String) futureMethod) async {
    try {
      final List<ProductModel> newProducts = await futureMethod(currentPage.toString());
      products.addAll(newProducts);
    } catch (e) {
      throw TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> refreshAllProducts(Future<List<ProductModel>> Function(String) futureMethod) async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      products.clear(); // Clear existing orders
      await getAllProducts(futureMethod);
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> getAllProductsTwoSting(Future<List<ProductModel>> Function(String, String) futureMethod, String categoryId) async {
    try {
      final List<ProductModel> newProducts = await futureMethod(categoryId, currentPage.toString());
      products.addAll(newProducts);
    } catch (e) {
      throw TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> refreshAllProductsTwoSting(Future<List<ProductModel>> Function(String, String) futureMethod, String categoryId) async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      products.clear(); // Clear existing orders
      await getAllProductsTwoSting(futureMethod, categoryId);
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  void sortProducts (String sortOption) {
    selectedSortOption.value = sortOption;
    //'Name', 'Higher price', 'Lower Price', 'Sale', 'Newest', 'Popular'
    switch (sortOption) {
      case 'Name' :
        products.sort((a, b) => a.name!.compareTo(b.name ?? ''));
        break;
      case 'Higher Price' :
        products.sort((a, b) => b.salePrice!.compareTo(a.salePrice ?? 0.0));
        break;
      case 'Lower Price' :
        products.sort((a, b) => a.salePrice!.compareTo(b.salePrice ?? 0.0));
        break;
      // case 'Newest' :
      //   products.sort((a, b) => a.date!.compareTo(b.date!));
      //   break;
      case 'Sale' :
        products.sort((a, b) {
          if (b.salePrice! > 0) {
            return b.salePrice!.compareTo(a.salePrice!);
          } else if (a.salePrice! > 0) {
            return -1;
          } else {
            return 1;
          }
        });
        break;
      default:
        //default sorting option: Name
        products.sort((a, b) => a.name!.compareTo(b.name ?? ''));
    }
  }

  void assignProducts(List<ProductModel> products) {
    //Assign products to the 'Products' List
    this.products.assignAll(products);
    sortProducts('Name');
  }
}