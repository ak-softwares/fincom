import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';


class MadeInIndia extends StatelessWidget {
  const MadeInIndia({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Made with', style: Theme.of(context).textTheme.labelMedium,),
          const SizedBox(width: AppSizes.xs),
          const Icon(Iconsax.heart5, color: Colors.redAccent, size: 20),
          const SizedBox(width: AppSizes.xs),
          Text('in India', style: Theme.of(context).textTheme.labelMedium,)
        ]
    );
  }
}