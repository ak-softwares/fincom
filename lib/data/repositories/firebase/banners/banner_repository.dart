import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../features/shop/models/banner_model.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/format_exceptions.dart';


class BannerRepository extends GetxController {
  static BannerRepository get instance => Get.find();

  //variables
  final _db = FirebaseFirestore.instance;

  //get all banners
  Future<List<BannerModel>> fetchBanners() async {
    try{
      final result = await _db.collection(DbCollections.banners).where(BannerFieldName.active, isEqualTo: true).get();
      final list = result.docs.map((document) => BannerModel.fromSnapshot(document)).toList();
      return list;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again $error';
    }
  }
}