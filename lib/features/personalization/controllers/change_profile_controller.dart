import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../common/text/section_heading.dart';
import '../../../common/widgets/loaders/loader.dart';
import '../../../common/widgets/network_manager/network_manager.dart';
import '../../../data/repositories/mongodb/user/user_repositories.dart';
import '../../../data/repositories/woocommerce_repositories/customers/woo_customer_repository.dart';
import '../../../utils/constants/db_constants.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/local_storage_constants.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../models/user_model.dart';
import '../screens/user_profile/user_profile.dart';
import '/features/personalization/controllers/customers_controller.dart';
import '../../../data/repositories/user/user_repository.dart';

class ChangeProfileController extends GetxController {
  static ChangeProfileController get instance => Get.find();

  ///variables
  final fullName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

  final updatePhone = TextEditingController();
  RxBool isPhoneUpdating = false.obs;
  RxBool isPhoneVerified = true.obs;

  GlobalKey<FormState> changeProfileFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> updatePhoneFormKey = GlobalKey<FormState>();

  final localStorage = GetStorage();
  final userController = Get.put(CustomersController());
  final userRepository = Get.put(UserRepository());
  final wooCustomersRepository = Get.put(WooCustomersRepository());
  final mongoAuthenticationRepository = Get.put(MongoAuthenticationRepository());

  //Woocommerce update profile details
  Future<void> mongoChangeProfileDetails() async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are updating your information..', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!changeProfileFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //update single field user
      final updatedUser = UserModel(
          name: fullName.text.trim(),
          email: email.text.trim(),
          phone: phone.text.trim(),
      );
      await mongoAuthenticationRepository.updateUserByEmail(email: email.text.trim(), user: updatedUser);

      //update the Rx user value
      userController.user(updatedUser);

      // update email to local storage too
      localStorage.write(LocalStorage.rememberMeEmail, email.text.trim());
      //remove Loader
      TFullScreenLoader.stopLoading();
      // UserController.instance.fetchUserRecord();
      TLoaders.customToast(message: 'Details updated successfully!');
      // move to next screen
      Get.close(1);
      Get.off(() => const UserProfileScreen());
    } catch (error) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: error.toString());
    }
  }

  //Woocommerce update profile details
  Future<void> wooChangeProfileDetails() async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are updating your information..', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!changeProfileFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //update single field user
      Map<String, dynamic> updateField = {
        CustomerFieldName.firstName: fullName.text.trim(),
        CustomerFieldName.email: email.text.trim(),
        CustomerFieldName.billing: {
          AddressFieldName.email: email.text.trim(),
          AddressFieldName.phone: phone.text.trim()
        },
      };
      final userId = userController.customer.value.id.toString();
      final CustomerModel customer = await wooCustomersRepository.updateCustomerById(userID: userId, data: updateField);
      //update the Rx user value
      userController.customer(customer);

      // update email to local storage too
      localStorage.write(LocalStorage.rememberMeEmail, email.text.trim());
      //remove Loader
      TFullScreenLoader.stopLoading();
      // UserController.instance.fetchUserRecord();
      TLoaders.customToast(message: 'Details updated successfully!');
      // move to next screen
      Get.close(1);
      Get.off(() => const UserProfileScreen());
    } catch (error) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: error.toString());
    }
  }

  //Woocommerce update phone number
  Future<void> wooUpdatePhoneNo() async {
    try {
      isPhoneUpdating.value = true;
      // Form Validation
      if (!updatePhoneFormKey.currentState!.validate()) {
        isPhoneUpdating.value = false;
        return;
      }
      //update single field user
      Map<String, dynamic> updateField = {
        CustomerFieldName.billing: {AddressFieldName.phone: updatePhone.text.trim()},
      };
      final userId = userController.customer.value.id.toString();
      final CustomerModel customer = await wooCustomersRepository.updateCustomerById(userID: userId, data: updateField);
      userController.customer(customer);
      // UserController.instance.fetchUserRecord();
      TLoaders.customToast(message: 'Phone updated successfully!');
      isPhoneUpdating.value = false;
      isPhoneVerified.value = true;
    } catch (error) {
      isPhoneUpdating.value = false;
      TLoaders.errorSnackBar(title: 'Error', message: error.toString());
    }
  }

  //Woocommerce update user meta value
  Future<CustomerModel> wooUpdateUserMeta({required String userId, required String key, required dynamic value}) async {
    try {
      //update single field user
      Map<String, dynamic> updateField = {
        CustomerMetaDataName.metaData: [
          {
            "key": key,
            "value": value
          }
        ]
      };
      final CustomerModel customer = await wooCustomersRepository.updateCustomerById(userID: userId, data: updateField);
      return customer;
    } catch (error) {
      rethrow;
    }
  }

  //Change profile details
  Future<void> changeProfileDetails() async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are updating your information..', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!changeProfileFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //update single field user
      Map<String, dynamic> updateField = {
        UserFieldName.name: fullName.text.trim(),
        UserFieldName.email: email.text.trim(),
        UserFieldName.phone: phone.text.trim(),
        UserFieldName.dateModified: Timestamp.now().toDate(),
      };
      await userRepository.updateSingleField(updateField);

      //update the Rx user value
      userController.customer.value.firstName = fullName.text.trim();
      userController.customer.value.email = email.text.trim();
      userController.customer.value.email = phone.text.trim();

      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.successSnackBar(title: 'Congratulation', message: 'Your details updated successfully!');
      Get.back();
    } catch (error) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      //show some Generic error to the user
      TLoaders.errorSnackBar(title: 'Error - Change Profile', message: error.toString());
    }
  }

  //update mobile number
  Future<dynamic> updateMobilePopup(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (_) => Container(
          padding: const EdgeInsets.all(Sizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TSectionHeading(title: 'Select Address',
                onPressed: () {},
                seeActionButton: true,
                buttonTitle: 'Add new address',
              ),
              const Expanded(
                child: Text('hi'),
              ),
              const SizedBox(height: Sizes.defaultSpace * 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Select Address'),
                ),
              )
            ],
          ),
        )
    );
  }

}

