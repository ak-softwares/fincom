import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/local_storage_constants.dart';
import '../../../authentication/controllers/phone_otp_controller/phone_otp_controller.dart';
import '../../../personalization/controllers/change_profile_controller.dart';
import '../../../personalization/models/user_model.dart';

class IsFirstRunController extends GetxController {
  static IsFirstRunController get instance => Get.find();

  static final localStorage = GetStorage();

  static final oTPController = Get.put(OTPController());
  static final changeProfileController = Get.put(ChangeProfileController());


  static bool isFirstRun() {
    return localStorage.read(LocalStorage.isFirstRun) ?? true;
  }

  static void updateIsFirstRun() {
    localStorage.write(LocalStorage.isFirstRun, false);
  }

  static Future<void> activation(CustomerModel customer) async {
    try {
      final userId = customer.customerId.toString();

      // update fcm token to user meta in wordpress
      final fCMToken = await FirebaseMessaging.instance.getToken() ?? '';
      await changeProfileController.wooUpdateUserMeta(userId: userId, key: CustomerMetaDataName.fCMToken, value: fCMToken);

      // set phone verified status to user meta in wordpress
      final isPhoneVerified = oTPController.isPhoneVerified.value;
      if(isPhoneVerified) {
        await changeProfileController.wooUpdateUserMeta(userId: userId, key: CustomerMetaDataName.verifyPhone, value: true);
      }
      // set
      updateIsFirstRun();
    }catch(e){
      if (kDebugMode) {
        print("3.1======================${e.toString()}");
      }
    }
  }

}