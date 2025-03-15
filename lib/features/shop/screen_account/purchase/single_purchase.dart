import 'package:fincom/common/layout_models/product_list_layout.dart';
import 'package:fincom/common/widgets/custom_shape/image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/product/product_cards/product_card_cart_items.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/formatters/formatters.dart';
import '../../../settings/app_settings.dart';
import '../../controller_account/purchase/purchase_controller.dart';
import '../../models/purchase_model.dart';
import 'update_purchase/update_purchase.dart';


class SinglePurchase extends StatefulWidget {
  const SinglePurchase({super.key, required this.purchase});

  final PurchaseModel purchase;

  @override
  State<SinglePurchase> createState() => _SinglePurchaseState();
}

class _SinglePurchaseState extends State<SinglePurchase> {
  late PurchaseModel _purchase;
  final PurchaseController _purchaseController = Get.put(PurchaseController());

  @override
  void initState() {
    super.initState();
    _purchase = widget.purchase; // Initialize with the passed purchase
  }

  Future<void> _refreshPurchase() async {
      final updatedPurchase = await _purchaseController.getPurchaseByID(id: _purchase.id ?? '');
      setState(() {
        _purchase = updatedPurchase; // Update the purchase data
      });
  }

  @override
  Widget build(BuildContext context) {
    const double cartTileHeight = Sizes.cartTileHeight;
    final purchaseController = Get.put(PurchaseController());
    final purchase = _purchase;

    return Scaffold(
      appBar: TAppBar2(
        titleText: 'Purchase #${purchase.purchaseID}',
        widget: TextButton(
            onPressed: () => Get.to(() => UpdatePurchase(purchase: purchase,)), 
            child: Text('Edit', style: TextStyle(color: TColors.linkColor),)
        ),
      ),
      body: RefreshIndicator(
        color: TColors.refreshIndicator,
        onRefresh: () async => _refreshPurchase(),
        child: ListView(
          padding: TSpacingStyle.defaultPagePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Column(
              spacing: Sizes.spaceBtwSection,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  spacing: Sizes.spaceBtwItems,
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
                        Text(TFormatter.formatStringDate(purchase.date.toString())),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Vendor'),
                        Text(purchase.vendor?.company ?? ''),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total'),
                        Text(purchase.total.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payment'),
                        Text(purchase.paymentAmount.toString()),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: TColors.borderSecondary,
                    ),
                  ],
                ),


                // Products
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Sizes.spaceBtwItems,
                  children: [
                    Text('Products ${purchase.purchasedItems?.length.toString()}'),
                    GridLayout(
                        itemCount: purchase.purchasedItems?.length ?? 0,
                        crossAxisCount: 1,
                        mainAxisExtent: cartTileHeight,
                        itemBuilder: (context, index) {
                          return CartTile(cartItem: purchase.purchasedItems![index]);
                        }
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total'),
                        Text(AppSettings.appCurrencySymbol + (purchase.total ?? 0).toStringAsFixed(0)),
                      ],
                    )
                  ],
                ),

                // Image of Invoice
                Column(
                  spacing: Sizes.spaceBtwItems,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Invoice Image'),
                    ListLayout(
                        height: 150,
                        itemCount: purchase.purchaseInvoiceImages?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Padding(
                                padding: EdgeInsets.only(right: Sizes.sm),
                                child: TRoundedImage(
                                  height: 150,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  backgroundColor: Theme.of(context).colorScheme.surface,
                                  borderRadius: 15,
                                  isNetworkImage: true,
                                  image: purchase.purchaseInvoiceImages?[index].imageUrl ?? '',
                                  isTapToEnlarge: true,
                                )
                            );
                        }
                    )
                  ],
                ),
                Center(child: TextButton(
                    onPressed: () => purchaseController.deletePurchase(id: purchase.id ?? '', context: context),
                    child: Text('Delete', style: TextStyle(color: Colors.red),))
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

