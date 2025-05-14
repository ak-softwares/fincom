import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';

class AppSpacingStyle {
  static const EdgeInsetsGeometry paddingWidthAppbarHeight = EdgeInsets.only(
    top: AppSizes.appBarHeight,
    left: AppSizes.defaultSpace,
    bottom: AppSizes.defaultSpace,
    right: AppSizes.defaultSpace,
  );
  static const EdgeInsetsGeometry defaultPagePadding = EdgeInsets.all(AppSizes.defaultSpace);
  static const EdgeInsetsGeometry defaultPageVertical = EdgeInsets.symmetric(vertical: AppSizes.defaultSpace);
  static const EdgeInsetsGeometry defaultPageHorizontal = EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace);
  static const EdgeInsetsGeometry defaultSpaceLg = EdgeInsets.all(AppSizes.defaultSpaceLg);
}