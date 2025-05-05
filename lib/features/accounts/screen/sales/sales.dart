import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:fincom/utils/constants/sizes.dart';
import 'package:line_icons/line_icons.dart';

import '../../../../common/dialog_box_massages/animation_loader.dart';
import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/shimmers/order_shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../common/navigation_bar/appbar.dart';
import '../../controller/sales_controller/sales_controller.dart';
import 'add_barcode_sale.dart';
import 'add_sale.dart';
import 'widget/sale_tile.dart';

class Sales extends StatelessWidget {
  const Sales({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final controller = Get.put(SaleController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshSales();
    });

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!controller.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (controller.sales.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          controller.isLoadingMore(true);
          controller.currentPage++; // Increment current page
          await controller.getSales();
          controller.isLoadingMore(false);
        }
      }
    });

    final Widget emptyWidget = AnimationLoaderWidgets(
      text: 'Whoops! No Orders Found...',
      animation: Images.pencilAnimation,
    );
    
    return Scaffold(
        appBar: AppAppBar(
            title: 'Sales',
            searchType: SearchType.orders,
            widgetInActions: Row(
              children: [
                IconButton(
                    onPressed: () => Get.to(() => AddBarcodeSale()),
                    icon: Icon(Icons.qr_code_scanner_outlined)
                ),
                Obx(() => controller.isSyncing.value
                    ? TextButton(
                        onPressed: () => controller.stopSyncing(),
                        child: Row(
                          spacing: AppSizes.sm,
                          children: [
                            SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.linkColor,strokeWidth: 2,)),
                            Text('Stop', style: TextStyle(color: AppColors.linkColor),),
                          ],
                        ),
                      )
                    : TextButton(
                        onPressed: () => controller.syncOrders(),
                        child: Text('Sync', style: TextStyle(color: AppColors.linkColor),),
                      )),
              ],
            )
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'sales_fab', // 👈 Add a unique heroTag here
          shape: CircleBorder(),
          backgroundColor: Colors.blue,
          onPressed: () => Get.to(() => AddNewSale()),
          tooltip: 'Send WhatsApp Message',
          child: Icon(LineIcons.plus, size: 30, color: Colors.white,),
        ),
        body: RefreshIndicator(
          color: AppColors.refreshIndicator,
          onRefresh: () async => controller.refreshSales(),
          child: ListView(
            controller: scrollController,
            padding: TSpacingStyle.defaultPagePadding,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Obx(() {
                if (controller.isLoading.value) {
                  return OrderShimmer(itemCount: 2,);
                } else if(controller.sales.isEmpty) {
                  return emptyWidget;
                } else {
                  final sales = controller.sales;
                  return GridLayout(
                      itemCount: controller.isLoadingMore.value ? sales.length + 2 : sales.length,
                      crossAxisCount:  1,
                      mainAxisExtent: AppSizes.saleTileHeight,
                      itemBuilder: (context, index) {
                        if (index < sales.length) {
                          return SaleTile(order: sales[index]);
                        } else {
                          return OrderShimmer();
                        }
                      }
                  );
                }
              }),
            ],
          ),
        )
    );
  }
}
