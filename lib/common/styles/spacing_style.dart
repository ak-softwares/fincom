import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';

class TSpacingStyle {
  static const EdgeInsetsGeometry paddingWidthAppbarHeight = EdgeInsets.only(
    top: Sizes.appBarHeight,
    left: Sizes.defaultSpace,
    bottom: Sizes.defaultSpace,
    right: Sizes.defaultSpace,
  );
  static const EdgeInsetsGeometry defaultPagePadding = EdgeInsets.all(Sizes.defaultSpace);
  static const EdgeInsetsGeometry defaultPageVertical = EdgeInsets.symmetric(vertical: Sizes.defaultSpace);
  static const EdgeInsetsGeometry defaultPageHorizontal = EdgeInsets.symmetric(horizontal: Sizes.defaultSpace);
  static const EdgeInsetsGeometry defaultSpaceLg = EdgeInsets.all(Sizes.defaultSpaceLg);
}