import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
class TSaleLabel extends StatelessWidget {
  const TSaleLabel({
    super.key, this.discount, this.size = 11,
  });
  final String? discount;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return discount != null
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: Sizes.sm, vertical: Sizes.sm / 2),
            decoration: BoxDecoration(
                color: TColors.primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(0)
            ),
            child: Text("$discount%",  style: TextStyle(fontSize: size, color: Colors.black, fontWeight: FontWeight.w500)),
          )
        : const SizedBox.shrink();
  }
}