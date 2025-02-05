import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/shimmers/order_shimmer.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/product_review_controller.dart';
import '../../models/product_model.dart';
import '../../models/product_review_model.dart';
import 'create_product_review.dart';
import 'review_widgets/rating_progress_indicator.dart';
import 'review_widgets/user_review_card.dart';

class ProductReviewScreen extends StatelessWidget {
  const ProductReviewScreen({super.key, required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('review_screen');
    final productReviewController = Get.put(ProductReviewController());
    final ScrollController scrollController = ScrollController();

    productReviewController.refreshReviews(product.id.toString());

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!productReviewController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (productReviewController.reviews.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          productReviewController.isLoadingMore(true);
          productReviewController.currentPage++; // Increment current page
          await productReviewController.getReviewsByProductId(product.id.toString());
          productReviewController.isLoadingMore(false);
        }
      }
    });

    return Scaffold(
      appBar: const TAppBar2(titleText: 'Reviews & Ratings', showBackArrow: true, showCartIcon: true,),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(Sizes.md),
        child: OutlinedButton(
            onPressed: () => Get.to(() => CreateReviewScreen(productId: product.id,)),
            child: const Text('Add product review')
        ),
      ),
      body: RefreshIndicator(
        color: TColors.refreshIndicator,
        onRefresh: () async => productReviewController.refreshReviews(product.id.toString()),
        child: ListView(
          controller: scrollController,
          padding: TSpacingStyle.defaultPagePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            //Section 1
            const SizedBox(height: Sizes.lg),
            Center(child: Text('Overall Rating', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey))),
            const SizedBox(height: Sizes.md),
            Center(child: Text(product.averageRating!.toStringAsFixed(1), style: Theme.of(context).textTheme.displayMedium)),
            const SizedBox(height: Sizes.sm),
            Center(
              child: RatingBarIndicator(
                rating: product.averageRating ?? 0.0,
                itemSize: 40,
                unratedColor: Colors.grey[300],
                itemBuilder: (_, __) =>  Icon(TIcons.starRating, color: TColors.ratingStar),
              ),
            ),
            const SizedBox(height: Sizes.sm),
            Center(child: Text('Based on ${product.ratingCount} reviews', style: Theme.of(context).textTheme.labelLarge)),
            const SizedBox(height: Sizes.lg),

            //Section 2
            // user review list

            Column(
              children: [
                Obx(() {
                  if (productReviewController.isLoading.value){
                    return const OrderShimmer();
                  } else if(productReviewController.reviews.isEmpty) {
                    return const TAnimationLoaderWidgets(
                      text: 'Whoops! No Review yet! Be the First Reviewer',
                      animation: Images.pencilAnimation,
                    );
                  } else{

                    final List<ReviewModel> reviews = productReviewController.reviews;

                    int totalReviews = reviews.length;
                    int excellentCount = reviews.where((review) => review.rating == 5).length;
                    int goodCount = reviews.where((review) => review.rating == 4).length;
                    int averageCount = reviews.where((review) => review.rating == 3).length;
                    int belowAverageCount = reviews.where((review) => review.rating == 2).length;
                    int poorCount = reviews.where((review) => review.rating == 1).length;

                    double excellentPercentage = totalReviews != 0 ? excellentCount / totalReviews : 0;
                    double goodPercentage = totalReviews != 0 ? goodCount / totalReviews : 0;
                    double averagePercentage = totalReviews != 0 ? averageCount / totalReviews : 0;
                    double belowAveragePercentage = totalReviews != 0 ? belowAverageCount / totalReviews : 0;
                    double poorPercentage = totalReviews != 0 ? poorCount / totalReviews : 0;

                    return Column(
                      children: [
                        TRatingProgressIndicator(text: 'Excellent', value: excellentPercentage, color: Colors.green,),
                        TRatingProgressIndicator(text: 'Good', value: goodPercentage,color: Colors.lightGreen),
                        TRatingProgressIndicator(text: 'Average', value: averagePercentage,color: Colors.yellow),
                        TRatingProgressIndicator(text: 'Below Average', value: belowAveragePercentage,color: Colors.orangeAccent),
                        TRatingProgressIndicator(text: 'Poor', value: poorPercentage,color: Colors.redAccent),
                        const SizedBox(height: Sizes.lg),
                        const Divider(color: TColors.borderSecondary,),
                        const SizedBox(height: Sizes.sm),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: productReviewController.isLoadingMore.value ? reviews.length + 1 : reviews.length,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (_, __) => const Column(
                            children: [
                              SizedBox(height: 10,),
                              Divider(color: TColors.borderSecondary),
                            ],
                          ),
                          itemBuilder: (_, index) {
                            if (index < reviews.length) {
                              return TUserReviewCard(review: reviews[index]);
                            } else {
                              return const OrderShimmer(itemCount: 2);
                            }
                          },
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




