import 'package:flutter/material.dart';

import '../../features/settings/app_settings.dart';

class AppColors{
  AppColors._();

  // App Basic Colors
  static const Color primaryColor = AppSettings.primaryColor;
  // static const Color secondaryColor = Color(0xFF092143);
  static const Color secondaryColor = Color(0xFF2d2d2d); //Zomato
  static const Color accent = Color(0xFFB0C7FF);
  static const Color primaryBackground = Color(0xFFFFFFFF); //Zomato
  static const Color secondaryBackground = Color(0xFFf4f4f2); //Zomato

  // Buttons Colors
  static const Color buttonText = AppSettings.buttonText;
  static const Color buttonBorder = AppSettings.buttonBorder;
  static const Color buttonBackground = AppSettings.buttonBackground; //Zomato

  static const Color buttonPrimary = AppSettings.primaryColor;
  static const Color buttonSecondary = AppSettings.secondaryColor;
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  static const Color newColor = Color(0xFF2E6D7F);
  static const Color whatsAppColor = Color(0xFF25D366);

  // Link color
  static const Color offerColor = Color(0xFF2BAA3A);
  static const Color linkColor = Colors.blue;
  static const Color linkColor2 = Color(0xFF1A0DAB);
  static const Color refreshIndicator = AppSettings.primaryColor;

  // Text Colors
  static const Color textPrimary = Color(0xFF2d2d2d);
  static const Color textGray = Color(0xFFc1c8d9);
  static const Color textWhite = Colors.white;

  // Background Colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);

  // Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static const Color darkContainer = Colors.white;

  // Border Colors
  static const Color borderLight = Color(0xFFD9D9D9);
  static const Color borderDark = Color(0xFFE6E6E6);

  // Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color softGrey = Color(0xFFE0E0E0);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFcb202d);

  static const Color ratingStar = Colors.orange;
  static const Color ratingBar  = Colors.blue;

  //Gradient Colors
  static const Gradient linerGradient = LinearGradient(
    begin: Alignment(0, 0),
    end: Alignment(0.707, -0.707),
    colors: [
     Color(0xFFFF9A9E),
     Color(0xFFFAD0C4),
     Color(0xFFFAD0C4)
  ]);

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