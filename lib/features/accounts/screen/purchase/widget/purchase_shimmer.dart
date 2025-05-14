
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../common/layout_models/product_grid_layout.dart';
import '../../../../../common/layout_models/product_list_layout.dart';
import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class PurchaseShimmer extends StatelessWidget {
  const PurchaseShimmer({super.key, this.itemCount = 1,});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final double purchaseTileHeight = AppSizes.purchaseTileHeight;
    final double purchaseTileWidth = AppSizes.purchaseTileWidth;
    final double purchaseTileRadius = AppSizes.purchaseTileRadius;
    final double purchaseImageHeight = AppSizes.purchaseImageHeight;
    final double purchaseImageWidth = AppSizes.purchaseImageWidth;

    return GridLayout(
        mainAxisExtent: purchaseTileHeight,
        itemCount: itemCount,
        itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              padding: AppSpacingStyle.defaultPagePadding,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(purchaseTileRadius),
              ),
              child: Column(
                spacing: AppSizes.xs,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Number'),
                      ShimmerEffect(width: 50, height: 17),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date'),
                      ShimmerEffect(width: 100, height: 17),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Vendor'),
                      ShimmerEffect(width: 70, height: 17),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total'),
                      ShimmerEffect(width: 60, height: 17),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: AppColors.borderDark,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSizes.spaceBtwItems,
                    children: [
                      ShimmerEffect(width: 40, height: 40, radius: AppSizes.sm),
                      ShimmerEffect(width: 40, height: 40, radius: AppSizes.sm),
                      ShimmerEffect(width: 40, height: 40, radius: AppSizes.sm),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }
    );
  }
}
