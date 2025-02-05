
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/woocommerce_repositories/customers/woo_customer_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../screens/create_account/signup.dart';
import '../create_account_controller/signup_controller.dart';
import '../login_controller/login_controller.dart';

class SocialLoginController extends GetxController{
  static SocialLoginController get instance => Get.find();

  final authenticationRepository = Get.put(AuthenticationRepository());
  final wooCustomersRepository = Get.put(WooCustomersRepository());
  final userController = Get.put(UserController());
  final loginController = Get.put(LoginController());

  //Google SignIn Authentication
  Future<void> signInWithGoogle() async {
    String googleEmail = ''; // Initialize with an empty string
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('Logging you in...', Images.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // Google Authentication
      final userCredentials = await authenticationRepository.signInWithGoogle();
      googleEmail = userCredentials.user?.email ?? ''; // Assign the value here
      final customer = await wooCustomersRepository.fetchCustomerByEmail(googleEmail);

      TFullScreenLoader.stopLoading();
      authenticationRepository.login(customer: customer, loginMethod: 'Google');
    } catch (error) {
      // Remove Loader
      TFullScreenLoader.stopLoading();
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      if (error.toString().contains('Customer not found')) {
        Get.put(SignupController()).email.text = googleEmail; // Now 'googleEmail' is accessible here
        Get.to(() => SignUpScreen());
      } else {
        TLoaders.errorSnackBar(title: 'Error', message: error.toString());
      }
    }
  }
}

