import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppSettings {

  static const String appName             =  'aramarket.in';
  static const String subTitle            =  'Wholesale Market Place';

  static const String appCurrency         =  'INR';
  static const String appCurrencySymbol   =  '₹';
  static const int freeShippingOver       =  999;
  static const double shippingCharge      =  100;

  // Images
  static const String lightAppLogo = 'assets/logos/fincom_logo.png';
  static const String darkAppLogo  = 'assets/logos/aramarket_new.png';

  // App Basic Colors
  static const Color primaryColor = Color(0xFF2b317f);
  // static const Color secondaryColor = Color(0xFF092143);
  static const Color secondaryColor = Color(0xFF2d2d2d); //Zomato
  static const Color accent = Color(0xFFB0C7FF);
  static const Color primaryBackground = Color(0xFFFFFFFF); //Zomato
  static const Color secondaryBackground = Color(0xFFf4f4f2); //Zomato

  // Support
  static const String supportWhatsApp   =  '+919368994493';
  static const String supportMobile     =  '+919368994493';
  static const String supportEmail      =  'support@aramarket.in';

  // Policy Urls
  static const String privacyPrivacy        = 'https://aramarket.in/privacy-policy/';
  static const String shippingPolicy        = 'https://aramarket.in/shipping-policy/';
  static const String termsAndConditions    = 'https://aramarket.in/terms-and-conditions/';
  static const String refundPolicy          = 'https://aramarket.in/refund_returns/';

  // Follow us link
  static const String facebook              = 'https://www.facebook.com/araMarket.in';
  static const String instagram             = 'https://www.instagram.com/aramarket.in/';
  static const String telegram              = 'https://www.instagram.com/aramarket.in/';
  static const String twitter               = 'https://twitter.com/aramarket_India';
  static const String youtube               = 'https://www.youtube.com/@aramarket';
  static const String playStore             = 'https://play.google.com/store/apps/details?id=com.company.aramarketin&hl=en_IN&gl=US';

  static Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version; // This retrieves the version from pubspec.yaml
  }
}
