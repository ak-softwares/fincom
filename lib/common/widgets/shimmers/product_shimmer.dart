import '../../../features/shop/screens/products/scrolling_products.dart';
import '../../../features/shop/screens/products/products_widgets/product_star_rating.dart';
import '../../styles/shadows.dart';
import '/common/widgets/shimmers/shimmer_effect.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class ProductShimmer extends StatelessWidget {
  const ProductShimmer({
    super.key,
    this.itemCount = 4,
    this.crossAxisCount = 2,
    this.isLoading = false,
    this.orientation = OrientationType.vertical
  });

  final int itemCount;
  final int crossAxisCount;
  final bool isLoading;
  final OrientationType orientation;

  static const double productCardVerticalHeight = AppSizes.productCardVerticalHeight;
  static const double productCardVerticalWidth = AppSizes.productCardVerticalWidth;

  static const double productCardHorizontalHeight = AppSizes.productCardHorizontalHeight;
  static const double productCardHorizontalWidth = AppSizes.productCardHorizontalWidth;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
          height: orientation == OrientationType.vertical
              ? productCardVerticalHeight
              : productCardHorizontalHeight,
          width: orientation == OrientationType.vertical
              ? productCardVerticalWidth
              : productCardHorizontalWidth,
          child: buildGridView(),
        )
        : buildGridView();
  }

  GridView buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSizes.defaultSpaceBWTCard,
        mainAxisSpacing: AppSizes.defaultSpaceBWTCard,
        mainAxisExtent: orientation == OrientationType.vertical
            ? productCardVerticalHeight
            : productCardHorizontalHeight,
      ),
      itemBuilder: (_, __) => orientation == OrientationType.vertical
        ? verticalProductShimmer()
        : horizontalProductShimmer(),
    );
  }

  Container verticalProductShimmer() {
    const double productImageSizeVertical = AppSizes.productImageSizeVertical;
    const double productCardVerticalHeight = AppSizes.productCardVerticalHeight;
    const double productCardVerticalWidth = AppSizes.productCardVerticalWidth;
    const double productImageRadius = AppSizes.productImageRadius;
    return Container(
      width: productCardVerticalWidth,
      padding: const EdgeInsets.all(AppSizes.xs),
      decoration: BoxDecoration(
        boxShadow: [TShadowStyle.verticalProductShadow],
        borderRadius: BorderRadius.circular(productImageRadius),
        color: Colors.white,
        // border: Border.all(color: TColors.borderSecondary.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Main Image
          Column(
            children: [
              // Main Image
              ShimmerEffect(
                width: productImageSizeVertical,
                height: productImageSizeVertical,
                radius: productImageRadius,
              ),

              // Title and Star rating
              const SizedBox(height: AppSizes.xs),
              Padding(
                  padding: const EdgeInsets.only(left: AppSizes.sm, top: AppSizes.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      ShimmerEffect(width: 200, height: 15),
                      const SizedBox(height: AppSizes.spaceBtwItems / 2),
                      ShimmerEffect(width: 100, height: 15),
                      const SizedBox(height: AppSizes.spaceBtwItems / 2),

                      //Star rating
                      ProductStarRating(averageRating: 5, ratingCount: 0, size: 12,),

                    ],
                  )
              ),
            ],
          ),

          // Price and Add to Cart (stick to bottom)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Price
              ShimmerEffect(width: 80, height: 25),
              // Add to cart
              ShimmerEffect(width: 45, height: 33),
            ],
          ),
        ],
      ),
    );
  }

  Container horizontalProductShimmer() {
    const double productImageSizeHorizontal = AppSizes.productImageSizeHorizontal;
    const double productImageRadius = AppSizes.productImageRadius;
    return Container(
      padding: const EdgeInsets.all(AppSizes.xs),
      decoration: BoxDecoration(
        boxShadow: [TShadowStyle.verticalProductShadow],
        borderRadius: BorderRadius.circular(AppSizes.productImageRadius),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Main Image
          ShimmerEffect(
            width: productImageSizeHorizontal,
            height: productImageSizeHorizontal,
            radius: productImageRadius,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSizes.sm, top: AppSizes.xs),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      ShimmerEffect(width: 200, height: 15),
                      const SizedBox(height: AppSizes.spaceBtwItems / 2),
                      ShimmerEffect(width: 100, height: 15),
                      const SizedBox(height: AppSizes.spaceBtwItems / 2),

                      //Star rating
                      ProductStarRating(averageRating: 5, ratingCount: 0, size: 12,),

                    ],
                  ),
                  // Price and Add to Cart (stick to bottom)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Price
                      ShimmerEffect(width: 80, height: 25),
                      // Add to cart
                      ShimmerEffect(width: 45, height: 33),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }

}
