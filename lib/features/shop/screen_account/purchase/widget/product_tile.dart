import 'package:flutter/material.dart';

import '../../../../../common/styles/shadows.dart';
import '../../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../common/widgets/product/quantity_add_buttons/quantity_add_buttons.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../../settings/app_settings.dart';
import '../../../controller_account/purchase/purchase_controller.dart';
import '../../../controller_account/purchase/update_purchase_controller.dart';
import '../../../controllers/cart_controller/cart_controller.dart';
import '../../../models/cart_item_model.dart';
import '../../../screens/products/products_widgets/product_title_text.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX

import '../../../../../common/styles/shadows.dart';
import '../../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../settings/app_settings.dart';
import '../../../controllers/cart_controller/cart_controller.dart';
import '../../../models/cart_item_model.dart';
import '../../../screens/products/products_widgets/product_title_text.dart';

class PurchaseProductCard extends StatelessWidget {
  const PurchaseProductCard({super.key, required this.cartItem, required this.controller});

  final CartModel cartItem;
  final dynamic controller;

  @override
  Widget build(BuildContext context) {
    const double purchaseProductTileHeight = Sizes.purchaseProductTileHeight;
    const double purchaseProductTileWidth = Sizes.purchaseProductTileWidth;
    const double purchaseProductTileRadius = Sizes.purchaseProductTileRadius;
    const double purchaseProductImageHeight = Sizes.purchaseProductImageHeight;
    const double purchaseProductImageWidth = Sizes.purchaseProductImageWidth;

    // Reactive variables for quantity and total
    final RxInt quantity = cartItem.quantity.obs;
    final RxDouble price = ((cartItem.price)?.toDouble() ?? 1.0).obs;

    return Obx(() {
      return Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: [
                // Main Image
                Padding(
                  padding: const EdgeInsets.only(left: Sizes.xs),
                  child: TRoundedImage(
                    image: cartItem.image ?? '',
                    height: purchaseProductImageHeight,
                    width: purchaseProductImageWidth,
                    borderRadius: purchaseProductTileRadius,
                    isNetworkImage: true,
                  ),
                ),

                // Title, Rating, and Price
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top:Sizes.xs, left: Sizes.sm, right: Sizes.sm),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        ProductTitle(title: cartItem.name ?? '', maxLines: 1),

                        // Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              spacing: Sizes.sm,
                              children: [
                                Text(AppSettings.appCurrencySymbol, style: TextStyle(fontSize: 16),),
                                SizedBox(
                                  // height: 30,
                                  width: 70,
                                  child: TextFormField(
                                    initialValue: price.value.toStringAsFixed(0),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      final double newPrice = double.tryParse(value) ?? price.value;
                                      price.value = newPrice;
                                      controller.updatePrice(item: cartItem, price: newPrice);
                                    },
                                    decoration: const InputDecoration(
                                      // border: InputBorder.none,
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.blue, // Blue color
                                          style: BorderStyle.solid, // Solid line (you can use `BorderStyle.none` to remove the default border)
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text('x', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),),
                            SizedBox(
                              width: 30,
                              child: TextFormField(
                                initialValue: quantity.value.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  final int newQuantity = int.tryParse(value) ?? quantity.value;
                                  quantity.value = newQuantity;
                                  controller.updateQuantity(item: cartItem, quantity: newQuantity);
                                },
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue, // Blue color
                                      style: BorderStyle.solid, // Solid line (you can use `BorderStyle.none` to remove the default border)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text('=', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            Obx(() => Text(
                                '${AppSettings.appCurrencySymbol}${(quantity.value * price.value).toStringAsFixed(0)}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 3,
            left: 3,
            child: TRoundedContainer(
              width: 25,
              height: 25,
              radius: 25,
              padding: const EdgeInsets.all(0),
              backgroundColor: Colors.grey.withOpacity(0.2),
              child: IconButton(
                color: Colors.grey,
                padding: EdgeInsets.zero,
                onPressed: () => controller.removeProducts(cartItem),
                icon: const Icon(Icons.close, size: 15),
              ),
            ),
          )
        ],
      );
    });
  }
}
