import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../features/shop/models/payment_method.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../database/mongodb/mongodb.dart';

class MongoPaymentMethodsRepo extends GetxController {
  final MongoDatabase _mongoDatabase = MongoDatabase();
  final String collectionName = 'payments';
  final int itemsPerPage = int.tryParse(APIConstant.itemsPerPage) ?? 10;

  // Fetch products by search query & pagination
  Future<List<PaymentMethodModel>> fetchPaymentsBySearchQuery({required String query, int page = 1}) async {
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
      final List<PaymentMethodModel> payments = paymentsData.map((data) => PaymentMethodModel.fromJson(data)).toList();
      return payments;
    } catch (e) {
      throw 'Failed to fetch Vendors: $e';
    }
  }

  // Fetch All Products from MongoDB
  Future<List<PaymentMethodModel>> fetchAllPaymentMethod({int page = 1}) async {
    try {
      // Fetch products from MongoDB with pagination
      final List<Map<String, dynamic>> paymentMethodData =
      await _mongoDatabase.fetchDocuments(collectionName:collectionName, page: page);
      // Convert data to a list of ProductModel
      final List<PaymentMethodModel> paymentMethod = paymentMethodData.map((data) => PaymentMethodModel.fromJson(data)).toList();
      return paymentMethod;
    } catch (e) {
      throw 'Failed to fetch payment method: $e';
    }
  }

  // Upload multiple products
  Future<void> pushPaymentMethod({required PaymentMethodModel paymentMethod}) async {
    try {
      Map<String, dynamic> paymentMap = paymentMethod.toMap(); // Convert a single vendor to a map
      await _mongoDatabase.insertDocument(collectionName, paymentMap);
    } catch (e) {
      throw 'Failed to upload payment: $e';
    }
  }

}