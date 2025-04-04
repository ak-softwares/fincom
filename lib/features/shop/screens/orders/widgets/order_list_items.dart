import 'package:fincom/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../../../../../common/styles/spacing_style.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/order_helper.dart';
import '../../../models/cart_item_model.dart';
import '../../../models/order_model.dart';
import '../single_order_screen.dart';
import 'order_image_gallery.dart';

class SingleOrderTile extends StatelessWidget {
  const SingleOrderTile({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final double orderImageHeight = AppSizes.orderImageHeight;
    final double orderImageWidth = AppSizes.orderImageWidth;
    final double orderTileHeight = AppSizes.orderTileHeight;
    final double orderTileRadius = AppSizes.orderTileRadius;
    final List<CartModel> cartItems = order.lineItems ?? [];

    return InkWell(
      onTap: () => Get.to(() => SingleOrderScreen(order: order)),
      child: Stack(
        children: [
          Container(
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
              spacing: AppSizes.xs,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderImageGallery(cartItems: cartItems, galleryImageHeight: 60),
                Container(
                  height: 1,
                  color: AppColors.borderDark,
                ),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(' #${order.id}', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 17,),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: order.id.toString()));
                              // You might want to show a snackbar or toast to indicate successful copy
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Order Id copied')),
                              );
                            },
                          )
                        ],
                      ),
                      Row(
                        spacing: AppSizes.xs,
                        children: [
                          // Icon(Icons.money, size: 17),
                          Text(order.paymentMethod?.capitalizeFirst ?? '', style: TextStyle(fontSize: 12),),
                        ],
                      ),
                      OrderHelper.mapOrderStatus(order.status ?? OrderStatus.unknown,)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 1,
              right: 1,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm, vertical: AppSizes.xs),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(orderTileRadius),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(orderTileRadius * 3), // Making bottom-left bigger
                    ),              ),
                  child: Center(
                      child: Text('  ${order.getDaysDelayed.toString()} Delay', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500, fontSize: 12),)
                  )
              )
          ),
        ],
      ),
    );
  }
}
