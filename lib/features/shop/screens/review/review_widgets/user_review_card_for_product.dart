import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/product/image_controller.dart';
import '../../../models/product_review_model.dart';

class SingleReviewCard extends StatelessWidget {
  SingleReviewCard({super.key, required this.review});

  ReviewModel review;
  @override
  Widget build(BuildContext context) {
    final imagesController = Get.put(ImagesController());

    final imageSize = 40.0;
    // Using Html widget to parse HTML text
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TRoundedImage(
              image: review.reviewerAvatarUrl ?? Images.tProfileImage,
              height: imageSize,
              width: imageSize,
              borderRadius: 50,
              isNetworkImage: true,
            ),
            const SizedBox(width: AppSizes.spaceBtwItems,),
            SizedBox(
              width: 210,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      review.review!.replaceAll('<p>', '').replaceAll('</p>', '').replaceAll('<br />', ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Flexible(
                    child: RatingBarIndicator(
                      rating: review.rating!.toDouble(),
                      itemSize: 12,
                      unratedColor: Colors.grey[300],
                      itemBuilder: (_, __) =>  Icon(TIcons.starRating, color: AppColors.ratingStar),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        review.image != ''
            ? GestureDetector(
              onTap: () => imagesController.showEnlargedImage(review.image ?? ""),
              child: TRoundedImage(
                image: review.image ?? "",
                height: 60,
                width: 50,
                backgroundColor: Colors.transparent,
                borderRadius: 0,
                isNetworkImage: true,
              ),
            )
            : SizedBox.shrink(),
      ],
    );
  }
}
