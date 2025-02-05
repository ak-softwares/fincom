import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class InStock extends StatelessWidget {
  const InStock({super.key, required this.isProductAvailable});

  final bool isProductAvailable;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isProductAvailable
          ? Text('In Stock', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: TColors.offerColor, fontWeight: FontWeight.w500))
          : Text('Out of Stock', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
