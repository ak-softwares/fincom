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
  const SaleTile({super.key, required this.sale});
  final OrderModel sale;

  @override
  Widget build(BuildContext context) {
    final double tileRadius = AppSizes.saleTileRadius;
    final bool isPaid = (sale.status == OrderStatus.completed || sale.status == OrderStatus.returned);
    // final bool isPaid = sale.setPaid ?? false;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => Get.to(() => SingleSaleScreen(sale: sale)),
      child: Container(
        padding: AppSpacingStyle.defaultPagePadding,
        decoration: BoxDecoration(
          color: isPaid
              ? Theme.of(context).colorScheme.surface
              : isDarkMode
                ? Colors.red.withOpacity(0.3) // More visible in dark mode
                : Colors.red.withOpacity(0.1), // Softer in light mode
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
                Text(sale.invoiceNumber.toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order Number'),
                Row(
                  children: [
                    Text('#${sale.orderId}'),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: sale.orderId.toString()));
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
                Text(AppFormatter.formatDate(sale.dateCreated)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text('${AppSettings.currencySymbol}${sale.total}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status'),
                Row(
                  children: [
                    Text(sale.status?.prettyName ?? ''),
                    if (OrderHelper.checkOrderStatusForInTransit(sale.status ?? OrderStatus.unknown)) ...[
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => Get.to(() => MyWebView(
                          title: 'Track Order #${sale.orderId}',
                          url: APIConstant.wooTrackingUrl + sale.orderId.toString(),
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
                  child: OrderImageGallery(cartItems: sale.lineItems ?? [], galleryImageHeight: 40),
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
