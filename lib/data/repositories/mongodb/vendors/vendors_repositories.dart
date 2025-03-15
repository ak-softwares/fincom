import 'dart:async';
import 'package:get/get.dart';

import '../../../../features/personalization/models/user_model.dart';
import '../../../../features/shop/models/vendor_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../database/mongodb/mongodb.dart';

class MongoVendorsRepo extends GetxController {
  final MongoDatabase _mongoDatabase = MongoDatabase();
  final String collectionName = 'vendors';
  final int itemsPerPage = int.tryParse(APIConstant.itemsPerPage) ?? 10;

  // Fetch products by search query & pagination
  Future<List<VendorModel>> fetchVendorsBySearchQuery({required String query, int page = 1}) async {
    try {
      // Fetch products from MongoDB with search and pagination
      final List<Map<String, dynamic>> vendorsData =
          await _mongoDatabase.fetchDocumentsBySearchQuery(
              collectionName: collectionName,
              query: query,
              itemsPerPage: itemsPerPage,
              page: page
          );
      // Convert data to a list of ProductModel
      final List<VendorModel> vendors = vendorsData.map((data) => VendorModel.fromJson(data)).toList();
      return vendors;
    } catch (e) {
      throw 'Failed to fetch Vendors: $e';
    }
  }

  // Fetch All Products from MongoDB
  Future<List<VendorModel>> fetchAllVendors({int page = 1}) async {
    try {
      // Fetch products from MongoDB with pagination
      final List<Map<String, dynamic>> vendorsData =
          await _mongoDatabase.fetchDocuments(collectionName:collectionName, page: page);
      // Convert data to a list of ProductModel
      final List<VendorModel> vendors = vendorsData.map((data) => VendorModel.fromJson(data)).toList();
      return vendors;
    } catch (e) {
      throw 'Failed to fetch vendors: $e';
    }
  }

  // Fetch Customer's IDs from MongoDB
  Future<Set<int>> fetchCustomersIds() async {
    try {
      // Fetch product IDs from MongoDB
      return await _mongoDatabase.fetchCollectionIds(collectionName);
    } catch (e) {
      throw 'Failed to fetch Customers IDs: $e';
    }
  }

  // Get the total count of customers in the collection
  Future<int> fetchVendorCount() async {
    try {
      int count = await _mongoDatabase.fetchCollectionCount(collectionName);
      return count;
    } catch (e) {
      throw 'Failed to fetch Vendor count: $e';
    }
  }

  // Upload multiple products
  Future<void> pushVendor({required VendorModel vendor}) async {
    try {
      Map<String, dynamic> vendorMap = vendor.toMap(); // Convert a single vendor to a map
      await _mongoDatabase.insertDocument(collectionName, vendorMap);
    } catch (e) {
      throw 'Failed to upload Vendor: $e';
    }
  }
}
