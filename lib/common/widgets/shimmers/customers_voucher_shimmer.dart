import 'package:flutter/material.dart';

import '../../../utils/constants/enums.dart';
import '../../../utils/constants/sizes.dart';
import '../../layout_models/product_grid_layout.dart';
import '../../styles/shadows.dart';
import 'shimmer_effect.dart';

class CustomersVoucherShimmer extends StatelessWidget {
  const CustomersVoucherShimmer(
      {super.key, this.itemCount = 1});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    const double customerVoucherTileHeight = AppSizes.customerVoucherTileHeight;
    const double customerVoucherTileWidth = AppSizes.customerVoucherTileWidth;
    const double customerVoucherTileRadius = AppSizes.customerVoucherTileRadius;
    const double customerVoucherImageHeight =
        AppSizes.customerVoucherImageHeight;
    const double customerVoucherImageWidth = AppSizes.customerVoucherImageWidth;

    return GridLayout(
        itemCount: itemCount,
        crossAxisCount: 1,
        mainAxisExtent: customerVoucherTileHeight,
        itemBuilder: (context, index) {
          return Container(
            // height: 20,
            // width: customerVoucherTileWidth,
            padding: const EdgeInsets.all(AppSizes.xs),
            decoration: BoxDecoration(
              boxShadow: [TShadowStyle.verticalProductShadow],
              borderRadius: BorderRadius.circular(customerVoucherTileRadius),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 38),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const ShimmerEffect(
                        height: customerVoucherImageHeight,
                        width: customerVoucherImageWidth,
                        radius: customerVoucherImageHeight,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          spacing: AppSizes.spaceBtwItems,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const ShimmerEffect(width: 150, height: 14),
                            const ShimmerEffect(
                                width: 75, height: 12), // Paying status
                          ],
                        ),
                      ),
                    ],
                  ),
                  const ShimmerEffect(
                    height: 20,
                    width: 20,
                    radius: 50,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
