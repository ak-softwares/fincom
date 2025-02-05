import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../styles/shadows.dart';

class QuantityAddButtons extends StatelessWidget {

  const QuantityAddButtons({
    super.key, this.size = 45, required this.quantity, this.add, this.remove,
  });
  final double? size;
  final int quantity;
  final VoidCallback? add, remove;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(Sizes.xs),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color with opacity
            spreadRadius: 2, // Spread radius
            blurRadius: 6, // Blur radius
            offset: Offset(0, 3), // Offset: x (horizontal), y (vertical)
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        // border: Border.all(color: TColors.borderSecondary.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: size,
            height: size,
            child: IconButton(
              onPressed: remove,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(0)),
              icon: const Icon(Iconsax.minus),
            ),
          ),
          SizedBox(
            width: size! - 5,
            height: size! - 5,
            child: Center(child: Text(quantity.toString(), style: Theme.of(context).textTheme.titleSmall)),
          ),
          SizedBox(
            width: size,
            height: size,
            child: IconButton(
              onPressed: add,
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(0)),
              icon: const Icon(Iconsax.add),
            ),
          ),
        ],
      ),
    );
  }
}