import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../features/accounts/models/brand_model.dart';
import '../../../../utils/constants/api_constants.dart';

class WooProductBrandsRepository extends GetxController {
  static WooProductBrandsRepository get instance => Get.find();

  //Fetch All Products
  Future<List<BrandModel>> fetchAllBrands({required String page}) async {
    try {
      final Map<String, String> queryParams = {
        'orderby': 'name', // id, include, name, slug, term_group, description, and count
        'per_page': '20',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooProductBrandsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> productBrandsJson = json.decode(response.body);
        final List<BrandModel> productBrands = productBrandsJson.map((json) => BrandModel.fromJson(json)).toList();
        return productBrands;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Brands';
      }
    } catch (error) {
      if (error is TimeoutException) {
        throw 'Connection timed out. Please check your internet connection and try again.';
      } else {
        rethrow;
      }
    }
  }
}