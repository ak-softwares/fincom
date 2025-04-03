import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/settings/app_settings.dart';
import '../../../../features/shop/controllers/cart_controller/cart_controller.dart';
import '../../../../features/shop/models/cart_item_model.dart';
import '../../../../features/shop/screens/products/product_detail.dart';
import '../../../../features/shop/screens/products/products_widgets/product_title_text.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../styles/shadows.dart';
import '../../custom_shape/containers/rounded_container.dart';
import '../../custom_shape/image/circular_image.dart';
import '../quantity_add_buttons/quantity_add_buttons.dart';

class ProductCardForCart extends StatelessWidget {
  const ProductCardForCart({super.key, required this.cartItem, this.showBottomBar = false});

  final CartModel cartItem;
  final bool showBottomBar;
  @override
  Widget build(BuildContext context) {

    const double imageHeight = 80;
    const double cardRadius = AppSizes.productImageRadius;
    final cartController = CartController.instance;

    return InkWell(
      onTap: () => Get.to(() => ProductScreen(productId: cartItem.productId.toString(), pageSource: 'ProductCardForCart',)),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: AppSizes.defaultSpace),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSizes.productImageRadius),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    //Main Image
                    TRoundedImage(
                        image: cartItem.image ?? '',
                        height: imageHeight,
                        width: imageHeight,
                        borderRadius: cardRadius,
                        isNetworkImage: true,
                        padding: 0
                    ),

                    //Title, Rating and price
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(AppSizes.sm,),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Title
                                ProductTitle(title: cartItem.name ?? ''),
                                const SizedBox(height: AppSizes.spaceBtwItems),

                                //Star rating
                                // ProductStarRating(averageRating: product.averageRating ?? 0.0, ratingCount: product.ratingCount ?? 0),

                                //Price
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        '${cartItem.quantity}x${AppSettings.appCurrencySymbol}${cartItem.price!.toStringAsFixed(0)}',
                                        style: Theme.of(context).textTheme.bodyMedium
                                    ),
                                    // Text('Subtotal ', style: Theme.of(context).textTheme.labelLarge),
                                    Text(AppSettings.appCurrencySymbol + cartItem.subtotal!, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
                                    if (showBottomBar)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          QuantityAddButtons(
                                            quantity: cartItem.quantity, // Accessing value of RxInt
                                            add: () => cartController.addOneToCart(cartItem), // Incrementing value
                                            remove: () => cartController.removeOneToCart(cartItem: cartItem, context: context),
                                            size: 27,
                                          ),
                                        ],
                                      )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          showBottomBar
              ? Positioned(
            top: 3,
            left: 3,
            child: TRoundedContainer(
              width: 25,
              height: 25,
              radius: 25,
              padding: const EdgeInsets.all(0),
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.withOpacity(0.7)  // Dark grey for night mode
                  : Colors.grey.shade300, // Light grey for day mode,
              child: IconButton(
                color: Colors.grey.shade900,
                padding: EdgeInsets.zero,
                onPressed: () => cartController.removeFromCartDialog(cartItem: cartItem, context: context),
                icon: const Icon(Icons.close, size: 15),
              ),
            ),
          )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
