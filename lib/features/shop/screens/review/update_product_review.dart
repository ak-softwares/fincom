import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validators/validation.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../controllers/product/product_review_controller.dart';
import '../../models/product_review_model.dart';

class UpdateReviewScreen extends StatelessWidget {
  const UpdateReviewScreen({super.key, required this.review});

  final ReviewModel review;
  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('review_update_screen');

    final authenticationRepository = Get.put(AuthenticationRepository());
    final productReviewController = Get.put(ProductReviewController());
    productReviewController.editRating.value = review.rating ?? 0;
    productReviewController.editProductReview.text = review.review?.replaceAll('<p>', '').replaceAll('</p>', '').replaceAll('<br />', '') ?? '';
    return Scaffold(
      appBar: const TAppBar2(titleText: 'Update Reviews', showBackArrow: true, showCartIcon: true,),
      body: !authenticationRepository.isUserLogin.value
          ? const CheckLoginScreen(text: 'Please Login! before edit review!')
          : SingleChildScrollView(
              padding: TSpacingStyle.defaultSpaceLg,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Rating', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: Sizes.sm),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) => GestureDetector(
                        onTap: () {
                          productReviewController.editRating.value = index + 1;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: TColors.ratingStar), // Border color
                            // borderRadius: BorderRadius.circular(50), // Border radius to make it circular
                          ),
                          margin: const EdgeInsets.all(5), // Padding to add space between border and icon
                          padding: const EdgeInsets.all(5), // Padding to add space between border and icon
                          child: Icon(
                            index < productReviewController.editRating.value
                                ? Icons.star
                                : Icons.star_border,
                            color: TColors.ratingStar,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: Sizes.xs),
                  Text('Click to rate', style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: Sizes.xl),
                  Form(
                    key: productReviewController.editReviewFormKey,
                    child: Column(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Product review*', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: Sizes.xs),
                              TextFormField(
                                controller: productReviewController.editProductReview,
                                validator: (value) => TValidator.validateEmptyText(value, 'Product review'),
                                maxLines: 2,
                                decoration: InputDecoration(
                                    hintText: 'Example: Easy to use',
                                    border: const OutlineInputBorder(),
                                    hintStyle: Theme.of(context).textTheme.labelLarge
                                ),
                              ),
                            ]
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSection),
                  ElevatedButton(
                    onPressed: () => productReviewController.updateReview(review.id),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: Sizes.lg),
                      child: Text('Update product review'),
                    )
                  )
                ],
              ),
            ),
    );
  }
}
