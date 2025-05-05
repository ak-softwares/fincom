import 'package:flutter/material.dart';

import '../../../features/settings/app_settings.dart';

class AppListTileTheme {
  AppListTileTheme._(); // Private constructor to prevent instantiation

  static final lightListTileTheme = ListTileThemeData(
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppSettings.lightText,
    ),
    subtitleTextStyle: TextStyle(
      fontSize: 12,
      color: AppSettings.lightTextSofter,
    ),
  );


  static final darkListTileTheme = ListTileThemeData(
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    subtitleTextStyle: TextStyle(
      fontSize: 12,
    ),
  );
}
