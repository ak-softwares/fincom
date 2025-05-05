import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'bindings/general_bindings.dart';
import 'common/navigation_bar/bottom_navigation_bar.dart';
import 'data/database/mongodb/mongodb.dart';
import 'features/authentication/screens/phone_otp_login/mobile_login_screen.dart';
import 'features/authentication/controllers/authentication_controller/authentication_controller.dart';
import 'features/settings/app_settings.dart';
import 'utils/theme/ThemeController.dart';
import 'utils/theme/theme.dart';


void main() async {

  // Load env variable
  await dotenv.load(fileName: ".env");

  // Add widgets Binding
  WidgetsFlutterBinding.ensureInitialized();

  // GetX Local Storage
  await GetStorage.init();

  await MongoDatabase.connect();

  if (Firebase.apps.isEmpty) {  // ✅ Prevent duplicate initialization
    await Firebase.initializeApp();
  }
  // Initialize Firebase
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
  //     .then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  // Initialize App settings
  await AppSettings.init(); // Load version info before app starts

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final bool isAdminLogin = AuthenticationController.instance.isAdminLogin.value;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppSettings.appName,
      theme: AppAppTheme.lightTheme,
      themeMode: themeController.themeMode.value, // GetX-controlled theme
      darkTheme: AppAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      home: isAdminLogin ? const BottomNavigation() : const MobileLoginScreen(),
    );
  }
}


