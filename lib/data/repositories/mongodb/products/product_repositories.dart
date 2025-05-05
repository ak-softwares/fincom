import 'dart:async';
import 'package:get/get.dart';

import '../../../../features/accounts/models/cart_item_model.dart';
import '../../../../features/accounts/models/product_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/db_constants.dart';
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
            await _mongoDatabase.fetchProducts(collectionName:collectionName, page: page);
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
            await _mongoDatabase.fetchDocumentsByIds(collectionName, productIds);

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

  Future<void> updateQuantities({required List<CartModel> cartItems, bool isAddition = false, bool isPurchase = false}) async {
    try {
      await _mongoDatabase.updateQuantities(collectionName: collectionName, cartItems: cartItems, isAddition: isAddition, isPurchase: isPurchase);
    } catch (e) {
      rethrow;
    }
  }

  Future<ProductModel> fetchProductById({required String id}) async {
    try {
      // Fetch a single document by ID
      final Map<String, dynamic>? productData =
          await _mongoDatabase.fetchDocumentById(collectionName: collectionName, id: id);

      // Check if the document exists
      if (productData == null) {
        throw Exception('Product not found with ID: $id');
      }

      // Convert the document to a ProductModel object
      final ProductModel product = ProductModel.fromJson(productData);
      return product;
    } catch (e) {
      throw 'Failed to fetch product: $e';
    }
  }

  Future<void> deleteProduct({required String id}) async {
    try {
      await _mongoDatabase.deleteDocumentById(id: id, collectionName: collectionName);
    } catch (e) {
      throw 'Failed to delete product: $e';
    }
  }

  // Get the total count of purchases in the collection
  Future<int> fetchProductGetNextId() async {
    try {
      int nextID = await _mongoDatabase.getNextId(collectionName: collectionName, fieldName: ProductFieldName.productId);
      return nextID;
    } catch (e) {
      throw 'Failed to fetch vendor id: $e';
    }
  }

  // Add product
  Future<void> pushProduct({required ProductModel product}) async {
    try {
      Map<String, dynamic> productMap = product.toMap(); // Convert a single product to a map
      await _mongoDatabase.insertDocument(collectionName, productMap);
    } catch (e) {
      throw 'Failed to add Product: $e';
    }
  }

  // Update a product
  Future<void> updateProduct({required String id, required ProductModel product}) async {
    try {
      Map<String, dynamic> productMap = product.toJson();
          await _mongoDatabase.updateDocumentById(id: id, collectionName: collectionName, updatedData: productMap);
    } catch (e) {
      throw 'Failed to update Product: $e';
    }
  }

}
