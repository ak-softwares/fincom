import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import 'branditemcount.dart';

class TBrandShowcase extends StatelessWidget {
  const TBrandShowcase({
    super.key, required this.images,
  });
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      margin: const EdgeInsets.only(bottom: AppSizes.spaceBtwItems),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(AppSizes.productImageRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const TBrandItemCount(isBorderShow: false),
          Row(children: images.map((image) => brandTopProductImageWidget(image, context)).toList(),)
        ],
      ),
    );
  }
  Widget brandTopProductImageWidget(String image, context) {
    return Expanded(
      child: Container(
        height: 100,
        margin: const EdgeInsets.only(right: AppSizes.md),
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(AppSizes.productImageRadius),
        ),
        child: Image(image: AssetImage(image), fit: BoxFit.contain),
      ),
    );
  }
}
