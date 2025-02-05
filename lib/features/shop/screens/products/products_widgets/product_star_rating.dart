import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class ProductStarRating extends StatelessWidget {
  const ProductStarRating({
    super.key, required this.averageRating, required this.ratingCount, this.size = 12, this.onTap,
  });
  final double averageRating;
  final int ratingCount;
  final double size;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
          // mainAxisAlignment: MainAxisAlignment.start, // Set MainAxisAlignment to start
          children: [
            //rating
            // const Text('  ', style:TextStyle(fontSize: 9),),
            RatingBarIndicator(
              rating: averageRating,
              itemSize: size*1.3,
              unratedColor: Colors.grey[300],
              itemBuilder: (_, __) => const Icon(Iconsax.star1, color: TColors.ratingStar),
            ),
            Text(
              ' ${averageRating.toStringAsFixed(1)}($ratingCount)',
              style: Theme.of(context).textTheme.labelMedium!
                  .copyWith(fontSize: size)),
            const SizedBox(width: Sizes.spaceBtwItems / 2),
            //Brand
            // TBrandWithVerifiedIcon(brandName: "Ultium"),
          ],
        ),
    );
  }
}
