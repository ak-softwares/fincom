
import 'package:get/get.dart';

import '../../common/navigation_bar/bottom_navigation_bar.dart';
import '../../features/authentication/screens/phone_otp_login/mobile_login_screen.dart';

class NavigationHelper {
  static void navigateToBottomNavigation() {
    Get.offAll(() => const BottomNavigation());
  }

  static void navigateToLoginScreen() {
    Get.offAll(() => const MobileLoginScreen());
    // Get.offAll(() => const LoginScreen());
  }
  static void navigateToMobileLogin() {
    Get.offAll(() => const MobileLoginScreen());
    // Get.offAll(() => const LoginScreen());
  }
}
