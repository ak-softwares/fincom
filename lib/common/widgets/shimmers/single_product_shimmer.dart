import 'package:flutter/material.dart';

import '../../../features/shop/screens/products/scrolling_products.dart';
import '../../../utils/constants/sizes.dart';
import 'shimmer_effect.dart';
class SingleProductShimmer extends StatelessWidget {
  const SingleProductShimmer({
    super.key,
    this.orientation = OrientationType.vertical
  });

  final OrientationType orientation;

  @override
  Widget build(BuildContext context) {
    const double mainImageHeight = 340;
    const double galleryImageHeight = 80;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: mainImageHeight, //Main image height
          width: double.infinity,
          child: Center(child: ShimmerEffect(height: mainImageHeight, width: mainImageHeight, radius: AppSizes.productImageRadius,)),
        ),
        const SizedBox(height: AppSizes.spaceBtwItems),
        SizedBox(
          height: galleryImageHeight,
          child: ListView.separated(
            itemCount: 5,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (_,__) => const SizedBox(width: AppSizes.spaceBtwItems),
            itemBuilder: (_, index) => const ShimmerEffect(height: galleryImageHeight, width: galleryImageHeight, radius: AppSizes.productImageRadius,)
          )
        ),
        const SizedBox(height: AppSizes.spaceBtwSection),
        const ShimmerEffect(width: 100, height: 10, radius: 0,),
        const SizedBox(height: AppSizes.spaceBtwInputFields),
        const ShimmerEffect(width: double.infinity, height: 25, radius: 0,),
        const SizedBox(height: AppSizes.spaceBtwItems),
        const ShimmerEffect(width: 300, height: 25, radius: 0,),
        const SizedBox(height: AppSizes.spaceBtwSection),
        const ShimmerEffect(width: 150, height: 15),
        const SizedBox(height: AppSizes.spaceBtwItems),
        const ShimmerEffect(width: 100, height: 15),
      ],
    );
  }
}
