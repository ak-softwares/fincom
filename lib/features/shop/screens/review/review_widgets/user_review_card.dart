import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/formatters/formatters.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../../personalization/controllers/customers_controller.dart';
import '../../../controllers/product/image_controller.dart';
import '../../../controllers/product/product_review_controller.dart';
import '../../../models/product_review_model.dart';
import '../../products/products_widgets/product_title_text.dart';
import '../update_product_review.dart';

class TUserReviewCard extends StatelessWidget {
  TUserReviewCard({super.key, required this.review});

  ReviewModel review;
  @override
  Widget build(BuildContext context) {
    final userController = Get.put(CustomersController());
    final productReviewController = Get.put(ProductReviewController());
    final imagesController = Get.put(ImagesController());

    // Using Html widget to parse HTML text
    final String reviewerName = TValidator.isEmail(review.reviewer ?? '') ? TFormatter.maskEmail(review.reviewer ?? '') : review.reviewer ?? '';
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TRoundedImage(
                  image: review.reviewerAvatarUrl ?? Images.tProfileImage,
                  height: 60,
                  width: 60,
                  borderRadius: 50,
                  isNetworkImage: true,
                ),
                const SizedBox(width: Sizes.spaceBtwItems,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 200,child: ProductTitle(title: reviewerName, maxLines: 1,)),
                    const SizedBox(height: 5),
                    RatingBarIndicator(
                      rating: review.rating!.toDouble(),
                      itemSize: 16,
                      unratedColor: Colors.grey[300],
                      itemBuilder: (_, __) =>  Icon(TIcons.starRating, color: TColors.ratingStar),
                    ),
                  ],
                ),
              ],
            ),
            userController.customer.value.email == review.reviewerEmail
                ? PopupMenuButton<String>(
                    onSelected: (String value) {
                      if (value == 'Delete') {
                        productReviewController.deleteReviewDialog(review.id);
                      } else if (value == 'Edit') {
                        Get.to(() => UpdateReviewScreen(review: review));
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
                    icon: const Icon(Icons.more_vert, color: TColors.linkColor),
                  )
                : PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Report',
                        child: Text('Report'),
                      ),
                    ],
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                  ),
          ],
        ),

        //Review
        const SizedBox(height: Sizes.sm),
        Row(
          children: [
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReadMoreText(
                    review.review!.replaceAll('<p>', '').replaceAll('</p>', '').replaceAll('<br />', ''),
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimExpandedText: ' show less',
                    trimCollapsedText: ' show more',
                    moreStyle: const TextStyle(fontSize: 14, color: Colors.blue),
                    lessStyle: const TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                  Text(TFormatter.formatStringDate(review.dateCreated ?? ''), style: Theme.of(context).textTheme.labelMedium)
                ],
              ),
            ),
            review.image != ''
                ? Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => imagesController.showEnlargedImage(review.image ?? ""),
                child: TRoundedImage(
                  image: review.image ?? "",
                  height: 70,
                  width: 60,
                  borderRadius: 0,
                  isNetworkImage: true,
                ),
              ),
            )
                : SizedBox.shrink(),
          ],
        ),
      ],
    );
  }
}
