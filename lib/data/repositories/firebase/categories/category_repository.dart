import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../features/shop/models/category_model.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/format_exceptions.dart';


class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  //Variables
  final _db = FirebaseFirestore.instance;

  //get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try{
      final snapshot = await _db.collection(DbCollections.categories).get();
      final list = snapshot.docs.map((document) => CategoryModel.fromSnapshot(document)).toList();
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

  // get sub categories

  // upload Categories to the cloud firebase
  // Future<void> uploadDummyData(List<CategoryModel> categories) async {
  //   try{
  //     ///upload all the categories along with their Images
  //     final storage = Get.put(TFirebaseStorageService());
  //
  //     //Loop through each category
  //     for(var category in categories) {
  //       //get ImageData link from the local assets
  //       final file = await storage.getImageDataFromAssets(category.image);
  //
  //       //upload Image and get its URL
  //       final url = await storage.uploadImageData('Categories', file, categories.name);
  //
  //       //Assign URL to Category.image attribute
  //       category.image = url;
  //
  //       //Store Category in FireStore
  //       await _db.collection('Categories').doc(category.id).set(categories.toJson());
  //     }
  //   } on FirebaseException catch (error) {
  //     throw TFirebaseAuthException(error.code).message;
  //   } on PlatformException catch (error) {
  //     throw TFirebaseAuthException(error.code).message;
  //   }
  //   catch (error) {
  //     throw 'Something went wrong. Please try again $error';
  //   }
  // }
  
}