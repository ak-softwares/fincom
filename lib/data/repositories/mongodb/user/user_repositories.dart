import 'package:get/get.dart';

import '../../../../features/personalization/models/user_model.dart';
import '../../../../utils/helpers/encryption_hepler.dart';
import '../../../database/mongodb/mongodb.dart';

class MongoAuthenticationRepository extends GetxController {
  static MongoAuthenticationRepository get instance => Get.find();
  final MongoDatabase _mongoDatabase = MongoDatabase();
  final String collectionName = 'users';

  // Upload multiple products
  Future<void> singUpWithEmailAndPass({required UserModel user}) async {
    try {
      // Check if a user with the same email or phone already exists
      final existingUser = await _mongoDatabase.findOne(
        collectionName: collectionName,
       query : {
                  r'$or': [
                    {'email': user.email},
                    {'phone': user.phone},
                  ]
                },
      );

      if (existingUser != null) {
        throw 'Email or phone number already exists';
      }

      List<Map<String, dynamic>> userMap = [user.toMap()];
      await _mongoDatabase.insertDocuments(collectionName, userMap); // Use batch insert function
    } catch (e) {
      throw 'Failed to create account: $e';
    }
  }

  // Upload multiple products
  Future<UserModel> loginWithEmailAndPass({required String email, required String password}) async {
    try {
      // Check if a user with the provided email exists
      final existingUser = await _mongoDatabase.findOne(
        collectionName: collectionName,
        query : {'email': email}, // Find user by email
      );

      if (existingUser == null) {
        throw 'Invalid email or password'; // User not found
      }

      // Verify password using bcrypt
      if (!EncryptionHelper.comparePasswords(plainPassword: password, hashedPassword: existingUser['password'])) {//EncryptionHelper.
        throw 'Invalid email or password'; // Incorrect password
      }

      // Convert data to a UserModel
      final UserModel user = UserModel.fromJson(existingUser);
      return user; // Return the user object

      // User authenticated successfully (proceed with login session)
    } catch (e) {
      throw 'Failed login: $e';
    }
  }

  // Upload multiple products
  Future<UserModel> fetchCustomerByPhone({required String phone}) async {
    try {
      // Check if a user with the provided email exists
      final existingUser = await _mongoDatabase.findOne(
        collectionName: collectionName,
       query : {'phone': phone}, // Find user by email
      );

      if (existingUser == null) {
        throw 'Invalid user found for this phone number'; // User not found
      }

      // Convert data to a UserModel
      final UserModel user = UserModel.fromJson(existingUser);
      return user; // Return the user object

      // User authenticated successfully (proceed with login session)
    } catch (e) {
      throw 'Failed login: $e';
    }
  }

  // Upload multiple products
  Future<UserModel> fetchCustomerByEmail({required String email}) async {
    try {
      // Check if a user with the provided email exists
      final existingUser = await _mongoDatabase.findOne(
        collectionName: collectionName,
        query: {'email': email}, // Find user by email
      );

      if (existingUser == null) {
        throw 'Invalid user found for this email'; // User not found
      }

      // Convert data to a UserModel
      final UserModel user = UserModel.fromJson(existingUser);
      return user; // Return the user object

      // User authenticated successfully (proceed with login session)
    } catch (e) {
      throw 'Failed login: $e';
    }
  }

  // Update a user document in a collection
  Future<void> updateUserByEmail({required String email, required UserModel user}) async {
    try {
      // Check if a user with the provided email exists
      final existingUser = await _mongoDatabase.findOne(
          collectionName: collectionName,
          query: {'email': email});

      if (existingUser == null) {
        throw 'Invalid user found for this email'; // User not found
      }

      // Update user data in the database
      await _mongoDatabase.updateDocument(
        collectionName: collectionName,
        filter: {'email': email},
        updatedData: user.toMap()
      );
    } catch (e) {
      throw 'Failed to update user: $e';
    }
  }


}