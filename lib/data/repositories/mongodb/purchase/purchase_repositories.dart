import 'dart:async';
import 'package:get/get.dart';

import '../../../../features/shop/models/purchase_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../database/mongodb/mongodb.dart';


class MongoPurchasesRepo extends GetxController {
  final MongoDatabase _mongoDatabase = MongoDatabase();
  final String collectionName = 'purchase';
  final int itemsPerPage = int.tryParse(APIConstant.itemsPerPage) ?? 10;

  // Fetch purchases by search query & pagination
  Future<List<PurchaseModel>> fetchPurchasesBySearchQuery({required String query, int page = 1}) async {
    try {
      final List<Map<String, dynamic>> purchasesData =
      await _mongoDatabase.fetchDocumentsBySearchQuery(
          collectionName: collectionName,
          query: query,
          itemsPerPage: itemsPerPage,
          page: page
      );
      final List<PurchaseModel> purchases = purchasesData.map((data) => PurchaseModel.fromJson(data)).toList();
      return purchases;
    } catch (e) {
      throw 'Failed to fetch purchases: $e';
    }
  }

  // Fetch all purchases from MongoDB
  Future<List<PurchaseModel>> fetchAllPurchases({int page = 1}) async {
    try {
      final List<Map<String, dynamic>> purchasesData =
      await _mongoDatabase.fetchDocuments(collectionName: collectionName, page: page);
      final List<PurchaseModel> purchases = purchasesData.map((data) => PurchaseModel.fromJson(data)).toList();
      return purchases;
    } catch (e) {
      throw 'Failed to fetch purchases: $e';
    }
  }

  Future<PurchaseModel> fetchPurchaseById({required String id}) async {
    try {
      // Fetch a single document by ID
      final Map<String, dynamic>? purchaseData =
                        await _mongoDatabase.fetchDocumentById(collectionName: collectionName, id: id);

      // Check if the document exists
      if (purchaseData == null) {
        throw Exception('Purchase not found with ID: $id');
      }
      // Convert the document to a PurchaseModel object
      final PurchaseModel purchase = PurchaseModel.fromJson(purchaseData);
      return purchase;
    } catch (e) {
      throw 'Failed to fetch purchase: $e';
    }
  }

  // Fetch customers' IDs from MongoDB
  Future<Set<int>> fetchCustomersIds() async {
    try {
      return await _mongoDatabase.fetchCollectionIds(collectionName);
    } catch (e) {
      throw 'Failed to fetch customers IDs: $e';
    }
  }

  // Get the total count of purchases in the collection
  Future<int> fetchPurchaseCount() async {
    try {
      int count = await _mongoDatabase.fetchCollectionCount(collectionName);
      return count;
    } catch (e) {
      throw 'Failed to fetch purchase count: $e';
    }
  }

  // Get the total count of purchases in the collection
  Future<int> fetchPurchaseGetNextId() async {
    try {
      int nextID = await _mongoDatabase.getNextId(collectionName: collectionName, fieldName: PurchaseFieldName.purchaseID);
      return nextID;
    } catch (e) {
      throw 'Failed to fetch purchase id: $e';
    }
  }

  // Upload a purchase
  Future<void> pushPurchase({required PurchaseModel purchase}) async {
    try {
      Map<String, dynamic> purchaseMap = purchase.toJson();
      await _mongoDatabase.insertDocument(collectionName, purchaseMap);
    } catch (e) {
      throw 'Failed to upload purchase: $e';
    }
  }

  // Upload a purchase
  Future<void> updatePurchase({required String id, required PurchaseModel purchase}) async {
    try {
      Map<String, dynamic> purchaseMap = purchase.toJson();
                    await _mongoDatabase.updateDocumentById(id: id, collectionName: collectionName, updatedData: purchaseMap);
    } catch (e) {
      throw 'Failed to upload purchase: $e';
    }
  }

  // Delete a purchase
  Future<void> deletePurchase({required String id}) async {
    try {
      await _mongoDatabase.deleteDocumentById(id: id, collectionName: collectionName);
    } catch (e) {
      throw 'Failed to Delete purchase: $e';
    }
  }
}
