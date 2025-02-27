import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/mongodb/user/user_repositories.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/local_storage_constants.dart';
import '../../../../utils/helpers/encryption_hepler.dart';
import '../../../../utils/helpers/navigation_helper.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../personalization/controllers/customers_controller.dart';
import '../../../personalization/models/user_model.dart';
import '../login_controller/login_controller.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();

  ///variables
  final localStorage = GetStorage();
  final hidePassword = true.obs; //Observable for hiding/showing password
  final privacyPolicyChecked = true.obs; //Observable for privacy policy checked or not
  final fullName = TextEditingController();
  final email     = TextEditingController();
  final password  = TextEditingController();
  final phone     = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>(); //Form key for form validation

  final userController = Get.put(CustomersController());
  final loginController = Get.put(LoginController());
  final mongoAuthenticationRepository = Get.put(MongoAuthenticationRepository());
  final authenticationRepository = AuthenticationRepository.instance;

  void signupWithEmailPassword() async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are creating account..', Images.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      if(!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      //privacy policy check
      if(!privacyPolicyChecked.value) {
        TLoaders.warningSnackBar(title: 'Accept Privacy Policy', message: 'In order to create account, you have to read and accept the privacy Policy & Terms of Use.');
        return;
      }

      UserModel user = UserModel(
        name: fullName.text.trim(),
        email: email.text.trim(),
        password: EncryptionHelper.hashPassword(password: password.text.trim()),
        phone: phone.text.trim(),
      );

      await mongoAuthenticationRepository.singUpWithEmailAndPass(user: user);

      //save to local storage
      if(loginController.rememberMe.value) {
        localStorage.write(LocalStorage.rememberMeEmail, email.text.trim());
        localStorage.write(LocalStorage.rememberMePassword, password.text);
      }

      TFullScreenLoader.stopLoading();
      authenticationRepository.login(user: user);
    } catch (error) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    }
  }

  void signup() async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are creating account..', Images.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove Loader
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if(!signupFormKey.currentState!.validate()) {
        //remove Loader
        TFullScreenLoader.stopLoading();
        return;
      }

      //privacy policy check
      if(!privacyPolicyChecked.value) {
        TLoaders.warningSnackBar(
            title: 'Accept Privacy Policy',
            message: 'In order to create account, you have to read and accept the privacy Policy & Terms of Use.'
        );
        return;
      }

      // Register user in the Firebase Authentication & save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      //save Authenticated user data in the firebase FireStore
      final newUser = UserModel(
        userId: userCredential.user!.uid,
        name: fullName.text.trim(),
        email: email.text.trim(),
        // password: password.text.trim(), // Hash the password
        phone: phone.text.trim(),
        dateCreated: Timestamp.now().toDate(),
        role: UserFieldName.roleCustomer,
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      //remove Loader
      TFullScreenLoader.stopLoading();
      // UserController.instance.fetchUserRecord();
      TLoaders.customToast(message: 'Your account has been created!');
      NavigationHelper.navigateToBottomNavigation();
    } catch (error) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    }
  }
}




