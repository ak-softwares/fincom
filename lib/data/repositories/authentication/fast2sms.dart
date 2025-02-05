import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../utils/constants/api_constants.dart';


class Fast2SmsRepository extends GetxController {
  static Fast2SmsRepository get instance => Get.find();

  Future<void> fast2SmsSendOTP(Map<String, dynamic> otpBody) async {
    try {
      final Uri uri = Uri.https(
          'www.fast2sms.com', // authority
          '/dev/bulkV2', // unencodedPath
      );

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APIConstant.fast2smsToken,
        },
        body: jsonEncode(otpBody),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> otpJson = json.decode(response.body);
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to send otp';
      }
    } catch (error) {
      rethrow;
    }
  }

}