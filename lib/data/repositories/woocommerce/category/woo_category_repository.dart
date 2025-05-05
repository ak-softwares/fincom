
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../features/accounts/models/category_model.dart';
import '../../../../utils/constants/api_constants.dart';


class WooCategoryRepository extends GetxController {
  static WooCategoryRepository get instance => Get.find();

  //Fetch all categories
  Future<List<CategoryModel>> fetchAllCategory(String page) async {
    try {
      final Map<String, String> queryParams = {
        'orderby': 'name', //id, include, name, slug, term_group, description, count. Default is name.
        'per_page': '20',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooCategoriesApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        // Uri.parse('https://aramarket.in/wp-json/wc/v3/products?category=246&orderby=popularity'),
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = json.decode(response.body);
        final List<CategoryModel> categories = categoriesJson.map((json) => CategoryModel.fromJson(json)).toList();
        return categories;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Categories';
      }
    } catch(e) {
      rethrow;
    }
  }

  //Fetch Category by Slug
  Future<CategoryModel> fetchCategoryBySlug(String slug) async {
    try {
      final Map<String, String> queryParams = {
        'slug': slug, //id, include, name, slug, term_group, description, count. Default is name.
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooCategoriesApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        // Uri.parse('https://aramarket.in/wp-json/wc/v3/products?category=246&orderby=popularity'),
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {

        final List<dynamic> categoriesJson = json.decode(response.body);
        if(categoriesJson.isNotEmpty){
          final CategoryModel category = CategoryModel.fromJson(categoriesJson.first);
          return category;
        } else{
          throw 'No Product found! Please try again';
        }
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Categories';
      }
    } catch(e) {
      rethrow;
    }
  }
}