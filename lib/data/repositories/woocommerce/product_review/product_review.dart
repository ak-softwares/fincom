import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../features/accounts/models/product_review_model.dart';
import '../../../../utils/constants/api_constants.dart';


class WooReviewRepository extends GetxController {
  static WooReviewRepository get instance => Get.find();

  //Fetch reviews By product id
  Future<List<ReviewModel>> fetchReviewsByProductId({required String productIds, required String page}) async {
    try {
      final Map<String, String> queryParams = {
        'product': productIds,
        'per_page': '10',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooProductsReviewImage,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> reviewsJson = json.decode(response.body);
        final List<ReviewModel> reviews = reviewsJson.map((json) =>
            ReviewModel.fromJson(json)).toList();
        return reviews;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw Exception(errorMessage ?? 'Failed to fetch reviews');
      }
    } catch (error) {
      rethrow;
    }
  }

  //Submit reviews By product id
  Future<ReviewModel> submitReview(Map<String, dynamic> reviewData) async {
    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooProductsReview,
      );
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APIConstant.authorization,
        },
        body: jsonEncode(reviewData),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> reviewsJson = json.decode(response.body);
        final ReviewModel reviews = ReviewModel.fromJson(reviewsJson);
        return reviews;
      }else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw Exception(errorMessage ?? 'Failed to create reviews');
      }
    } catch (error) {
      rethrow;
    }
  }

  //Delete reviews By review id
  Future<bool> deleteSelectedReview(int reviewId) async {
    try {
      final Map<String, String> queryParams = {
        'force': 'true',
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooProductsReview + reviewId.toString(),
        queryParams,
      );
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> reviewsJson = json.decode(response.body);
        return true;
      }else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw Exception(errorMessage ?? 'Failed to create reviews');
      }
    } catch (error) {
      rethrow;
    }
  }

  //update reviews By review id
  Future<bool> updateSelectedReview(int reviewId, Map<String, dynamic> reviewData) async {
    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooProductsReview + reviewId.toString(),
      );
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APIConstant.authorization,
        },
        body: jsonEncode(reviewData),
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> reviewsJson = json.decode(response.body);
        return true;
      }else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw Exception(errorMessage ?? 'Failed to update reviews');
      }
    } catch (error) {
      rethrow;
    }
  }
}