import '../../../features/shop/screens/products/scrolling_products.dart';
import '../../layout_models/product_grid_layout.dart';
import '/common/widgets/shimmers/shimmer_effect.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class BrandTileShimmer extends StatelessWidget {

  const BrandTileShimmer({
    super.key,
    this.itemCount = 2,
    this.crossAxisCount = 1,
    this.orientation = OrientationType.vertical
  });

  final int itemCount, crossAxisCount;
  final OrientationType orientation;

  @override
  Widget build(BuildContext context) {
    final double brandImageHeight = AppSizes.brandImageHeight;
    final double brandImageWidth = AppSizes.brandImageWidth;
    final double brandTileRadius = AppSizes.brandTileRadius;
    final double brandTileHeight = AppSizes.brandTileHeight;
    final double brandTileWidth  = AppSizes.brandTileWidth;

    return orientation == OrientationType.vertical
        ? GridLayout(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: brandTileHeight,
            itemCount: itemCount,
            itemBuilder: (_, __) {
              return  Column(
                spacing: AppSizes.spaceBtwItems,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Image
                  ShimmerEffect(height: brandImageHeight, width: brandImageWidth, radius: brandTileRadius),
                  //Text
                  ShimmerEffect(width: brandTileWidth, height: 10),
                ],
              );
            },
          )
        : SizedBox(
            height: brandTileHeight,
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
                        ShimmerEffect(height: brandImageHeight, width: brandImageWidth, radius: brandTileRadius),
                        // Text
                        ShimmerEffect(width: brandImageWidth, height: 10),
                      ],
                    ),
                  );
                }
            ),
          );

        // : ListLayout(
        //     height: brandImageHeight * 1.8,
        //     itemCount: itemCount,
        //     itemBuilder: (_, __) {
        //       return  Padding(
        //         padding: const EdgeInsets.only(left: Sizes.defaultBtwTiles, top: Sizes.defaultBtwTiles),
        //         child: Column(
        //           spacing: Sizes.spaceBtwItems,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             // Image
        //             ShimmerEffect(height: brandImageHeight, width: brandImageWidth, radius: brandTileRadius),
        //             // Text
        //             ShimmerEffect(width: brandImageWidth, height: 10),
        //           ],
        //         ),
        //       );
        //     }
        // );
  }
}
