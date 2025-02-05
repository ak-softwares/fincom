import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../features/personalization/models/user_model.dart';
import '../../../utils/constants/db_constants.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../services/auto_increment_service.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<String> getUserDocId() async {
    try {
      final currentUserUID = _auth.currentUser?.uid;
      if (currentUserUID != null) {
        final querySnapshot = await _db.collection(DbCollections.users).where(UserFieldName.userId, isEqualTo: currentUserUID).limit(1).get();
        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first.id;
        }
      }
      return ''; // Return empty string if no document found
    } catch (e) {
      return ''; // Return empty string in case of error
    }
  }


  //Function to save user data to FireStore.
  Future<void> saveUserRecord(UserModel user) async {
    try {
      // Call getNextUserId function
      int nextUserId = await AutoIncrementService().getNextCounter(MetaFieldName.userCounter);

      if (nextUserId != 0) {
        await FirebaseFirestore.instance.collection(DbCollections.users).doc(nextUserId.toString()).set(user.toJson());
      } else {
        throw 'Failed to generate user ID';
      }
    } on FirebaseAuthException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } catch (error) {
      throw 'Something went wrong. $error';
    }
  }

  //Function to update user MetaData in Firestore.
  Future<void> updateMetaData(String fieldName, List<dynamic> newItems) async {
    try {
      await _db.collection(DbCollections.users).doc(await getUserDocId()).update({
        '${UserFieldName.metaData}.$fieldName.${UserFieldName.items}': newItems,
        '${UserFieldName.metaData}.$fieldName.${UserFieldName.dateModified}': Timestamp.now().toDate(),
      });
    } catch (e) {
      rethrow;
    }
  }

  //Function to update user MetaData in Firestore.
  Future<void> appendMetaData(String fieldName, String newItems) async {
    try {
      await _db.collection(DbCollections.users).doc(await getUserDocId()).update({
        '${UserFieldName.metaData}.$fieldName.${UserFieldName.items}': FieldValue.arrayUnion([newItems]),
        '${UserFieldName.metaData}.$fieldName.${UserFieldName.dateModified}': Timestamp.now().toDate(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// function to fetch user details based on user id
  Future<UserModel> fetchUserDetails() async {
    try{
      final documentSnapShot = await _db.collection(DbCollections.users).doc(await getUserDocId()).get();
      if(documentSnapShot.exists) {
        return UserModel.fromSnapshot(documentSnapShot);
      }else {
        return UserModel.empty();
      }
    }
    catch (error) {
      return UserModel.empty();
    }
  }

  /// Function to update user data in firebase
  Future<void> updateUserDetails(UserModel updateUser) async {
    try{
      await _db.collection(DbCollections.users).doc(await getUserDocId()).update(updateUser.toJson());
    }
    on FirebaseAuthException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to update user data in firebase
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try{
      await _db.collection(DbCollections.users).doc(await getUserDocId()).update(json);
    }
    on FirebaseAuthException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to remove user data in firebase
  Future<void> removeUserRecord(String userId) async {
    try{
      await _db.collection(DbCollections.users).doc(userId).delete();
    }
    on FirebaseAuthException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// upload user image
  Future<String> uploadImage(String path, XFile image) async {
    try{
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again';
    }
  }
}