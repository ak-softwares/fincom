import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../features/accounts/models/banner_model.dart';
import '../../../../utils/constants/api_constants.dart';


class WooBannersRepositories extends GetxController {
  static WooBannersRepositories get instance => Get.find();

  //Fetch reviews By product id
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooBanners,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> bannersJson = responseJson['banners'] ?? [];
        final List<BannerModel> banners = bannersJson.map((json) => BannerModel.fromJson(json)).toList();
        return banners;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw Exception(errorMessage ?? 'Failed to fetch Banners');
      }
    } catch (error) {
      rethrow;
    }
  }
}