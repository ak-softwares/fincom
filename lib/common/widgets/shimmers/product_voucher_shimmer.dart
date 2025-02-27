import 'package:flutter/material.dart';

import '../../../features/shop/screens/products/scrolling_products.dart';
import '../../../utils/constants/sizes.dart';
import '../../layout_models/product_grid_layout.dart';
import '../../styles/shadows.dart';
import 'shimmer_effect.dart';
class ProductVoucherShimmer extends StatelessWidget {
  const ProductVoucherShimmer({
    super.key,
    this.itemCount = 1,
    this.orientation = OrientationType.vertical
  });

  final int itemCount;
  final OrientationType orientation;

  @override
  Widget build(BuildContext context) {
    const double productVoucherTileHeight = Sizes.productVoucherTileHeight;
    const double productVoucherTileWidth = Sizes.productVoucherTileWidth;
    const double productVoucherTileRadius = Sizes.productVoucherTileRadius;
    const double productVoucherImageHeight = Sizes.productVoucherImageHeight;
    const double productVoucherImageWidth = Sizes.productVoucherImageWidth;

    return GridLayout(
        itemCount: itemCount,
        crossAxisCount: orientation == OrientationType.vertical ? 2 : 1,
        mainAxisExtent: orientation == OrientationType.vertical ? Sizes.productCardVerticalHeight : productVoucherTileHeight,
        itemBuilder: (context, index) {
          return Container(
            width: productVoucherTileWidth,
            padding: const EdgeInsets.all(Sizes.xs),
            decoration: BoxDecoration(
              boxShadow: [TShadowStyle.verticalProductShadow],
              borderRadius: BorderRadius.circular(productVoucherTileRadius),
              color: Colors.white,
            ),
            child: Row(
              children: [
                // Main Image
                const ShimmerEffect(height: productVoucherImageHeight, width: productVoucherImageWidth, radius: productVoucherTileRadius,),
                // Title, Rating and price
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: Sizes.sm),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerEffect(width: 250, height: 12),
                        const SizedBox(height: Sizes.xs),
                        const ShimmerEffect(width: 150, height: 12),
                        const SizedBox(height: Sizes.defaultSpace),
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
