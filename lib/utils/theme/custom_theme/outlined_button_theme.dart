import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class AppOutlinedButtonTheme {
  AppOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.buttonTextColor,
        side: const BorderSide(color: AppColors.buttonBorder, width: AppSizes.buttonBorderWidth),
        alignment: Alignment.center,
        textStyle: const TextStyle(fontSize: AppSizes.buttonTextSize, fontWeight: AppSizes.buttonTextWeight),
        padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius),),
      )
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.white,
        side: BorderSide(color: AppColors.buttonBorder, width: AppSizes.buttonBorderWidth),
        textStyle: TextStyle(fontSize: AppSizes.buttonTextSize, fontWeight: AppSizes.buttonTextWeight),
        padding: EdgeInsets.symmetric(vertical: AppSizes.buttonPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius)),
      )
  );
}