import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fincom/utils/constants/sizes.dart';

import '../../../../common/layout_models/orders_grid_layout.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../controller_account/sales_controller/sales_controller.dart';
import '../../screens/products/scrolling_products.dart';
import '../search/search.dart';
import 'new_order_found.dart';

class SalesVoucher extends StatelessWidget {
  const SalesVoucher({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final salesVoucherController = Get.put(SalesVoucherController());

    salesVoucherController.refreshOrders();

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!salesVoucherController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (salesVoucherController.orders.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          salesVoucherController.isLoadingMore(true);
          salesVoucherController.currentPage++; // Increment current page
          await salesVoucherController.getAllOrders();
          salesVoucherController.isLoadingMore(false);
        }
      }
    });

    final Widget emptyWidget = TAnimationLoaderWidgets(
      text: 'Whoops! No Orders Found...',
      animation: Images.pencilAnimation,
    );
    
    return Scaffold(
        appBar: const AppAppBar2(titleText: 'Sales Voucher', searchType: SearchType.orders),
        body: RefreshIndicator(
          color: TColors.refreshIndicator,
          onRefresh: () async => salesVoucherController.refreshOrders(),
          child: ListView(
            controller: scrollController,
            padding: TSpacingStyle.defaultPagePadding,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              OutlinedButton(
                onPressed: () => Get.to(() => NewOrderFound()),
                child: Text('Go to new Orders ->'),
              ),
              SizedBox(height: Sizes.spaceBtwItems),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('Woocommerce count'),
                      salesVoucherController.isGettingCount.value
                          ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator())
                          : Text(salesVoucherController.wooOrdersCount.value.toString())
                    ],
                  ),
                  Column(
                    children: [
                      Text('Fincom count'),
                      salesVoucherController.isGettingCount.value
                          ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator())
                          : Text(salesVoucherController.fincomOrdersCount.value.toString())
                    ],
                  )
                ],
              )),
              SizedBox(height: Sizes.spaceBtwItems),
              OrdersGridLayout(controller: salesVoucherController, orientation: OrientationType.horizontal, emptyWidget: emptyWidget, sourcePage: 'recently_view',),
            ],
          ),
        )
    );
  }
}


