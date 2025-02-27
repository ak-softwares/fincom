import 'package:line_icons/line_icons.dart';

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
import 'add_new_vendor.dart';

class VendorVoucher extends StatelessWidget {
  const VendorVoucher({super.key});

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
        appBar: const TAppBar2(titleText: 'Vendors Voucher', searchType: SearchType.customers),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Colors.blue,
          onPressed: () => Get.to(() => AddVendorPage()),
          tooltip: 'Send WhatsApp Message',
          child: Icon(LineIcons.plus, size: 30, color: Colors.white,),
        ),
        body: RefreshIndicator(
          color: TColors.refreshIndicator,
          onRefresh: () async => customersVoucherController.refreshCustomers(),
          child: ListView(
            controller: scrollController,
            padding: TSpacingStyle.defaultPagePadding,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
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


