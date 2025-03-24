import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/layout_models/product_grid_layout.dart';
import '../../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../../utils/constants/sizes.dart';


class PaymentTileSimmer extends StatelessWidget {
  const PaymentTileSimmer({
    super.key,
    this.itemCount = 1,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    const double paymentTileHeight = Sizes.paymentTileHeight;
    const double paymentTileWidth = Sizes.paymentTileWidth;
    const double paymentTileRadius = Sizes.paymentTileRadius;
    const double paymentImageHeight = Sizes.paymentImageHeight;
    const double paymentImageWidth = Sizes.paymentImageWidth;

    return GridLayout(
        itemCount: itemCount,
        crossAxisCount: 1,
        mainAxisExtent: paymentTileHeight,
        itemBuilder: (context, index) {
          return Container(
              width: paymentTileWidth,
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(paymentTileRadius),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Method'),
                      ShimmerEffect(width: 150, height: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Opening Balance'),
                      ShimmerEffect(width: 100, height: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Balance'),
                      ShimmerEffect(width: 50, height: 10),
                    ],
                  ),
                ],
              )
          );
        }
    );
  }
}
