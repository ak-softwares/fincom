import 'dart:async';
import 'package:get/get.dart';

import '../../../../features/personalization/models/user_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/enums.dart';
import '../../../database/mongodb/mongodb.dart';

class MongoUserRepository extends GetxController {
  static MongoUserRepository get instance => Get.find();
  final MongoDatabase _mongoDatabase = MongoDatabase();
  final String collectionName = 'users';
  final int itemsPerPage = int.tryParse(APIConstant.itemsPerPage) ?? 10;

  // Fetch products by search query & pagination
  Future<List<UserModel>> fetchUsersBySearchQuery({required String query, required UserType userType, int page = 1}) async {
    try {
      // Fetch products from MongoDB with search and pagination
      final List<Map<String, dynamic>> customersData = await _mongoDatabase.fetchDocumentsBySearchQuery(
          collectionName: collectionName,
          query: query,
          itemsPerPage: itemsPerPage,
          page: page,
          filter: {UserFieldConstants.userType: userType.name},
      );

      // Convert data to a list of ProductModel
      final List<UserModel> customers = customersData.map((data) => UserModel.fromJson(data)).toList();
      return customers;
    } catch (e) {
      throw 'Failed to fetch products: $e';
    }
  }

  // Fetch All Products from MongoDB
  Future<List<UserModel>> fetchUsers({required UserType userType, int page = 1}) async {
    try {
      // Fetch products from MongoDB with pagination
      final List<Map<String, dynamic>> usersData =
          await _mongoDatabase.fetchDocuments(
              collectionName:collectionName,
              filter: {UserFieldConstants.userType: userType.name},
              page: page
          );

      // Convert data to a list of ProductModel
      final List<UserModel> users = usersData.map((data) => UserModel.fromJson(data)).toList();
      return users;
    } catch (e) {
      throw 'Failed to fetch user: $e';
    }
  }

  // Fetch Customer's IDs from MongoDB
  Future<Set<int>> fetchUserIds() async {
    try {
      // Fetch product IDs from MongoDB
      return await _mongoDatabase.fetchCollectionIds(collectionName);
    } catch (e) {
      throw 'Failed to fetch Customers IDs: $e';
    }
  }

  // Get the total count of customers in the collection
  Future<int> fetchUserCount() async {
    try {
      int count = await _mongoDatabase.fetchCollectionCount(collectionName);
      return count;
    } catch (e) {
      throw 'Failed to fetch customer count: $e';
    }
  }

  // Update a customer
  Future<void> updateUser({required UserModel user}) async {
    try {
      Map<String, dynamic> customerMap = user.toMap();
      await _mongoDatabase.updateDocumentById(
          id: user.id ?? '',
          collectionName: collectionName,
          updatedData: customerMap
      );
    } catch (e) {
      throw 'Failed to update customer: $e';
    }
  }

  // Update a customer
  Future<void> updateUserBalance({required int userID, required double balance, required bool isAddition}) async {
    try {
      await _mongoDatabase.updateUserBalanceById(
          collectionName: collectionName,
          id: userID,
          balance: balance,
          isAddition: isAddition,
      );
    } catch (e) {
      throw 'Failed to update customer: $e';
    }
  }

  // Upload multiple products
  Future<void> insertUsers({required List<UserModel> customers}) async {
    try {
      List<Map<String, dynamic>> customersMaps = customers.map((customer) => customer.toMap()).toList();
      await _mongoDatabase.insertDocuments(collectionName, customersMaps); // Use batch insert function
    } catch (e) {
      throw 'Failed to upload customers: $e';
    }
  }

  // Add a new customer
  Future<void> insertUser({required UserModel customer}) async {
    try {
      Map<String, dynamic> customerMap = customer.toMap(); // Convert customer model to map
      await _mongoDatabase.insertDocument(collectionName, customerMap);
    } catch (e) {
      throw 'Failed to add customer: $e';
    }
  }

  Future<UserModel> fetchUserById({required String id}) async {
    try {
      // Fetch a single document by ID
      final Map<String, dynamic>? customerData =
      await _mongoDatabase.fetchDocumentById(collectionName: collectionName, id: id);

      // Check if the document exists
      if (customerData == null) {
        throw Exception('Customer not found with ID: $id');
      }

      // Convert the document to a CustomerModel object
      final UserModel customer = UserModel.fromJson(customerData);
      return customer;
    } catch (e) {
      throw 'Failed to fetch customer: $e';
    }
  }

  Future<void> deleteUserById({required String id}) async {
    try {
      await _mongoDatabase.deleteDocumentById(id: id, collectionName: collectionName);
    } catch (e) {
      throw 'Failed to delete customer: $e';
    }
  }

  // Get the next customer ID
  Future<int> fetchUserGetNextId({required UserType userType}) async {
    try {
      int nextID = await _mongoDatabase.getNextId(
          collectionName: collectionName,
          fieldName: UserFieldConstants.userId,
          filter: {UserFieldConstants.userType: userType.name},
      );
      return nextID;
    } catch (e) {
      throw 'Failed to fetch customer ID: $e';
    }
  }

  // Fetch All Products from MongoDB
  Future<double> calculateAccountPayable({required UserType userType}) async {
    try {
      // Fetch products from MongoDB with pagination
      final double totalAccountPayable = await _mongoDatabase.calculateAccountPayable(
        collectionName: collectionName,
        filter: {UserFieldConstants.userType: userType.name},
      );
      return totalAccountPayable;
    } catch (e) {
      rethrow;
    }
  }
}
