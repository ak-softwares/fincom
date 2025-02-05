import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../features/shop/models/product_model.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/exceptions/firebase_exceptions.dart';
import '../../../../utils/exceptions/platform_exceptions.dart';


class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  //fireStore instance for database interactions.
  final _db = FirebaseFirestore.instance;

  //Fetch All products
  Future<List<ProductModel>> fetchAllProducts() async {
    try{
      final snapshot = await _db.collection(DbCollections.products).get();
      return snapshot.docs.map((document) => ProductModel.fromSnapshot(document)).toList();
    } on FirebaseException catch (error) {
      throw TFirebaseException(error.code).message;
    } on PlatformException catch (error) {
      throw TPlatformException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again $error';
    }
  }

  //Fetch products by category id
  Future<List<ProductModel>> fetchProductsByCategoryId(String categoryId) async {
    try{
      final snapshot = await _db.collection(DbCollections.products)
          .where(ProductFieldName.id, isEqualTo: categoryId).get();
      final List<ProductModel> productsByCategory =
      snapshot.docs.map((document) => ProductModel.fromSnapshot(document)).toList();
      return productsByCategory;
    } on FirebaseException catch (error) {
      throw TFirebaseException(error.code).message;
    } on PlatformException catch (error) {
      throw TPlatformException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again $error';
    }
  }

  //Get limited featured products
  Future<List<ProductModel>> getFeaturedProducts() async {
    try{
      final snapshot = await _db.collection(DbCollections.products)
          .where(ProductFieldName.featured, isEqualTo: true).limit(4).get();
      return snapshot.docs.map((document) => ProductModel.fromSnapshot(document)).toList();

    } on FirebaseException catch (error) {
      throw TFirebaseException(error.code).message;
    } on PlatformException catch (error) {
      throw TPlatformException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again $error';
    }
  }

  //Get products based on the Query
  Future<List<ProductModel>> fetchProductsByQuery(Query query) async {
    try{
      final querySnapshot = await query.get();
      final List<ProductModel> productList = querySnapshot.docs.map((document) =>
          ProductModel.fromQuerySnapshot(document)).toList();
      return productList;
    } on FirebaseException catch (error) {
      throw TFirebaseException(error.code).message;
    } on PlatformException catch (error) {
      throw TPlatformException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again $error';
    }
  }

  //Get favorite products based on the ID
  Future<List<ProductModel>> fetchProductsByIds(List<String> productIds) async {
    try{
      final snapshot = await _db.collection(DbCollections.products)
          .where(FieldPath.documentId, whereIn: productIds).get();
      final List<ProductModel> favoriteProductList =
          snapshot.docs.map((document) => ProductModel.fromSnapshot(document)).toList();
      return favoriteProductList;
    } on FirebaseException catch (error) {
      throw TFirebaseException(error.code).message;
    } on PlatformException catch (error) {
      throw TPlatformException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again $error';
    }
  }

  //Get Product based on the Brand
  Future<List<ProductModel>> fetchProductByQuery(Query query) async {
    try{
      final querySnapshot = await query.get();
      final List<ProductModel> productList =
          querySnapshot.docs.map((document) => ProductModel.fromQuerySnapshot(document)).toList();
      return productList;
    } on FirebaseException catch (error) {
      throw TFirebaseException(error.code).message;
    } on PlatformException catch (error) {
      throw TPlatformException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again $error';
    }
  }


}