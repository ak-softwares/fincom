import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class QuantityAddButtons1 extends StatelessWidget {

  const QuantityAddButtons1({
    super.key, this.size = 45, required this.quantity, this.add, this.remove,
  });
  final double? size;
  final int quantity;
  final VoidCallback? add, remove;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        SizedBox(
          width: size,
          height: size,
          child: OutlinedButton(
            onPressed: remove,
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(0)),
            child: const Icon(Iconsax.minus),
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
          child: OutlinedButton(
            onPressed: add,
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(0)),
            child: const Icon(Iconsax.add),
          ),
        ),
      ],
    );
  }
}