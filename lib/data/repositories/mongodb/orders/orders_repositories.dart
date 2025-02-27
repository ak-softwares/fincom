import 'dart:async';
import 'package:get/get.dart';

import '../../../../features/shop/models/order_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../database/mongodb/mongodb.dart';

class MongoOrdersRepo extends GetxController {
  static MongoOrdersRepo get instance => Get.find();
  final MongoDatabase _mongoDatabase = MongoDatabase();
  final String collectionName = 'orders';
  final int itemsPerPage = int.tryParse(APIConstant.itemsPerPage) ?? 10;

  // Fetch orders by search query & pagination
  Future<List<OrderModel>> fetchOrdersBySearchQuery({required String query, int page = 1}) async {
    try {
      // Fetch orders from MongoDB with search and pagination
      final List<Map<String, dynamic>> ordersData =
          await _mongoDatabase.fetchDocumentsBySearchQuery(
              collectionName: collectionName,
              query: query,
              itemsPerPage: itemsPerPage,
              page: page
          );
      // Convert data to a list of OrdersModel
      final List<OrderModel> orders = ordersData.map((data) => OrderModel.fromJson(data)).toList();
      return orders;
    } catch (e) {
      throw 'Failed to fetch orders: $e';
    }
  }

  // Fetch All Orders from MongoDB
  Future<List<OrderModel>> fetchOrders({int page = 1}) async {
    try {

      // Fetch orders from MongoDB with pagination
      final List<Map<String, dynamic>> ordersData =
            await _mongoDatabase.fetchDocuments(collectionName:collectionName, page: page);

      // Convert data to a list of OrdersModel
      final List<OrderModel> orders = ordersData.map((data) => OrderModel.fromJson(data)).toList();

      return orders;
    } catch (e) {
      throw 'Failed to fetch orders: $e';
    }
  }

  // Fetch Order's IDs from MongoDB
  Future<Set<int>> fetchOrdersIds() async {
    try {
      // Fetch orders IDs from MongoDB
      return await _mongoDatabase.fetchCollectionIds(collectionName);
    } catch (e) {
      throw 'Failed to fetch orders IDs: $e';
    }
  }

  // Fetch Orders by IDs from MongoDB
  Future<List<OrderModel>> fetchOrdersByIds(List<int> ordersIds) async {
    try {
      if (ordersIds.isEmpty) return []; // Return empty list if no IDs provided

      // Fetch orders from MongoDB where the ID matches any in the list
      final List<Map<String, dynamic>> ordersData =
            await _mongoDatabase.fetchDocumentsByIds(collectionName, ordersIds,);

      // Convert data to a list of OrdersModel
      final List<OrderModel> orders = ordersData.map((data) => OrderModel.fromJson(data)).toList();

      return orders;
    } catch (e) {
      throw 'Failed to fetch orders by IDs: $e';
    }
  }

 // Upload multiple orders
  Future<void> pushOrders({required List<OrderModel> orders}) async {
    try {
      List<Map<String, dynamic>> ordersMaps = orders.map((order) => order.toMap()).toList();
      await _mongoDatabase.insertDocuments(collectionName, ordersMaps); // Use batch insert function
    } catch (e) {
      throw 'Failed to upload orders: $e';
    }
  }

  // Get the total count of orders in the collection
  Future<int> fetchOrdersCount() async {
    try {
      int count = await _mongoDatabase.fetchCollectionCount(collectionName);
      return count;
    } catch (e) {
      throw 'Failed to fetch orders count: $e';
    }
  }

}
