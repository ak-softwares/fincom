import 'dart:isolate';

import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/woocommerce_repositories/category/woo_category_repository.dart';
import '../../models/category_model.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  //variables
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  final wooCategoryRepository = Get.put(WooCategoryRepository());


  @override
  void onInit() {
    super.onInit();
    refreshCategories();
  } // @override

  //Get all categories
  Future<void> getAllCategory() async {
    try {
      final newCategories = await wooCategoryRepository.fetchAllCategory(currentPage.toString());
      categories.addAll(newCategories);
    } catch (e) {
      throw TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> refreshCategories() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      categories.clear(); // Clear existing orders
      await getAllCategory();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  // /// Load category data
  // Future<List<CategoryModel>> fetchCategories() async {
  //   try {
  //     //fetch categories from data source(firebase, api, etc)
  //     final categories = await categoryRepository.getAllCategories();
  //     return categories;
  //   } catch (e) {
  //     throw TLoaders.errorSnackBar(title: 'Error - Categories loading', message: e.toString());
  //   }
  // }

}