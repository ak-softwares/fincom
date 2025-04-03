import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/sizes.dart';

class TBrandwithVerifiedIcon extends StatelessWidget {
  const TBrandwithVerifiedIcon({
    super.key, required this.brandName,
  });
  final String brandName;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          brandName,
          style: Theme.of(context).textTheme.labelMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.left,
        ),
        const SizedBox(width: AppSizes.xs),
        const Icon(Iconsax.verify5, color: Colors.blue, size: AppSizes.iconXs),
      ],
    );
  }
}