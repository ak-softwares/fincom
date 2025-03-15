import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'bindings/general_bindings.dart';
import 'common/navigation_bar/bottom_navigation_bar.dart';
import 'data/database/mongodb/mongodb.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'features/authentication/screens/phone_otp_login/mobile_login_screen.dart';
import 'features/settings/app_settings.dart';
import 'features/shop/screens/cart/cart.dart';
import 'features/shop/screens/orders/order.dart';
import 'firebase_options.dart';
import 'routes/deeplink_get_router.dart';
import 'routes/internal_routes.dart';
import 'routes/routes_name_path.dart';
import 'services/firebase_analytics/firebase_analytics.dart';
import 'services/notification/firebase_notification.dart';
import 'services/notification/local_notification.dart';
import 'utils/theme/theme.dart';

//Theme.of(context).colorScheme.surface

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  FirebaseNotification.handleMassage(message);
  // FirebaseNotification.showNotification(message);
  // print("Handling a background message: ${message.messageId}");
}


void main() async {

  // Load env variable
  await dotenv.load(
    fileName: ".env"
  );
  // Add widgets Binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // GetX Local Storage
  await GetStorage.init();

  await MongoDatabase.connect();
  //await splash until other item load
  // FlutterNativeSplash.remove();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  if (Firebase.apps.isEmpty) {  // ✅ Prevent duplicate initialization
    await Firebase.initializeApp();
  }
  // Initialize Firebase
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
  //     .then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  // Initialize Firebase Analytics
  await FBAnalytics.setDefaultEventParameters();

  // Initialize Firebase Notifications
  await FirebaseNotification.initNotification();

  // To handle messages while your application is terminated
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize with the settings from NotificationSettings
  LocalNotificationServices.localNotificationsPlugin.initialize(
    LocalNotificationServices.initializationSettings, //this line for init local notification setting
    onDidReceiveNotificationResponse: (response) {  // line for when user click on notification when app is open
      InternalAppRoutes.internalRouteHandle(url: response.payload.toString());
      // AppRoutes.pageRouteHandle(routeName: response.payload.toString());
    },
    // onDidReceiveBackgroundNotificationResponse: (response) {  // line for when user click on notification when app is close
    //   InternalAppRoutes.internalRouteHandle(url: response.payload.toString());
    //   // AppRoutes.pageRouteHandle(routeName: response.payload.toString());
    // }
  );

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Function to handle deep link at app start
    // String? handleInitialDeepLink() {
    //   final String? deepLinkString = Get.parameters['uri']; // Get the deep link as a String
    //   final Uri? deepLinkUri = deepLinkString != null ? Uri.tryParse(deepLinkString) : null; // Parse to Uri
    //
    //   if (deepLinkUri != null && deepLinkUri.path.contains('/product/')) {
    //     final slug = deepLinkUri.pathSegments.last;
    //     return RoutesPath.product.replaceFirst(':slug', slug);
    //   }
    //   return null; // No deep link detected
    // }
    //
    // String? initialDeepLinkHandler() {
    //   final String? deepLinkString = Get.parameters['uri']; // Get the deep link as a String
    //   final Uri? uri = deepLinkString != null ? Uri.tryParse(deepLinkString) : null; // Parse to Uri
    //
    //   if (uri?.path == '/product') {
    //     return RoutesPath.product; // Replace with logic for deep link
    //   }
    //   return null;
    // }
    //
    // // Handling cold start and setting the initial route
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Set the initial route if a deep link is detected
    //   final initialRoute = handleInitialDeepLink();
    //   if (initialRoute != null) {
    //     Get.offAllNamed(initialRoute); // Clears navigation stack and sets the route
    //   }
    // });

    // Function to handle deep link
    // void handleDeepLink() {
    //   final String? deepLinkString = Get.parameters['uri'];
    //   final Uri? deepLinkUri = deepLinkString != null ? Uri.tryParse(deepLinkString) : null;
    //
    //   if (deepLinkUri != null) {
    //     Future.delayed(Duration(milliseconds: 500), () {
    //       Get.toNamed(deepLinkUri.path);
    //     });
    //   }
    // }
    //
    // // Always start from home, then navigate to the deep link
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   handleDeepLink();
    // });

    // FBAnalytics.logPageView('main_function_screen');
    AuthenticationRepository.instance.checkIsUserLogin();
    final bool isUserLogin = AuthenticationRepository.instance.isUserLogin.value;
    return GetMaterialApp(  //add .router when use go_router
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      navigatorObservers: [FBAnalytics.observer],
      title: AppSettings.appName,
      // theme: TAppTheme.lightTheme,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      home: isUserLogin ? const BottomNavigation() : const MobileLoginScreen(),
      // initialRoute: '/',
      // getPages: [
      //   GetPage(name: '/', page: () => const BottomNavigation()),
      //   GetPage(name: '/page1', page: () => const CartScreen()),
      //   GetPage(name: '/page2', page: () => const OrderScreen()),
      // ],
      // getPages: AppRoutes.pages,
      initialRoute: RoutesPath.home, // Always start from home

      // getPages: AppRoutes.pages,
      // // initialRoute: RoutesPath.home, // Default route
      // initialRoute: initialDeepLinkHandler() ?? RoutesPath.home,

      getPages: [
        ...AppRoutes.pages,
        AppRoutes.defaultRoute,
      ],
      // routingCallback: (routing) {
      //   // Optional: Log or handle route changes
      //   if (routing?.current != null) {
      //     debugPrint("Navigated to: ${routing?.current}");
      //   }
      // },
      //these are the method for Get routes
      // initialRoute: CustomRoutes.home,
      // getPages: [
      //   ...AppRoutes.pages, // Include your defined routes
      //   AppRoutes.defaultRoute, // Include the default route
      // ],

      //these are the method for Get routes for another way
      // routes: {
      //   '/': (context)=>BottomNavigation2(),
      //   CustomRoutes.product: (context)=>ProductDetailScreen(slug: Get.parameters['slug']),
      //   'details': (context)=>TOrderScreen(),
      // },

      // these are the method for go_router
      // routerDelegate: DeeplinkGoRouter.router.routerDelegate,
      // backButtonDispatcher: DeeplinkGoRouter.router.backButtonDispatcher,
      // routeInformationParser: DeeplinkGoRouter.router.routeInformationParser,
      // routeInformationProvider: DeeplinkGoRouter.router.routeInformationProvider,

    );
  }
}

class DeepLinkObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != '/') {
      Future.delayed(Duration.zero, () {
        Get.offAllNamed('/');
        Future.delayed(Duration(milliseconds: 500), () {
          Get.toNamed(route.settings.name!);
        });
      });
    }
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     // Get.testMode = true;
//     return GetMaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       title: TTexts.appName,
//       // themeMode: ThemeMode.system,
//       theme: TAppTheme.lightTheme,
//       routerConfig: _router,
//       // darkTheme: TAppTheme.darkTheme,
//       initialBinding: GeneralBindings(),
//       // initialRoute: CustomRoutes.home,
//       // getPages: [
//       //   ...AppRoutes.pages, // Include your defined routes
//       //   AppRoutes.defaultRoute, // Include the default route
//       // ],
//       // onGenerateRoute: (RouteSettings settings) {
//       //   onGenerateRoute: (RouteSettings settings) {
//       //     // Define a regular expression pattern to match dynamic product URLs
//       //     final Uri uri = Uri.parse(settings.name);
//       //     final RegExp productRegExp = RegExp(r'^/product/([^/]+)$');
//       //
//       //     // Match the route with the pattern
//       //     if (uri.path == '/') {
//       //       return MaterialPageRoute(builder: (context) => HomePage());
//       //     } else if (productRegExp.hasMatch(uri.path)) {
//       //       // Extract the product ID or slug from the route
//       //       final match = productRegExp.firstMatch(uri.path);
//       //       final productId = match.group(1);
//       //       return MaterialPageRoute(builder: (context) => ProductDetailsPage(productId: productId));
//       //     } else {
//       //       return MaterialPageRoute(builder: (context) => UnknownPage());
//       //     }
//       //   },
//       // },
//       // onGenerateRoute: (settings) {
//       //   print('----------------------1-${settings.name}');
//       //   if (settings.name!.startsWith('/product/')) {
//       //     // Extract the slug from the route
//       //     final String slug = settings.name!.substring('/product/'.length);
//       //     // Navigate to the product detail screen with the parsed slug
//       //     return GetPageRoute(
//       //       page: () => ProductDetailScreen(slug: slug),
//       //     );
//       //   }
//       //   if (settings.name == '/cart') {
//       //     // Parse deep link parameters
//       //     final Uri uri = Uri.parse(settings.name!);
//       //     final String slug = uri.pathSegments.last;
//       //
//       //     // Navigate to the product detail screen with the parsed slug
//       //     return GetPageRoute(
//       //       page: () => const CartScreen(),
//       //     );
//       //   }
//       //
//       //   // If the route is not recognized, try to handle it as a WebView URL
//       //   final Uri uri = Uri.parse(APIConstant.wooBaseUrl + settings.name!);
//       //   print('Navigating to WebView with URL: ${uri.toString()}');
//       //   return null;
//       //   // return GetPageRoute(
//       //   //   page: () => MyWebView(title: '', url: uri.toString()),
//       //   // );
//       //
//       //   // // If none of the conditions match, you can handle it as a fallback
//       //   // print('Route not recognized: ${settings.name}');
//       //   // return GetPageRoute(
//       //   //   page: () => UnknownRouteScreen(), // A screen to handle unknown routes
//       //   // );
//       //   // // Handle other routes or return null if not recognized
//       // },
//       home: const BottomNavigation2(),
//       // home: const FooterNavigation(),
//     );
//   }
// }
