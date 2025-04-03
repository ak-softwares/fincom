import 'package:fincom/common/widgets/shimmers/customers_voucher_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../features/shop/screen_account/customers/widget/customer_tile_simmer.dart';
import '../../features/shop/screens/products/scrolling_products.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../widgets/loaders/animation_loader.dart';
import '../widgets/tiles/Customers/customer_tile.dart';
import 'product_grid_layout.dart';

class CustomersGridLayout extends StatelessWidget {
  const CustomersGridLayout({
    super.key,
    required this.controller,
    required this.sourcePage,
    this.orientation = OrientationType.horizontal,
    this.emptyWidget = const TAnimationLoaderWidgets(text: 'Whoops! No products found...', animation: Images.pencilAnimation),
  });

  final dynamic controller;
  final String sourcePage;
  final OrientationType orientation;
  final Widget emptyWidget;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return  CustomersTileShimmer(itemCount: 2);
      } else if(controller.customers.isEmpty) {
        return emptyWidget;
      } else {
        final customers = controller.customers.value;
        return Column(
          children: [
            GridLayout(
                itemCount: controller.isLoadingMore.value ? customers.length + 2 : customers.length,
                crossAxisCount: 1,
                mainAxisExtent: AppSizes.customerVoucherTileHeight,
                itemBuilder: (context, index) {
                  if (index < customers.length) {
                    return CustomerVoucherTile(customer: customers[index]);
                  } else {
                    return CustomersTileShimmer();
                  }
                }
            ),
          ],
        );
      }
    });
  }
}
