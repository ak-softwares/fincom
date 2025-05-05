import 'package:fincom/utils/constants/sizes.dart';

import '../../../../common/dialog_box_massages/animation_loader.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/shimmers/order_shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar.dart';
import '../../controller/sales_controller/new_order_found_controller.dart';
import '../orders/widgets/order_tile.dart';
import '../search/search.dart';

class NewOrderFound extends StatelessWidget {
  const NewOrderFound({super.key});

  @override
  Widget build(BuildContext context) {
    final newOrderFoundController = Get.put(NewOrderFoundController());

    newOrderFoundController.refreshOrders();

    final Widget emptyWidget = AnimationLoaderWidgets(
      text: 'Whoops! No Orders Found...',
      animation: Images.pencilAnimation,
    );

    return Scaffold(
        appBar: const AppAppBar(title: 'New Order Found', searchType: SearchType.orders),
        bottomNavigationBar: Obx(() => newOrderFoundController.selectedOrders.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.sm, horizontal: AppSizes.xl),
                child: ElevatedButton(
                    onPressed: () => newOrderFoundController.uploadSelectedOrders(),
                    child: newOrderFoundController.isUploading.value
                        ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator())
                        : Text('Upload Orders')
                ),
              )
            : SizedBox.shrink(),
        ),
        body: RefreshIndicator(
          color: AppColors.refreshIndicator,
          onRefresh: () async => newOrderFoundController.refreshOrders(),
          child: ListView(
            padding: TSpacingStyle.defaultPagePadding,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) => newOrderFoundController.searchOrders(value),
                  decoration: InputDecoration(
                    hintText: "Search Orders...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSizes.spaceBtwItems),
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('New Orders Found'),
                      newOrderFoundController.isGettingCount.value
                          ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator())
                          : Obx(() => Text(newOrderFoundController.parentOrders.length.toString()))
                    ],
                  ),
                  Column(
                    children: [
                      Text('Fincom count'),
                      newOrderFoundController.isGettingCount.value
                          ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator())
                          : Obx(() => Text(newOrderFoundController.fincomOrdersCount.value.toString()))
                    ],
                  )
                ],
              ),
              ),
              SizedBox(height: AppSizes.spaceBtwItems),
              Obx(() => newOrderFoundController.selectedOrders.isEmpty
                ? InkWell(
                    onTap: newOrderFoundController.selectAll,
                    child: Text('Select All'),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        InkWell(
                            onTap: newOrderFoundController.deselectAll,
                            child: Text('Deselect All (${newOrderFoundController.selectedOrders.length})'),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: newOrderFoundController.deleteSelectedOrders,
                        ),
                      ],
                    ),
              ),
              Obx(() {
                if (newOrderFoundController.isLoading.value) {
                  return OrderShimmer(itemCount: 2);
                } else if (newOrderFoundController.orders.isEmpty) {
                  return emptyWidget;
                } else {
                  final orders = newOrderFoundController.orders;
                  return GridLayout(
                    itemCount: newOrderFoundController.isLoadingMore.value ? orders.length + 2 : orders.length,
                    crossAxisCount: 1,
                    mainAxisExtent: AppSizes.orderTileHeight,
                    itemBuilder: (context, index) {
                      if (index < orders.length) {
                        final order = orders[index];
                        return Obx(() => InkWell(
                              onTap: () => newOrderFoundController.toggleSelection(order.orderId ?? 0),
                              child: Stack(
                                children: [
                                  OrderTile(order: order),
                                  if (newOrderFoundController.selectedOrders.contains(order.orderId))
                                    Container(
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: newOrderFoundController.selectedOrders.contains(order.orderId)
                                            ? Colors.blue.withOpacity(0.5)
                                            : Colors.white,
                                        border: Border.all(color: newOrderFoundController.selectedOrders.contains(order.orderId)
                                            ? Colors.blue
                                            : Colors.grey
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  if (newOrderFoundController.selectedOrders.contains(order.orderId))
                                    Positioned(
                                      // top: 8,
                                      // right: 8,
                                      child: Center(child: Icon(Icons.check, color: Colors.white, size: 35)),
                                    ),
                                ],
                              ),
                            ),
                        );
                      } else {
                        return OrderShimmer();
                      }
                    },
                  );
                }
              })
            ],
          ),
        )
    );
  }
}


