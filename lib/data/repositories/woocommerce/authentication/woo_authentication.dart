import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../features/personalization/models/user_model.dart';
import '../../../../utils/constants/api_constants.dart';

class WooAuthenticationRepository extends GetxController {
  static WooAuthenticationRepository get instance => Get.find();

  Future<UserModel> singUpWithEmailAndPass(Map<String, dynamic> newCustomerData) async {
    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooCustomersApiPath,
      );

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APIConstant.authorization,
        },
        body: jsonEncode(newCustomerData),
      );

      // Check if the request was successful
      if (response.statusCode == 201) {
        final Map<String, dynamic> customerJson = json.decode(response.body);
        final UserModel customer = UserModel.fromJson(customerJson);
        return customer;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to create customer';
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<String> loginWithEmailAndPass(String email, String password) async {
    try {
      final Map<String, String> requestBody = {
        'email': email,
        'password': password,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooAuthenticatePath,
      );

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final bool success = responseData['success'];
        final String message = responseData['message'];
        final String userId = responseData['user_id'].toString();

        if (success) {
          // Authentication was successful
          return userId;
        } else {
          // Authentication failed
          throw message;
        }
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to login customer';
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> resetPasswordWithEmail(String email) async {
    try {
      final Map<String, String> requestBody = {
        'email': email,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooResetPassword,
      );

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final bool success = responseData['success'];
        final String message = responseData['message'];

        if (success) {
          // Password reset email sent successfully
          print(message);
        } else {
          // Password reset failed
          throw message;
        }
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to reset password email';
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<UserModel> deleteCustomerById(String customerId) async {
    try {
      final Map<String, String> queryParams = {
        'force': 'true',
      };
      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooCustomersApiPath+customerId,
        queryParams,
      );

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APIConstant.authorization,
        },
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> customerJson = json.decode(response.body);
        final UserModel customer = UserModel.fromJson(customerJson);
        return customer;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to delete customer';
      }
    } catch (error) {
      rethrow;
    }
  }
}