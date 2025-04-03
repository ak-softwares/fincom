import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

class TShadowStyle {
  static final verticalProductShadow = BoxShadow(
    color: Colors.grey[700]!.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );

  static const horizontalProductShadow = BoxShadow(
    color: AppColors.borderDark,
    blurRadius: 5, // Adjust as needed
    spreadRadius: 2, // Adjust as needed
    offset: Offset(0, 0), // Adjust as needed
  );

  static final allProductShadow = BoxShadow(
      color: Colors.grey[700]!.withOpacity(0.1),
      blurRadius: 50,
      spreadRadius: 7,
      // offset: const Offset(0, 2)
  );
}