
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../common/layout_models/product_grid_layout.dart';
import '../../../../../common/layout_models/product_list_layout.dart';
import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class PurchaseListShimmer extends StatelessWidget {
  const PurchaseListShimmer({super.key,});

  @override
  Widget build(BuildContext context) {
    final double purchaseTileHeight = AppSizes.purchaseTileHeight;
    final double purchaseTileWidth = AppSizes.purchaseTileWidth;
    final double purchaseTileRadius = AppSizes.purchaseTileRadius;
    final double purchaseImageHeight = AppSizes.purchaseImageHeight;
    final double purchaseImageWidth = AppSizes.purchaseImageWidth;

    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.sm),
      child: Column(
        spacing: AppSizes.sm,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.defaultSpace),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface, // Use surface for a neutral background
              borderRadius: BorderRadius.circular(AppSizes.purchaseItemTileRadius),
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.outline, // `outline` works well for borders in flex_color_scheme
              ),                                    ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerEffect(width: 100, height: 17),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSizes.defaultSpace),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface, // Use surface for a neutral background
              borderRadius: BorderRadius.circular(AppSizes.purchaseItemTileRadius),
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.outline, // `outline` works well for borders in flex_color_scheme
              ),                                    ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerEffect(width: 100, height: 17),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
