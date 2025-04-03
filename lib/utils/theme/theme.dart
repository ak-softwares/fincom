import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../features/settings/app_settings.dart';
import '../constants/colors.dart';
import 'custom_theme/appbar_theme.dart';
import 'custom_theme/bottom_sheet_theme.dart';
import 'custom_theme/checkbox_theme.dart';
import 'custom_theme/chip_theme.dart';
import 'custom_theme/elevated_button_theme.dart';
import 'custom_theme/list_tile_theme.dart';
import 'custom_theme/outlined_button_theme.dart';
import 'custom_theme/switch_theme.dart';
import 'custom_theme/text_field_theme.dart';
import 'custom_theme/text_theme.dart';

class TAppTheme {
  TAppTheme._();
  // Theme.of(context).colorScheme.surface
  static ThemeData lightTheme = FlexThemeData.light(
    scheme: FlexScheme.blueM3,
  ).copyWith(
    listTileTheme: TListTileTheme.lightListTileTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    checkboxTheme: TCheckBoxTheme.lightCheckBoxTheme,
    switchTheme: TSwitchTheme.lightSwitchTheme,
    colorScheme: ThemeData.light().colorScheme.copyWith(
      surface: AppSettings.lightTileBackground, // Background for cards, dialogs, etc.
      // onSurface: AppSettings.lightTextSofter,
      // onSurfaceVariant: AppSettings.lightTextSofter, // Softer text color for better contrast
    ),
    // scaffoldBackgroundColor: AppSettings.lightBackground, // Ensures the scaffold uses the new background
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.blueM3,
  ).copyWith(
    listTileTheme: TListTileTheme.darkListTileTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    checkboxTheme: TCheckBoxTheme.darkCheckBoxTheme,
    switchTheme: TSwitchTheme.darkSwitchTheme,
    colorScheme: ThemeData.dark().colorScheme.copyWith(
      surface: AppSettings.darkTileBackground, // Background for cards, dialogs, etc.
      // onSurface: AppSettings.darkTextSofter,
      // onSurfaceVariant: AppSettings.darkTextSofter, // Softer text color for better contrast
    ),
    scaffoldBackgroundColor: AppSettings.darkBackground, // Ensures the scaffold uses the new background
  );

  static ThemeData lightTheme2 = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: TChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckBoxTheme.lightCheckBoxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme1  = ThemeData(
      useMaterial3: true,
      fontFamily: 'Poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.yellow,
      textTheme: TTextTheme.darkTextTheme,
      chipTheme: TChipTheme.darkChipTheme,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: TAppBarTheme.darkAppBarTheme,
      checkboxTheme: TCheckBoxTheme.darkCheckBoxTheme,
      bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
      elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
      outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme
  );
}