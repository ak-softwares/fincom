import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/formatters/formatters.dart';
import '../../../../../utils/helpers/order_helper.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../settings/app_settings.dart';
import '../../../models/order_model.dart';
import '../../../../../common/web_view/my_web_view.dart';
import '../../orders/widgets/order_image_gallery.dart';
import '../single_sale.dart';

class SaleTile extends StatelessWidget {
  const SaleTile({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final double tileRadius = AppSizes.saleTileRadius;

    return InkWell(
      onTap: () => Get.to(() => SingleSaleScreen(sale: order)),
      child: Container(
        padding: TSpacingStyle.defaultPagePadding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(tileRadius),
        ),
        child: Column(
          spacing: AppSizes.xs,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Invoice Number'),
                Text(order.invoiceNumber.toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order Number'),
                Row(
                  children: [
                    Text('#${order.orderId}'),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: order.orderId.toString()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order Id copied')),
                        );
                      },
                      child: const Icon(Icons.copy, size: 17),
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order Date'),
                Text(AppFormatter.formatDate(order.dateCreated)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text('${AppSettings.currencySymbol}${order.total}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status'),
                Row(
                  children: [
                    Text(order.status?.prettyName ?? ''),
                    if (OrderHelper.checkOrderStatusForInTransit(order.status ?? OrderStatus.unknown)) ...[
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => Get.to(() => MyWebView(
                          title: 'Track Order #${order.orderId}',
                          url: APIConstant.wooTrackingUrl + order.orderId.toString(),
                        )),
                        child: const Icon(Icons.open_in_new, size: 17, color: AppColors.linkColor),
                      ),
                    ]
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
            Container(height: 1, color: AppColors.borderDark),
            const SizedBox(height: AppSizes.xs),
            Row(
              children: [
                Flexible(
                  child: OrderImageGallery(cartItems: order.lineItems ?? [], galleryImageHeight: 40),
                ),
                const SizedBox(width: AppSizes.sm),
                Container(height: 40, width: 1, color: AppColors.borderDark),
                const SizedBox(width: AppSizes.sm),
                // You can add a second image list here like invoice images if needed
                const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
