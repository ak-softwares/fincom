import 'package:get/get.dart';

import '../../../../features/shop/models/order_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../database/mongodb/mongodb.dart';

class MongoPurchaseListRepo extends GetxController {
  static MongoPurchaseListRepo get instance => Get.find();
  final MongoDatabase _mongoDatabase = MongoDatabase();
  final String collectionName = DbCollections.purchaseList;
  final String collectionNameMetaData = DbCollections.meta;
  final int itemsPerPage = int.tryParse(APIConstant.itemsPerPageSync) ?? 10;

  // Fetch All Orders from MongoDB
  Future<List<OrderModel>> fetchOrders({int page = 1}) async {
    try {

      // Fetch orders from MongoDB with pagination
      final List<Map<String, dynamic>> ordersData =
                  await _mongoDatabase.fetchDocuments(collectionName:collectionName, page: page, itemsPerPage: itemsPerPage);

      // Convert data to a list of OrdersModel
      final List<OrderModel> orders = ordersData.map((data) => OrderModel.fromJson(data)).toList();

      return orders;
    } catch (e) {
      throw 'Failed to fetch orders: $e';
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

  // Delete all orders from the collection
  Future<void> deleteAllOrders() async {
    try {
      // Use an empty filter to match all documents in the collection
      await _mongoDatabase.deleteDocuments(collectionName: collectionName, filter: {});
    } catch (e) {
      throw 'Failed to delete all orders: $e';
    }
  }

  // Fetch All Orders from MongoDB
  Future<dynamic> fetchMetaData({required String metadataName}) async {
    try {
      // Fetch orders from MongoDB with pagination
      final jsonData = await _mongoDatabase.fetchMetaDocuments(collectionName: collectionNameMetaData, metaDataName: metadataName);
      return jsonData;
    } catch (e) {
      throw 'Failed to fetch Meta data: $e';
    }
  }

  Future<void> pushMetaData({required String metadataName, required dynamic value}) async {
    try {
      await _mongoDatabase.pushMetaDataValue(
        collectionName: collectionNameMetaData,
        metaDataName: metadataName,
        value: value,
      );
    } catch (e) {
      throw Exception('Failed to push metadata: $e');
    }
  }

  Future<void> deleteMetaData({required String metadataName}) async {
    try {
      await _mongoDatabase.deleteMetaDataField(
        collectionName: collectionNameMetaData,
        metaDataName: metadataName,
      );
    } catch (e) {
      throw Exception('Failed to delete metadata: $e');
    }
  }

}