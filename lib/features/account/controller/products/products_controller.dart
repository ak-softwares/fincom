import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/fincom_repositories/category/woo_category_repository.dart';
import '../../../../data/repositories/fincom_repositories/products/woo_product_repositories.dart';
import '../../model/category/category_model.dart';
import '../../model/products/product_model.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;

  final wooProductRepository = Get.put(WooProductRepository());
  final wooCategoryRepository = Get.put(WooCategoryRepository());


  // Get All products
  Future<List<ProductModel>> getAllProducts(String page) async {
    try{
      //fetch products
      final List<ProductModel> product = await wooProductRepository.fetchAllProducts(page: page);
      return product;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  // Get All Featured products
  Future<List<ProductModel>> getFeaturedProducts(String page) async {
    try{
      //fetch products
      final products = await wooProductRepository.fetchFeaturedProducts(page: page);
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  // Get Products under ₹199
  Future<List<ProductModel>> getProductsUnderPrice( String price, String page) async {
    try{
      //fetch products
      // final products = await compute(() => wooProductRepository.fetchProductsUnderPrice(page: page, price: price));
      final products = await wooProductRepository.fetchProductsUnderPrice(page: page, price: price);
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }


  // Get products by category id
  Future<List<ProductModel>> getProductsByCategoryId(String categoryId, String page) async {
    try{
      //fetch products
      final products = await wooProductRepository.fetchProductsByCategoryID(categoryId: categoryId, page: page);
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  // Get products by category id
  Future<List<ProductModel>> getProductsByBrandId(String brandID, String page) async {
    try{
      //fetch products
      final products = await wooProductRepository.fetchProductsByBrandID(brandID: brandID, page: page);
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  // Get products by category slug
  // Future<List<ProductModel>> getProductsByCategorySlug(String slug, String page) async {
  //   try{
  //     //fetch products
  //     final CategoryModel category = await wooCategoryRepository.fetchCategoryBySlug(slug);
  //     final products = await wooProductRepository.fetchProductsByCategoryID(categoryId: category.id ?? '', page: page);
  //     return products;
  //   } catch (e){
  //     TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
  //     return [];
  //   }
  // }

  // Get products by products ids
  Future<List<ProductModel>> getProductsByIds(String productIds, String page) async {
    try{
      //fetch products
      final products = await wooProductRepository.fetchProductsByIds(productIds: productIds, page: page);
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getVariationByProductsIds({required String parentID}) async {
    try {
      final List<ProductModel> variations = await wooProductRepository.fetchVariationByProductsIds(parentID: parentID);
      return variations;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Variation Fetching', message: e.toString());
      return [];
    }
  }

  //Get products by product id
  Future<ProductModel> getProductById(String productsId) async {
    try{
      //fetch products
      final ProductModel product = await wooProductRepository.fetchProductById(productsId);
      return product;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return ProductModel.empty();
    }
  }


  //Get products by product's slug
  Future<ProductModel> getProductBySlug(String permalink) async {
    try{
      //fetch products
      final ProductModel product = await wooProductRepository.fetchProductBySlug(permalink);
      return product;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return ProductModel.empty();
    }
  }

  // Get Products By Search Query
  Future<List<ProductModel>> getProductsBySearchQuery(String searchQuery) async {
    try{
      //fetch products
      final products = await wooProductRepository.fetchProductsBySearchQuery(query: searchQuery, page: '1');
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  //Get Products By Search Query
  Future<List<ProductModel>> getFBTProducts(String productId, String page) async {
    try{
      //fetch products
      final products = await wooProductRepository.fetchFBTProducts(productId: productId);
      return products;
    } catch (e){
      // TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }
}
