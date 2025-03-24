import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/shimmers/customers_voucher_shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller_account/payment/payment_controller.dart';
import '../../screens/products/scrolling_products.dart';
import 'add_payment.dart';
import 'single_payment.dart';
import 'widget/payment_tile.dart';
import 'widget/payment_tile_simmer.dart';

class Payments extends StatelessWidget {
  const Payments({super.key});

  @override
  Widget build(BuildContext context) {
    const double paymentTileHeight = Sizes.paymentTileHeight;

    final ScrollController scrollController = ScrollController();
    final paymentController = Get.put(PaymentMethodController());

    paymentController.refreshPaymentMethods();

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!paymentController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (paymentController.paymentMethods.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          paymentController.isLoadingMore(true);
          paymentController.currentPage++; // Increment current page
          await paymentController.getAllPaymentMethods();
          paymentController.isLoadingMore(false);
        }
      }
    });

    final Widget emptyWidget = TAnimationLoaderWidgets(
      text: 'Whoops! No Payment Method Found...',
      animation: Images.pencilAnimation,
    );

    return Scaffold(
        appBar: const AppAppBar2(titleText: 'Payment Methods'),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Colors.blue,
          onPressed: () => Get.to(() => AddPayments()),
          tooltip: 'Add Payment Method',
          child: Icon(LineIcons.plus, size: 30, color: Colors.white,),
        ),
        body: RefreshIndicator(
          color: TColors.refreshIndicator,
          onRefresh: () async => paymentController.refreshPaymentMethods(),
          child: ListView(
            controller: scrollController,
            padding: TSpacingStyle.defaultPagePadding,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Obx(() {
                if (paymentController.isLoading.value) {
                  return  PaymentTileSimmer(itemCount: 2);
                } else if(paymentController.paymentMethods.isEmpty) {
                  return emptyWidget;
                } else {
                  final paymentMethods = paymentController.paymentMethods;
                  return Column(
                    children: [
                      GridLayout(
                          itemCount: paymentController.isLoadingMore.value ? paymentMethods.length + 2 : paymentMethods.length,
                          crossAxisCount: 1,
                          mainAxisExtent: paymentTileHeight,
                          itemBuilder: (context, index) {
                            if (index < paymentMethods.length) {
                              return PaymentMethodTile(
                                payment: paymentMethods[index],
                                onTap: () => Get.to(() => SinglePayment(payment: paymentMethods[index])),
                              );
                            } else {
                              return PaymentTileSimmer();
                            }
                          }
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        )
    );
  }
}