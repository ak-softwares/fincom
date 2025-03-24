import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/layout_models/product_grid_layout.dart';
import '../../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../../utils/constants/sizes.dart';


class VendorTileSimmer extends StatelessWidget {
  const VendorTileSimmer({
    super.key,
    this.itemCount = 1,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    const double vendorTileHeight = Sizes.vendorTileHeight;
    const double vendorTileWidth = Sizes.vendorTileWidth;
    const double vendorTileRadius = Sizes.vendorTileRadius;
    const double vendorImageHeight = Sizes.vendorImageHeight;
    const double vendorImageWidth = Sizes.vendorImageWidth;

    return GridLayout(
        itemCount: itemCount,
        crossAxisCount: 1,
        mainAxisExtent: vendorTileHeight,
        itemBuilder: (context, index) {
          return Container(
              width: vendorTileWidth,
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(vendorTileRadius),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Vendor ID'),
                      ShimmerEffect(width: 150, height: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Vendor'),
                      ShimmerEffect(width: 150, height: 10),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('GST'),
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
                  // Divider(color: Theme.of(context).colorScheme.outline),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     InkWell(
                  //       onTap: () {},
                  //       child: Row(
                  //         spacing: Sizes.spaceBtwItems,
                  //         children: [
                  //           Text('Purchase'),
                  //           Icon(Iconsax.money),
                  //         ],
                  //       ),
                  //     ),
                  //     Container(width: 1, height: 25, color: Theme.of(context).colorScheme.outline),
                  //     InkWell(
                  //       onTap: () {},
                  //       child: Row(
                  //         spacing: Sizes.spaceBtwItems,
                  //         children: [
                  //           Text('Transaction'),
                  //           Icon(Iconsax.transaction_minus),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              )
          );
        }
    );
  }
}
