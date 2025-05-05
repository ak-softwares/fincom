import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class AppTabBarTheme {
  AppTabBarTheme._(); // Private constructor to prevent instantiation

  static var lightTabBarTheme = TabBarTheme(
    indicatorSize: TabBarIndicatorSize.label,
    labelColor: AppColors.labelColorLight, // Active tab text color
    unselectedLabelColor: AppColors.unselectedLabelColorLight, // Inactive tab text color
    labelStyle: const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    ),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(width: 2.0, color: AppColors.underlineTabIndicatorLight), // Active tab underline
    ),
  );

  static var darkTabBarTheme = TabBarTheme(
    indicatorSize: TabBarIndicatorSize.label,
    labelColor: AppColors.labelColorDark,
    unselectedLabelColor: AppColors.unselectedLabelColorDark,
    labelStyle: const TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
    ),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(width: 2.0, color: AppColors.underlineTabIndicatorDark),
    ),
  );
}
