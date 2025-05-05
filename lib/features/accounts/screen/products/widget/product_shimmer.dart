import 'package:flutter/material.dart';

import '../../../../../common/layout_models/product_grid_layout.dart';
import '../../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../../utils/constants/sizes.dart';

class ProductTileShimmer extends StatelessWidget {
  const ProductTileShimmer({
    super.key,
    this.itemCount = 1,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    const double productVoucherTileHeight = AppSizes.productVoucherTileHeight;
    const double productVoucherTileWidth = AppSizes.productVoucherTileWidth;
    const double productVoucherTileRadius = AppSizes.productVoucherTileRadius;
    const double productVoucherImageHeight = AppSizes.productVoucherImageHeight;
    const double productVoucherImageWidth = AppSizes.productVoucherImageWidth;

    return GridLayout(
        itemCount: itemCount,
        crossAxisCount: 1,
        mainAxisExtent: productVoucherTileHeight,
        itemBuilder: (context, index) {
          return Container(
            width: productVoucherTileWidth,
            padding: const EdgeInsets.all(AppSizes.xs),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(productVoucherTileRadius),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Row(
              children: [
                // Main Image
                const ShimmerEffect(height: productVoucherImageHeight, width: productVoucherImageWidth, radius: productVoucherTileRadius,),
                // Title, Rating and price
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppSizes.sm),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerEffect(width: 250, height: 12),
                        const SizedBox(height: AppSizes.xs),
                        const ShimmerEffect(width: 150, height: 12),
                        const SizedBox(height: AppSizes.defaultSpace),
                        // Price and Stock
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const ShimmerEffect(width: 70, height: 12),
                            const ShimmerEffect(width: 70, height: 13),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}
