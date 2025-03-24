import 'package:line_icons/line_icons.dart';

import '../../../../common/layout_models/customers_grid_layout.dart';
import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/shimmers/customers_voucher_shimmer.dart';
import '../../../../common/widgets/tiles/Customers/customer_tile.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller_account/Customers_voucher/customers_voucher_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../controller_account/vendor/vendor_controller.dart';
import '../../screens/products/scrolling_products.dart';
import '../search/search.dart';
import 'add_new_vendor.dart';
import 'single_vendor.dart';
import 'widget/vendor_tile.dart';
import 'widget/vendor_tile_simmer.dart';

class Vendors extends StatelessWidget {
  const Vendors({super.key});

  @override
  Widget build(BuildContext context) {
    const double vendorTileHeight = Sizes.vendorTileHeight;

    final ScrollController scrollController = ScrollController();
    final vendorController = Get.put(VendorController());

    vendorController.refreshVendors();

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!vendorController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (vendorController.vendors.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          vendorController.isLoadingMore(true);
          vendorController.currentPage++; // Increment current page
          await vendorController.getAllVendors();
          vendorController.isLoadingMore(false);
        }
      }
    });

    final Widget emptyWidget = TAnimationLoaderWidgets(
      text: 'Whoops! No Vendor Found...',
      animation: Images.pencilAnimation,
    );
    return Scaffold(
        appBar: const AppAppBar2(titleText: 'Vendors', searchType: SearchType.customers),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Colors.blue,
          onPressed: () => Get.to(() => AddVendorPage()),
          tooltip: 'Add New Vendor',
          child: Icon(LineIcons.plus, size: 30, color: Colors.white,),
        ),
        body: RefreshIndicator(
          color: TColors.refreshIndicator,
          onRefresh: () async => vendorController.refreshVendors(),
          child: ListView(
            controller: scrollController,
            padding: TSpacingStyle.defaultPagePadding,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Obx(() {
                if (vendorController.isLoading.value) {
                  return  VendorTileSimmer(itemCount: 2);
                } else if(vendorController.vendors.isEmpty) {
                  return emptyWidget;
                } else {
                  final vendors = vendorController.vendors;
                  return Column(
                    children: [
                      GridLayout(
                          itemCount: vendorController.isLoadingMore.value ? vendors.length + 2 : vendors.length,
                          crossAxisCount: 1,
                          mainAxisExtent: vendorTileHeight,
                          itemBuilder: (context, index) {
                            if (index < vendors.length) {
                              return VendorTile(
                                vendor: vendors[index],
                                onTap: () => Get.to(() => SingleVendor(vendor: vendors[index])),
                              );
                            } else {
                              return VendorTileSimmer();
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


