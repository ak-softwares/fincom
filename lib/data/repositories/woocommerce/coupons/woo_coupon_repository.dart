import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../features/accounts/models/coupon_model.dart';
import '../../../../utils/constants/api_constants.dart';


class WooCouponRepository extends GetxController {
  static WooCouponRepository get instance => Get.find();

  //Fetch all coupons
  Future<List<CouponModel>> fetchAllCoupons(String page) async {
    try {
      final Map<String, String> queryParams = {
        'orderby': 'title',
        //date, id, include, title and slug. Default is date.
        'per_page': '10',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooCouponsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> couponsJson = json.decode(response.body);
        final List<CouponModel> coupons = couponsJson.map((json) => CouponModel.fromJson(json)).toList();
        return coupons;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Coupon';
      }
    } catch(e){
      rethrow;
    }
  }

  //Fetch coupon by id
  Future<CouponModel> fetchCouponById(String couponID) async {
    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooCouponsApiPath+couponID,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> couponJson = json.decode(response.body);
        final CouponModel coupon = CouponModel.fromJson(couponJson);
        return coupon;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Coupon';
      }
    } catch (error) {
      rethrow;
    }
  }

  //Fetch coupon by code
  Future<CouponModel> fetchCouponByCode(String code) async {
    try {
      final Map<String, String> queryParams = {
        'code': code,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooCouponsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> couponsJson = json.decode(response.body);
        if(couponsJson.isNotEmpty){
          final CouponModel coupon = CouponModel.fromJson(couponsJson.first);
          return coupon;
        } else{
          throw 'No Coupon found! Please try again';
        }
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Coupon';
      }
    } catch (error) {
      rethrow;
    }
  }
}