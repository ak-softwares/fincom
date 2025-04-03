import 'package:fincom/common/layout_models/product_list_layout.dart';
import 'package:fincom/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/formatters/formatters.dart';
import '../../../../../utils/helpers/order_helper.dart';
import '../../../models/cart_item_model.dart';
import '../../../models/order_model.dart';
import '../../../models/purchase_model.dart';
import '../../../models/vendor_model.dart';
import '../../../screens/orders/widgets/order_image_gallery.dart';
import '../../vendor/single_vendor.dart';
import '../single_purchase.dart';

class PurchaseTile extends StatelessWidget {
  const PurchaseTile({super.key, required this.purchase});

  final PurchaseModel purchase;

  @override
  Widget build(BuildContext context) {
    final double purchaseTileHeight = AppSizes.purchaseTileHeight;
    final double purchaseTileWidth = AppSizes.purchaseTileWidth;
    final double purchaseTileRadius = AppSizes.purchaseTileRadius;
    final double purchaseImageHeight = AppSizes.purchaseImageHeight;
    final double purchaseImageWidth = AppSizes.purchaseImageWidth;
    final List<CartModel> cartItems = purchase.purchasedItems ?? [];

    return InkWell(
      onTap: () => Get.to(() => SinglePurchase(purchase: purchase)),
      child: Container(
        padding: TSpacingStyle.defaultPagePadding,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(purchaseTileRadius),
        ),
        child: Column(
          spacing: AppSizes.xs,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Number'),
                Text('#${purchase.purchaseID}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Date'),
                Text(AppFormatter.formatStringDate(purchase.date.toString())),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Vendor'),
                InkWell(
                  onTap: () => purchase.vendor != null ? Get.to(() => SingleVendor(vendor: purchase.vendor!)) : {},
                  child: Text(purchase.vendor?.company ?? '', style: TextStyle(color: Colors.blue),)
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total'),
                Text(purchase.total.toString()),
              ],
            ),
            Container(
              height: 1,
              color: AppColors.borderDark,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    child: OrderImageGallery(cartItems: cartItems, galleryImageHeight: 40)),
                SizedBox(width: AppSizes.sm),
                Container(height: 40, width: 1, color: AppColors.borderDark,),
                SizedBox(width: AppSizes.sm),
                purchase.purchaseInvoiceImages != null
                    ? Expanded(
                        child: ListLayout(
                            height: 40,
                            itemCount: purchase.purchaseInvoiceImages!.length,
                            itemBuilder: (_, index) => Padding(
                              padding: const EdgeInsets.only(right: AppSizes.sm),
                              child: TRoundedImage(
                                height: 40,
                                width: 40,
                                borderRadius: AppSizes.sm,
                                backgroundColor: Colors.white,
                                padding: AppSizes.xs,
                                isNetworkImage: true,
                                isTapToEnlarge: true,
                                image: purchase.purchaseInvoiceImages?[index].imageUrl ?? '',
                              ),
                            )
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
