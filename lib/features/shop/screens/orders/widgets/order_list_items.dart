import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


import '../../../../../common/styles/shadows.dart';
import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/db_constants.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/order_helper.dart';
import '../../../models/order_model.dart';
import '../single_order_screen.dart';
import 'cancel_order.dart';
import 'order_image_gallery.dart';
import 'repeat_order.dart';
import 'track_now.dart';

class SingleOrderTile extends StatelessWidget {
  const SingleOrderTile({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final double orderImageHeight = Sizes.orderImageHeight;
    final double orderImageWidth = Sizes.orderImageWidth;
    final double orderTileHeight = Sizes.orderTileHeight;
    final double orderTileRadius = Sizes.orderTileRadius;

    return InkWell(
      onTap: () => Get.to(() => SingleOrderScreen(order: order)),
      child: Container(
        padding: TSpacingStyle.defaultPagePadding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(orderTileRadius),
          boxShadow: const [TShadowStyle.horizontalProductShadow],
        ),
        child: Stack(
          children: [
            Column(
              spacing: Sizes.xs,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderImageGallery(order: order, galleryImageHeight: 60),
                Container(
                  height: 1,
                  color: TColors.borderSecondary,
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
                      TOrderHelper.checkOrderStatusForReturn(order.status ?? '')
                          ? CancelOrderWidget(orderId: order.id.toString())
                          : TOrderHelper.checkOrderStatusForInTransit(order.status ?? '')
                            ? TrackOrderWidget(orderId: order.id.toString())
                            : RepeatOrderWidget(cartItems: order.lineItems ?? []),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(top: 0, right: 0, child: TOrderHelper.mapOrderStatus(order.status ?? '')),
          ],
        ),
      ),
    );
  }
}
