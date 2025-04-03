import 'dart:async';
import 'package:get/get.dart';

import '../../../../features/personalization/models/user_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../database/mongodb/mongodb.dart';

class MongoCustomersRepo extends GetxController {
  static MongoCustomersRepo get instance => Get.find();
  final MongoDatabase _mongoDatabase = MongoDatabase();
  final String collectionName = 'customers';
  final int itemsPerPage = int.tryParse(APIConstant.itemsPerPage) ?? 10;

  // Fetch products by search query & pagination
  Future<List<CustomerModel>> fetchCustomersBySearchQuery({required String query, int page = 1}) async {
    try {
      // Fetch products from MongoDB with search and pagination
      final List<Map<String, dynamic>> customersData =
          await _mongoDatabase.fetchDocumentsBySearchQuery(
              collectionName: collectionName,
              query: query,
              itemsPerPage: itemsPerPage,
              page: page
          );

      // Convert data to a list of ProductModel
      final List<CustomerModel> customers = customersData.map((data) => CustomerModel.fromJson(data)).toList();
      return customers;
    } catch (e) {
      throw 'Failed to fetch products: $e';
    }
  }

  // Fetch All Products from MongoDB
  Future<List<CustomerModel>> fetchAllCustomers({int page = 1}) async {
    try {
      // Fetch products from MongoDB with pagination
      final List<Map<String, dynamic>> customersData =
          await _mongoDatabase.fetchDocuments(collectionName:collectionName, page: page);

      // Convert data to a list of ProductModel
      final List<CustomerModel> customers = customersData.map((data) => CustomerModel.fromJson(data)).toList();

      return customers;
    } catch (e) {
      throw 'Failed to fetch customers: $e';
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
  Future<int> fetchCustomerCount() async {
    try {
      int count = await _mongoDatabase.fetchCollectionCount(collectionName);
      return count;
    } catch (e) {
      throw 'Failed to fetch customer count: $e';
    }
  }

  // Update a customer
  Future<void> updateCustomer({required String id, required CustomerModel customer}) async {
    try {
      Map<String, dynamic> customerMap = customer.toMap();
      await _mongoDatabase.updateDocumentById(
          id: id,
          collectionName: collectionName,
          updatedData: customerMap
      );
    } catch (e) {
      throw 'Failed to update customer: $e';
    }
  }

  // Upload multiple products
  Future<void> pushCustomers({required List<CustomerModel> customers}) async {
    try {
      List<Map<String, dynamic>> customersMaps = customers.map((customer) => customer.toMap()).toList();
      await _mongoDatabase.insertDocuments(collectionName, customersMaps); // Use batch insert function
    } catch (e) {
      throw 'Failed to upload customers: $e';
    }
  }

  // Add a new customer
  Future<void> pushCustomer({required CustomerModel customer}) async {
    try {
      Map<String, dynamic> customerMap = customer.toMap(); // Convert customer model to map
      await _mongoDatabase.insertDocument(collectionName, customerMap);
    } catch (e) {
      throw 'Failed to add customer: $e';
    }
  }

  Future<CustomerModel> fetchCustomerById({required String id}) async {
    try {
      // Fetch a single document by ID
      final Map<String, dynamic>? customerData =
      await _mongoDatabase.fetchDocumentById(collectionName: collectionName, id: id);

      // Check if the document exists
      if (customerData == null) {
        throw Exception('Customer not found with ID: $id');
      }

      // Convert the document to a CustomerModel object
      final CustomerModel customer = CustomerModel.fromJson(customerData);
      return customer;
    } catch (e) {
      throw 'Failed to fetch customer: $e';
    }
  }

  Future<void> deleteCustomer({required String id}) async {
    try {
      await _mongoDatabase.deleteDocumentById(id: id, collectionName: collectionName);
    } catch (e) {
      throw 'Failed to delete customer: $e';
    }
  }

  // Get the next customer ID
  Future<int> fetchCustomerGetNextId() async {
    try {
      int nextID = await _mongoDatabase.getNextId(
          collectionName: collectionName,
          fieldName: CustomerFieldName.customerId
      );
      return nextID;
    } catch (e) {
      throw 'Failed to fetch customer ID: $e';
    }
  }


}
