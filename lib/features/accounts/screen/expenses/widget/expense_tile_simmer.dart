import 'package:flutter/material.dart';

import '../../../../../common/layout_models/product_grid_layout.dart';
import '../../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class ExpenseTileShimmer extends StatelessWidget {
  const ExpenseTileShimmer({
    super.key,
    this.itemCount = 1,
    this.showBorder = true,
  });

  final int itemCount;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    const double expenseTileHeight = AppSizes.expenseTileHeight;
    const double expenseTileWidth = AppSizes.expenseTileWidth;
    const double expenseTileRadius = AppSizes.expenseTileRadius;
    const double expenseImageHeight = AppSizes.expenseImageHeight;
    const double expenseImageWidth = AppSizes.expenseImageWidth;

    return GridLayout(
      itemCount: itemCount,
      crossAxisCount: 1,
      mainAxisExtent: expenseTileHeight,
      itemBuilder: (_, __) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(expenseTileRadius),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Amount row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: ShimmerEffect(width: 120, height: 16, radius: AppSizes.sm),
                ),
                ShimmerEffect(
                  width: 80,
                  height: 16,
                  radius: AppSizes.sm,
                  color: dark ? Colors.grey[800] : Colors.grey[300],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceBtwItems / 2),

            // Category & Date row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SizedBox(width: AppSizes.sm / 2),
                    const ShimmerEffect(width: 80, height: 12, radius: AppSizes.sm),
                  ],
                ),
                const ShimmerEffect(width: 60, height: 12, radius: AppSizes.sm),
              ],
            ),
            const SizedBox(height: AppSizes.spaceBtwItems / 2),

            // Payment method row
            Row(
              children: [
                const SizedBox(width: AppSizes.sm / 2),
                const ShimmerEffect(width: 100, height: 12, radius: AppSizes.sm),
              ],
            ),
          ],
        ),
      ),
    );
  }
}