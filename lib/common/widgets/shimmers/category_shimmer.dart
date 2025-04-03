import '../../../features/shop/screens/products/scrolling_products.dart';
import '../../layout_models/product_grid_layout.dart';
import '/common/widgets/shimmers/shimmer_effect.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class CategoryTileShimmer extends StatelessWidget {

  const CategoryTileShimmer({
    super.key,
    this.itemCount = 2,
    this.crossAxisCount = 1,
    this.orientation = OrientationType.vertical
  });

  final int itemCount, crossAxisCount;
  final OrientationType orientation;

  @override
  Widget build(BuildContext context) {
    final double categoryImageHeight = AppSizes.categoryImageHeight;
    final double categoryImageWidth  = AppSizes.categoryImageWidth;
    final double categoryTileRadius  = AppSizes.categoryTileRadius;
    final double categoryTileHeight  = AppSizes.categoryTileHeight;
    final double categoryTileWidth  = AppSizes.categoryTileWidth;

    return orientation == OrientationType.vertical
        ? GridLayout(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: categoryTileHeight,
            itemCount: itemCount,
            itemBuilder: (_, __) {
              return  Column(
                spacing: AppSizes.spaceBtwItems,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image
                  ShimmerEffect(height: categoryImageHeight, width: categoryImageWidth, radius: categoryTileRadius),
                  // Text
                  ShimmerEffect(height: 10, width: categoryTileWidth),
                ],
              );
            },
          )
        : SizedBox(
            height: categoryTileHeight,
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: itemCount,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const SizedBox(width: 0),
                itemBuilder: (_, __) {
                  return  Padding(
                    padding: const EdgeInsets.only(left: AppSizes.defaultBtwTiles, top: AppSizes.defaultBtwTiles),
                    child: Column(
                      spacing: AppSizes.spaceBtwItems,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        ShimmerEffect(height: categoryImageHeight, width: categoryImageWidth, radius: categoryTileRadius),
                        // Text
                        ShimmerEffect(height: 10, width: categoryTileWidth),
                      ],
                    ),
                  );
                }
            ),
          );
  }
}
