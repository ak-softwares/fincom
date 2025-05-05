import 'package:flutter/material.dart';

import '../../features/settings/app_settings.dart';

class AppColors{
  AppColors._();

  // App Basic Colors
  static const Color primaryColor = AppSettings.primaryColor;
  static const Color secondaryColor = Color(0xFF2d2d2d);

  // Link color
  static const Color offerColor = Color(0xFF2BAA3A);
  static const Color linkColor = Colors.blue;
  static const Color refreshIndicator = Colors.blue;

  // Text Light
  static const Color textLight = Color(0xFF3D445C); // (0xFF3D445C blues) (0xFF212121 black)
  static const Color headlineLight = Color(0xFF2d2d2d);

  // Text Dark
  static const Color textDark = Color(0xFFE0E0E0);
  static const Color headlineDark = Color(0xFF2d2d2d);

  // Icon Light
  static const Color iconLight = textLight;

  // Icon Dark
  static const Color iconDark = Color(0xFFE0E0E0);

  // Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static const Color darkContainer = Colors.white;

  // AppBar Light
  static const Color appBarTextLight = textLight;

  // AppBar Dark
  static const Color appBarTextDark = textDark;

  // TapBar Colors Light
  static const Color labelColorLight = textLight;
  static const Color unselectedLabelColorLight = textLight;
  static const Color underlineTabIndicatorLight = Colors.blue;

  // TapBar Colors Dark
  static const Color labelColorDark = textDark;
  static const Color unselectedLabelColorDark = textDark;
  static const Color underlineTabIndicatorDark = Colors.blue;

  // Button Colors
  static const Color buttonTextColor = AppSettings.secondaryColor;
  static const Color elevatedButtonTextColor = Color(0xFFFFFFFF);
  static const Color buttonDisabled = Color(0xFFC4C4C4);
  static const Color buttonBorder = Colors.grey;
  static const Color buttonBackgroundColor = AppSettings.primaryColor;

  // Surface light there
  static const Color surfaceLight = Color(0xFFF6F6F6);
  static const Color onSurfaceLight = textLight;
  static const Color onSurfaceVariantLight = Color(0xFF8A929D);

  // Surface dark there
  static const Color surfaceDark = Color(0xFFF6F6F6);
  static const Color onSurfaceDark = Color(0xFFE0E0E0);
  static const Color onSurfaceVariantDark = Color(0xFFB0B6C3);

  // Border Colors
  static const Color borderLight = Color(0xFFD9D9D9);
  static const Color borderDark = Color(0xFFE6E6E6);

  // Product card
  static const Color productCardTitle = Color(0xFFD32F2F);
  static const Color productCardPrice = Color(0xFF212121);   //Color(0xFFD32F2F) Red color
  static const Color productCardAddToCartIcon = Color(0xFFD32F2F);
  static const Color productCardBackground = Color(0xFFD32F2F);
  static const Color ratingStar = Colors.orange;

  // Background Colors
  static const Color backgroundLight = Color(0xFFF4F5F7);
  static const Color backgroundDark = Color(0xFF25282D);


  // Whatsapp color
  static const Color whatsAppColor = Color(0xFF25D366);

  // Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Gradient Colors
  static const Gradient linerGradient = LinearGradient(
    begin: Alignment(0, 0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xFFFF9A9E),
      Color(0xFFFAD0C4),
      Color(0xFFFAD0C4)
    ]
  );

  // Method to get color based on string input
  static Color getColorFromString(String colorName) {
    Map<String, Color> colorMap = {
      'black': Colors.black,
      'white': Colors.white,
      'red': Colors.red,
      'blue': Colors.blue,
      'green': Colors.green,
      'yellow': Colors.yellow,
      'orange': Colors.orange,
      'purple': Colors.purple,
      'pink': Colors.pink,
      'brown': Colors.brown,
      'grey': Colors.grey,
      'indigo': Colors.indigo,
      'cyan': Colors.cyan,
      'amber': Colors.amber,
      'teal': Colors.teal,
      'lime': Colors.lime,
      'deepPurple': Colors.deepPurple,
      'deepOrange': Colors.deepOrange,
      // Add more colors as needed
    };
    // Return the color from map, or a default color if not found
    return colorMap[colorName] ?? Colors.transparent;
  }

}
