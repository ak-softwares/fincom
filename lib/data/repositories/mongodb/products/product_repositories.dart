import 'dart:async';
import 'package:get/get.dart';

import '../../../../features/shop/controllers/product/product_controller.dart';
import '../../../../features/shop/models/product_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../database/mongodb/mongodb.dart';

class MongoProductRepo extends GetxController {
  static MongoProductRepo get instance => Get.find();
  final MongoDatabase _mongoDatabase = MongoDatabase();
  final String collectionName = 'products';
  final int itemsPerPage = int.tryParse(APIConstant.itemsPerPage) ?? 10;

  // Fetch products by search query & pagination
  Future<List<ProductModel>> fetchProductsBySearchQuery({required String query, int page = 1}) async {
    try {
      // Fetch products from MongoDB with search and pagination
      final List<Map<String, dynamic>> productData =
          await _mongoDatabase.fetchDocumentsBySearchQuery(
              collectionName: collectionName,
              query: query,
              itemsPerPage: itemsPerPage,
              page: page
          );

      // Convert data to a list of ProductModel
      final List<ProductModel> products = productData.map((data) => ProductModel.fromJson(data)).toList();
      return products;
    } catch (e) {
      throw 'Failed to fetch products: $e';
    }
  }

  // Fetch All Products from MongoDB
  Future<List<ProductModel>> fetchProducts({int page = 1}) async {
    try {

      // Fetch products from MongoDB with pagination
      final List<Map<String, dynamic>> productData =
            await _mongoDatabase.fetchDocuments(collectionName:collectionName, page: page);

      // Convert data to a list of ProductModel
      final List<ProductModel> products = productData.map((data) => ProductModel.fromJson(data)).toList();

      return products;
    } catch (e) {
      throw 'Failed to fetch products: $e';
    }
  }

  // Fetch Product's IDs from MongoDB
  Future<Set<int>> fetchProductsIds() async {
    try {
      // Fetch product IDs from MongoDB
      return await _mongoDatabase.fetchCollectionIds(collectionName);
    } catch (e) {
      throw 'Failed to fetch product IDs: $e';
    }
  }

  // Fetch Products by IDs from MongoDB
  Future<List<ProductModel>> fetchProductsByIds(List<int> productIds) async {
    try {
      if (productIds.isEmpty) return []; // Return empty list if no IDs provided

      // Fetch products from MongoDB where the ID matches any in the list
      final List<Map<String, dynamic>> productData =
            await _mongoDatabase.fetchDocumentsByIds(collectionName, productIds,);

      // Convert data to a list of ProductModel
      final List<ProductModel> products = productData.map((data) => ProductModel.fromJson(data)).toList();

      return products;
    } catch (e) {
      throw 'Failed to fetch products by IDs: $e';
    }
  }

 // Upload multiple products
  Future<void> pushProducts({required List<ProductModel> products}) async {
    try {
      List<Map<String, dynamic>> productMaps = products.map((product) => product.toMap()).toList();
      await _mongoDatabase.insertDocuments(collectionName, productMaps); // Use batch insert function
    } catch (e) {
      throw 'Failed to upload products: $e';
    }
  }

  // Get the total count of products in the collection
  Future<int> fetchProductsCount() async {
    try {
      int count = await _mongoDatabase.fetchCollectionCount(collectionName);
      return count;
    } catch (e) {
      throw 'Failed to fetch products count: $e';
    }
  }

}
