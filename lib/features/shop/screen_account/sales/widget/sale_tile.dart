import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/web_view/my_web_view.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/formatters/formatters.dart';
import '../../../../../utils/helpers/order_helper.dart';
import '../../../../settings/app_settings.dart';
import '../../../controllers/order/order_controller.dart';
import '../../../models/order_model.dart';
import '../../../screens/orders/single_order_screen.dart';
import '../../../screens/orders/widgets/order_image_gallery.dart';

class SingleOrderTile extends StatelessWidget {
  const SingleOrderTile({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final double orderImageHeight = AppSizes.orderImageHeight;
    final double orderImageWidth = AppSizes.orderImageWidth;
    final double orderTileHeight = AppSizes.orderTileHeight;
    final double orderTileRadius = AppSizes.orderTileRadius;
    final orderController = Get.find<OrderController>();

    return InkWell(
      onTap: () => Get.to(() => SingleOrderScreen(order: order)),
      child: Container(
        padding: TSpacingStyle.defaultPagePadding,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(orderTileRadius),
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.outline, // Border color
            )
        ),
        child: Column(
          children: [
            Column(
              spacing: AppSizes.xs,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order Number'),
                    Row(
                      spacing: AppSizes.sm,
                      children: [
                        Text(' #${order.id}'),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: order.id.toString()));
                            // You might want to show a snackbar or toast to indicate successful copy
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Order Id copied')),
                            );
                          },
                          child: const Icon(Icons.copy, size: 17,),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order Total'),
                    Row(
                      children: [
                        Text('${AppSettings.appCurrencySymbol}${order.total}'),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order Date'),
                    Row(
                      children: [
                        Text(AppFormatter.formatStringDate(order.dateCreated ?? '')),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order Status'),
                    Row(
                      spacing: AppSizes.sm,
                      children: [
                        Text(order.status?.prettyName ?? ''),
                        if(OrderHelper.checkOrderStatusForInTransit(order.status ?? OrderStatus.unknown))
                          InkWell(
                            onTap: () => Get.to(() => MyWebView(title: 'Track Order #${order.id}', url: APIConstant.wooTrackingUrl + order.id.toString())),
                            child: const Icon(Icons.open_in_new, size: 17, color: AppColors.linkColor,),
                          )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.xs),
                OrderImageGallery(cartItems: order.lineItems ?? [], galleryImageHeight: 40),
              ],
            ),
            // Positioned(top: 0, right: 0, child: TOrderHelper.mapOrderStatus(order.status ?? OrderStatus.unknown)),
          ],
        ),
      ),
    );
  }
}
