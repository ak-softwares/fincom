import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.elevatedButtonTextColor,
        backgroundColor: AppColors.buttonBackgroundColor,
        disabledForegroundColor: Colors.grey,
        disabledBackgroundColor: Colors.grey,
        padding: EdgeInsets.symmetric(vertical: AppSizes.buttonPadding),
        textStyle: TextStyle(fontSize: AppSizes.buttonTextSize, fontWeight: AppSizes.buttonTextWeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius)),
      )
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.elevatedButtonTextColor,
        backgroundColor: AppColors.buttonBackgroundColor,
        disabledForegroundColor: Colors.grey,
        disabledBackgroundColor: Colors.grey,
        padding: EdgeInsets.symmetric(vertical: AppSizes.buttonPadding),
        textStyle: TextStyle(fontSize: AppSizes.buttonTextSize, fontWeight: AppSizes.buttonTextWeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius)),
      )
  );
}