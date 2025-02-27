import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/authentication/phone_auth_repository.dart';
import '../../../../data/repositories/authentication/fast2sms.dart';
import '../../../../data/repositories/mongodb/user/user_repositories.dart';
import '../../../../data/repositories/woocommerce_repositories/customers/woo_customer_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/validators/validation.dart';
import '../../../personalization/models/user_model.dart';
import '../../screens/create_account/signup.dart';
import '../../screens/phone_otp_login/enter_otp_screen.dart';
import '../create_account_controller/signup_controller.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  Rx<bool> isLoading = false.obs;
  Rx<bool> isPhoneVerified = false.obs;
  Rx<String> countryCode = ''.obs;
  Rx<String> phoneNumber = ''.obs;

  final otp = TextEditingController();
  String saveGenerateOTP = '';

  final phoneAuthRepository = Get.put(PhoneAuthRepository());
  final fast2SmsRepository = Get.put(Fast2SmsRepository());
  final wooCustomersRepository = Get.put(WooCustomersRepository());
  final mongoAuthenticationRepository = Get.put(MongoAuthenticationRepository());
  final authenticationRepository = AuthenticationRepository.instance;


  @override
  void onClose() {
    super.onClose();
    otp.dispose();
    // SmsAutoFill().unregisterListener();
  }

  // void initSmsAutoFill() async {
  //   // Request permission if not granted
  //   final permissionStatus = await RequestPermissions.checkPermission(Permission.sms);
  //   if (permissionStatus) {
  //     // Get app signature
  //     final signature = await SmsAutoFill().getAppSignature;
  //     // Start listening for SMS code
  //     SmsAutoFill().listenForCode;
  //   } else {
  //     // Handle permission denied
  //     Get.snackbar('Permission Denied', 'SMS permission is required');
  //     // RequestPermissions.showPermissionDialog(context);
  //   }
  // }

  // only for india
  Future<void> fast2SmsSendOpt({required String phone}) async {
    try {
      isLoading(true);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(title: 'No Internet', message: 'Please check your internet connection.');
        return;
      }

      String? formattedPhone = TValidator.getFormattedTenDigitNumber(phone);
      if (formattedPhone == null) {
        TLoaders.errorSnackBar(title: 'Error', message: 'No 10-digit number found');
        return;
      }

      String generateOTP() => (Random().nextInt(9000) + 1000).toString();
      saveGenerateOTP = generateOTP();
      Map<String, dynamic> otpData = {
        'route': 'otp',
        'variables_values': saveGenerateOTP,
        'numbers': phone,
      };

      await fast2SmsRepository.fast2SmsSendOTP(otpData);
      Get.to(() => const EnterOTPScreen());

    } catch (error) {
      //show some Generic error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> verifyOTPFast2sms(String otp) async {
    String googlePhone = ''; // Initialize with an empty string
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('Logging you in...', Images.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //verify otp
      if (saveGenerateOTP != otp) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Error', message: 'Invalid OTP');
        return;
      }

      googlePhone = phoneNumber.value;
      String? formattedPhone = TValidator.getFormattedTenDigitNumber(googlePhone);
      if (formattedPhone == null) {
        TFullScreenLoader.stopLoading();
        TLoaders.errorSnackBar(title: 'Error', message: 'No 10-digit number found');
        return;
      }

      final UserModel user = await mongoAuthenticationRepository.fetchCustomerByPhone(phone: formattedPhone);

      isPhoneVerified.value = true;
      TFullScreenLoader.stopLoading();
      authenticationRepository.login(user: user);
    } catch (error) {
      // Remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: error.toString());
    }
  }



  // these function for firebase
  Future<void> phoneAuthentication(String countryCode, String phone) async {
    try {
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(title: 'No Internet', message: 'Please check your internet connection.');
        return;
      }
      String? formattedPhone = TValidator.getFormattedTenDigitNumber(phone);
      if (formattedPhone == null) {
        TLoaders.errorSnackBar(title: 'Error', message: 'No 10-digit number found');
        return;
      }

    await phoneAuthRepository.phoneAuthentication('+$countryCode$formattedPhone');
    Get.to(() => const EnterOTPScreen());

    } catch (error) {
      //show some Generic error to the user
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    }
  }

  Future<void> verifyOTP(String otp) async {
    String googlePhone = ''; // Initialize with an empty string
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('Logging you in...', Images.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Google Authentication
      final userCredentials = await phoneAuthRepository.verifyOTP(otp);
      googlePhone = userCredentials.user?.phoneNumber ?? '';
      String? formattedPhone = TValidator.getFormattedTenDigitNumber(googlePhone);
      if (formattedPhone == null) {
        TLoaders.errorSnackBar(title: 'Error', message: 'No 10-digit number found');
        return;
      }

      final userId = await wooCustomersRepository.fetchCustomerByPhone(formattedPhone);
      final CustomerModel customer = await wooCustomersRepository.fetchCustomerById(userId);

      TFullScreenLoader.stopLoading();
      // authenticationRepository.login(customer: customer, loginMethod: 'PhoneOTP');
    } catch (error) {
      // Remove Loader
      TFullScreenLoader.stopLoading();
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      if (error.toString().contains('Customer not found')) {
        Get.put(SignupController()).phone.text = googlePhone; // Now 'googleEmail' is accessible here
        Get.to(() => SignUpScreen());
      } else {
        TLoaders.errorSnackBar(title: 'Error', message: error.toString());
      }
    }
  }
}