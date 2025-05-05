import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../features/settings/models/settings_model.dart';
import '../../../../utils/constants/api_constants.dart';


class WooSettingsRepositories extends GetxController {
  static WooSettingsRepositories get instance => Get.find();

  //Fetch reviews By product id
  Future<AppSettingsModel> fetchAppSettings() async {
    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooSettings,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> settingsJson = json.decode(response.body);
        return AppSettingsModel.fromJson(settingsJson);
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw Exception(errorMessage ?? 'Failed to fetch App Settings');
      }
    } catch (error) {
      rethrow;
    }
  }
}