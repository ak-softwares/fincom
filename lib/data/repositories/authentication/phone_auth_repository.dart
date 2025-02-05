import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/widgets/loaders/loader.dart';
import '../../../features/authentication/screens/phone_otp_login/mobile_login_screen.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import 'authentication_repository.dart';

class PhoneAuthRepository extends GetxController {
  static PhoneAuthRepository get instance => Get.find();

  //variable
  final _auth = FirebaseAuth.instance;
  var verificationId = ''.obs;

  Future<void> phoneAuthentication(String phoneNo) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNo,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
          AuthenticationRepository.instance.isUserLogin.value = true;
        },
        codeSent: (verificationId, resendToken) {
          this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        },
        verificationFailed: (e) {
          if (e.code == 'invalid-phone-number') {
            TLoaders.errorSnackBar(title: 'Oh Snap!', message: 'The provided phone number is not valid');
            // throw 'The provided phone number is not valid';
          } else {
            TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.message ?? '');
            // throw 'Error - ${e.message}';
          }
          Get.off(() => const MobileLoginScreen());
        },

      );
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

  Future<UserCredential> verifyOTP(String otp) async {
    try {
      var credentials = PhoneAuthProvider.credential(verificationId: verificationId.value, smsCode: otp);
      var userCredential = await _auth.signInWithCredential(credentials);
      return userCredential;
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
}