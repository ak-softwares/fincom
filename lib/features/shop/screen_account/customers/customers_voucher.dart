import 'package:fincom/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:fincom/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/layout_models/customers_grid_layout.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../controller_account/Customers_voucher/customers_voucher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../screens/products/scrolling_products.dart';
import '../search/search.dart';

class CustomersVoucher extends StatelessWidget {
  const CustomersVoucher({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final customersVoucherController = Get.put(CustomersVoucherController());

    customersVoucherController.refreshCustomers();

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!customersVoucherController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (customersVoucherController.customers.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          customersVoucherController.isLoadingMore(true);
          customersVoucherController.currentPage++; // Increment current page
          await customersVoucherController.getAllCustomers();
          customersVoucherController.isLoadingMore(false);
        }
      }
    });

    final Widget emptyWidget = TAnimationLoaderWidgets(
      text: 'Whoops! No Customer Found...',
      animation: Images.pencilAnimation,
    );

    return Scaffold(
        appBar: const AppAppBar2(titleText: 'Customers Voucher', searchType: SearchType.customers),
        body: RefreshIndicator(
          color: TColors.refreshIndicator,
          onRefresh: () async => customersVoucherController.refreshCustomers(),
          child: ListView(
            controller: scrollController,
            padding: TSpacingStyle.defaultPagePadding,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Obx(() => customersVoucherController.isSyncing.value
                  ? TRoundedContainer(
                      showBorder: true,
                      radius: 4,
                      borderColor: Colors.black,
                      child: Row(
                        spacing: Sizes.spaceBtwItems,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                          Column(
                            children: [
                              Text('Syncing ${customersVoucherController.totalProcessedCustomers}/${customersVoucherController.wooCustomersCount}', style: TextStyle(fontSize: 13),),
                              Text('New Products Found ${customersVoucherController.processedCustomers}', style: TextStyle(fontSize: 13)),
                            ],
                          ),
                          IconButton(
                              onPressed: customersVoucherController.stopSyncing, // Stop button
                              icon: Icon(Iconsax.close_circle, color: TColors.error)
                          )
                        ],
                      ),
                    )
                  : OutlinedButton(
                onPressed: customersVoucherController.syncCustomers,
                child: Text('Sync Customers'),
              )),
              SizedBox(height: Sizes.spaceBtwItems),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('Woocommerce count'),
                      customersVoucherController.isGettingCount.value
                          ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator())
                          : Text(customersVoucherController.wooCustomersCount.value.toString())
                    ],
                  ),
                  Column(
                    children: [
                      Text('Fincom count'),
                      customersVoucherController.isGettingCount.value
                          ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator())
                          : Text(customersVoucherController.fincomCustomersCount.value.toString())
                    ],
                  )
                ],
              ),
              ),
              SizedBox(height: Sizes.spaceBtwItems),
              CustomersGridLayout(
                sourcePage: "customers",
                controller: customersVoucherController,
                emptyWidget: emptyWidget,
                orientation: OrientationType.horizontal,
              ),
            ],
          ),
        )
    );
  }
}


