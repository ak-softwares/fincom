import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class AppSwitchTheme {
  AppSwitchTheme._(); // Private constructor to prevent instantiation

  static final lightSwitchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.blue; // Active color (blue)
      }
      return AppColors.buttonTextColor; // Inactive color
    }),
    trackColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.blue.withOpacity(0.5); // Lighter blue track when active
      }
      return Colors.grey.shade300; // Inactive track color
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) {
      return Colors.transparent;
    }),
  );

  static final darkSwitchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.blue; // Active color (blue)
      }
      return Colors.white; // Inactive color
    }),
    trackColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.blue.withOpacity(0.5); // Lighter blue track when active
      }
      return Colors.grey; // Inactive track color
    }),
  );
}
