import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../common/navigation_bar/bottom_navigation_bar.dart';
import '../../../common/widgets/loaders/loader.dart';
import '../../../features/onboarding/controllers/is_first_run/is_first_run.dart';
import '../../../features/personalization/controllers/change_profile_controller.dart';
import '../../../features/personalization/controllers/customers_controller.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../services/notification/firebase_notification.dart';
import '../../../utils/constants/db_constants.dart';
import '../../../utils/constants/local_storage_constants.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/helpers/navigation_helper.dart';
import '../user/user_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //variable
  final localStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  RxBool isUserLogin = false.obs;

  ///get Authenticated user data
  User? get authUser => _auth.currentUser;

  /// called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  // Function to show relevant screen
  void screenRedirect() {
    checkIsUserLogin();
    isUserLogin.value ? null : NavigationHelper.navigateToLoginScreen();
  }

  // this function run after successfully login
  Future<void> login({required UserModel user}) async {
    Get.put(CustomersController()).user(user); //update user value
    isUserLogin.value = true; //make user login
    localStorage.write(LocalStorage.authUserID, user.email.toString()); // store token in local storage for stay login
    TLoaders.customToast(message: 'Login successfully!'); //show massage for successful login
    await Future.delayed(Duration(milliseconds: 300)); // Add delay
    NavigationHelper.navigateToBottomNavigation(); //navigate to other screen
  }

  //this function for logout
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      localStorage.remove(LocalStorage.authUserID);
      isUserLogin.value = false;
      CustomersController.instance.user.value = UserModel.empty();
      NavigationHelper.navigateToLoginScreen();
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
      throw 'Something went wrong. Please try again $error';
    }
  }

  // Check if the user is logged in
  void checkIsUserLogin() {
    dynamic localAuthUserId = localStorage.read(LocalStorage.authUserID);
    String userId = (localAuthUserId != null) ? localAuthUserId.toString() : '';
    isUserLogin.value = userId.isNotEmpty;
  }


/* ----------------Email & Password Sign in ------------------*/

  /// [EmailAuthentication] - Login
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      isUserLogin.value = true;
      var userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
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

  /// [EmailAuthentication] - REGISTER
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      isUserLogin.value = true;
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
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

  /// [ReAuthenticate] - ReAuthenticate user
  Future<void> reAuthenticateWithEmailAndPassword(String email, String password) async {
    try {
      //Create a credential
      AuthCredential credential = EmailAuthProvider.credential(
          email: email, password: password);
      //ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
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

  /// [Email Authentication] - Forget password
  Future<void> sendPasswordResetEMail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
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

  /*---------------------- social login_controller ------------------------*/

  /// [Google Authentication] - Google

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      //Obtain the auth details form the request
      final GoogleSignInAuthentication? googleAuth = await userAccount
          ?.authentication;

      //Create a new credential
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      //Once signed in, return the User Credential
      return await _auth.signInWithCredential(credentials);
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
      // rethrow;
      throw 'Something went wrong. Please try again';
    }
  }

  /// [Facebook Authentication] - Facebook

  /*-------------------------- logout user / delete user -------------*/

  /// [Logout user] - valid for any authentication


  /// [Delete user] - Remove user auth and firebase account
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser!.delete();
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

