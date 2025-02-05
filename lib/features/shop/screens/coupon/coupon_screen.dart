import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/shimmers/order_shimmer.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../controllers/coupon/coupon_controller.dart';
import 'widgets/single_coupon.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('coupon_screen');
    final couponController = Get.put(CouponController());
    final ScrollController scrollController = ScrollController();

    couponController.refreshCoupons();

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!couponController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (couponController.coupons.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          couponController.isLoadingMore(true);
          couponController.currentPage++; // Increment current page
          await couponController.getAllCoupons();
          couponController.isLoadingMore(false);
        }
      }
    });

    return Scaffold(
      appBar: const TAppBar2(titleText: 'Coupons', showBackArrow: true),
      body: RefreshIndicator(
        color: TColors.refreshIndicator,
        onRefresh: () async => couponController.refreshCoupons(),
        child: ListView(
          controller: scrollController,
          padding: TSpacingStyle.defaultPagePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const TSectionHeading(title: 'My Coupons'),
            Obx(() {
              if(couponController.isLoading.value){
                return const OrderShimmer();
              }else if(couponController.coupons.isEmpty) {
                return const TAnimationLoaderWidgets(
                  text: 'Whoops! Order is Empty...',
                  animation: Images.pencilAnimation,
                );
              }else {
                return GridLayout(
                  mainAxisExtent: 120,
                  itemCount: couponController.isLoadingMore.value ? couponController.coupons.length + 1 : couponController.coupons.length,
                  itemBuilder: (context, index) {
                    if (index < couponController.coupons.length) {
                      return SingleCouponItem(coupon: couponController.coupons[index]);
                    } else {
                      return const OrderShimmer();
                      // return const Center(child: CircularProgressIndicator(),);
                    }
                  },
                );
              }
            }),

          ],
        ),
      )
    );
  }
}
