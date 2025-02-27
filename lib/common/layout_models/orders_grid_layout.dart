import 'package:fincom/common/widgets/shimmers/order_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../features/shop/screens/orders/widgets/order_list_items.dart';
import '../../features/shop/screens/products/scrolling_products.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/navigation_helper.dart';
import '../widgets/loaders/animation_loader.dart';
import '../widgets/product/product_cards/product_card.dart';
import '../widgets/product/product_voucher/product_voucher_card.dart';
import '../widgets/shimmers/product_shimmer.dart';
import '../widgets/shimmers/product_voucher_shimmer.dart';
import 'product_grid_layout.dart';

class OrdersGridLayout extends StatelessWidget {
  const OrdersGridLayout({
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
        return OrderShimmer(itemCount: 2,);
      } else if(controller.orders.isEmpty) {
        return emptyWidget;
      } else {
        final orders = controller.orders;
        return GridLayout(
            itemCount: controller.isLoadingMore.value ? orders.length + 2 : orders.length,
            crossAxisCount: orientation == OrientationType.vertical ? 2 : 1,
            mainAxisExtent: Sizes.orderTileHeight,
            itemBuilder: (context, index) {
              if (index < orders.length) {
                return SingleOrderTile(order: orders[index]);
              } else {
                return OrderShimmer();
              }
            }
        );
      }
    });
  }
}
