import 'package:fincom/utils/constants/db_constants.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../features/accounts/models/payment_method.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../database/mongodb/mongodb.dart';

class MongoAccountsRepo extends GetxController {
  final MongoDatabase _mongoDatabase = MongoDatabase();
  final String collectionName = DbCollections.accounts;
  final int itemsPerPage = int.tryParse(APIConstant.itemsPerPage) ?? 10;

  // Fetch products by search query & pagination
  Future<List<AccountModel>> fetchAccountsBySearchQuery({required String query, int page = 1}) async {
    try {
      // Fetch products from MongoDB with search and pagination
      final List<Map<String, dynamic>> paymentsData =
      await _mongoDatabase.fetchDocumentsBySearchQuery(
          collectionName: collectionName,
          query: query,
          itemsPerPage: itemsPerPage,
          page: page
      );
      // Convert data to a list of ProductModel
      final List<AccountModel> payments = paymentsData.map((data) => AccountModel.fromJson(data)).toList();
      return payments;
    } catch (e) {
      throw 'Failed to fetch Vendors: $e';
    }
  }

  // Fetch All Products from MongoDB
  Future<List<AccountModel>> fetchAllAccountsMethod({int page = 1}) async {
    try {
      // Fetch products from MongoDB with pagination
      final List<Map<String, dynamic>> paymentMethodData =
      await _mongoDatabase.fetchDocuments(collectionName:collectionName, page: page);
      // Convert data to a list of ProductModel
      final List<AccountModel> paymentMethod = paymentMethodData.map((data) => AccountModel.fromJson(data)).toList();
      return paymentMethod;
    } catch (e) {
      throw 'Failed to fetch payment method: $e';
    }
  }

  // Upload multiple products
  Future<void> pushAccountsMethod({required AccountModel paymentMethod}) async {
    try {
      Map<String, dynamic> paymentMap = paymentMethod.toMap(); // Convert a single vendor to a map
      await _mongoDatabase.insertDocument(collectionName, paymentMap);
    } catch (e) {
      throw 'Failed to upload payment: $e';
    }
  }

  // Fetch payment by id
  Future<AccountModel> fetchAccountById({required String id}) async {
    try {
      // Fetch a single document by ID
      final Map<String, dynamic>? vendorData =
                  await _mongoDatabase.fetchDocumentById(collectionName: collectionName, id: id);

      // Check if the document exists
      if (vendorData == null) {
        throw Exception('Payment not found with ID: $id');
      }
      // Convert the document to a PurchaseModel object
      final AccountModel payment = AccountModel.fromJson(vendorData);
      return payment;
    } catch (e) {
      throw 'Failed to fetch payment: $e';
    }
  }

  // Update a payment
  Future<void> updateAccount({required String id, required AccountModel payment}) async {
    try {
      Map<String, dynamic> paymentMap = payment.toMap();
                await _mongoDatabase.updateDocumentById(id: id, collectionName: collectionName, updatedData: paymentMap);
    } catch (e) {
      throw 'Failed to upload payment: $e';
    }
  }

  // Delete a payment
  Future<void> deleteAccount({required String id}) async {
    try {
      await _mongoDatabase.deleteDocumentById(id: id, collectionName: collectionName);
    } catch (e) {
      throw 'Failed to Delete Payment: $e';
    }
  }

  // Get the next id
  Future<int> fetchAccountGetNextId() async {
    try {
      int nextID = await _mongoDatabase.getNextId(collectionName: collectionName, fieldName: AccountFieldName.accountId);
      return nextID;
    } catch (e) {
      throw 'Failed to fetch payment id: $e';
    }
  }

  // Fetch All Products from MongoDB
  Future<double> fetchTotalBalance() async {
    try {
      // Fetch products from MongoDB with pagination
      final double totalStockValue = await _mongoDatabase.fetchTotalAccountBalance(collectionName: collectionName);
      return totalStockValue;
    } catch (e) {
      rethrow;
    }
  }
}