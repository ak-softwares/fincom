import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/shimmers/review_shimmer_on_product.dart';
import '../../../../data/repositories/woocommerce_repositories/product_review/product_review.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../models/product_model.dart';
import '../../models/product_review_model.dart';
import 'product_review.dart';
import 'review_widgets/user_review_card_for_product.dart';

class ProductReviewHorizontal extends StatefulWidget {
  const ProductReviewHorizontal({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductReviewHorizontal> createState() => _ProductReviewHorizontalState();
}

class _ProductReviewHorizontalState extends State<ProductReviewHorizontal> {
  final wooReviewRepository = Get.put(WooReviewRepository());

  late final ScrollController _scrollController;
  final RxInt _currentPage = 1.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxList<ReviewModel> _reviews = <ReviewModel>[].obs;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _refreshAllReviews();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  //Get review by product id
  Future<void> _getReviewsByProductId(String productId) async {
    try {
      //fetch products
      final newReviews = await wooReviewRepository.fetchReviewsByProductId(productIds: productId, page: _currentPage.toString());
      _reviews.addAll(newReviews);
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> _refreshAllReviews() async {
    try {
      _isLoading(true);
      _currentPage.value = 1; // Reset page number
      _reviews.clear(); // Clear existing orders
      await _getReviewsByProductId(widget.product.productId.toString());
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      _isLoading(false);
    }
  }

  void _scrollListener() async {
    if (_scrollController.position.extentAfter < 0.2 * _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore.value) {
        _isLoadingMore(true);
        final int itemsPerPage = int.parse(APIConstant.itemsPerPage); // Number of items per page
        if (_reviews.length % itemsPerPage != 0) {
          _isLoadingMore(false);
          return; // Stop fetching
        }
        _currentPage.value++; // Increment current page
        await _getReviewsByProductId(widget.product.productId.toString());
        _isLoadingMore(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewContainerHeight = 50.0;
    return Obx(() {
      if (_isLoading.value){
        return ReviewShimmerOnProduct(height: reviewContainerHeight);
      } else if (_reviews.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return InkWell(
          onTap: () => Get.to(() => ProductReviewScreen(product: widget.product)),
          child: TRoundedContainer(
              radius: 10,
              backgroundColor: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Reviews ', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600)),
                        // RatingBarIndicator(
                        //   // rating: 1,
                        //   // rating: widget.product.averageRating!.toDouble(),
                        //   itemSize: 14,
                        //   unratedColor: Colors.grey[300],
                        //   itemBuilder: (_, __) => Icon(TIcons.starRating, color: TColors.ratingStar),
                        // ),
                        Icon(TIcons.starRating, color: Colors.grey[300], size: 14,),
                        Text(' ${widget.product.averageRating?.toStringAsFixed(1)} (${widget.product.ratingCount.toString()})', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey.shade500)),
                      ],
                    ),
                    const SizedBox(height: AppSizes.sm),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 50,
                        aspectRatio: 1.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: Random().nextInt(6) + 3),
                        // enableInfiniteScroll: false, // Disable infinite scrolling
                        viewportFraction: 1.0,
                        scrollPhysics: BouncingScrollPhysics(), // Disable touch scroll

                      ),
                      items: _reviews.map((review) {
                        return Builder(
                          builder: (BuildContext context) {
                            return SingleReviewCard(review: review);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
        );
      }
    });
  }
}
