import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/product/favourite_icon/favourite_icon.dart';
import '../../../../../common/widgets/product/quantity_add_buttons/quantity_add_buttons.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/cart_controller/cart_controller.dart';
import '../../../models/product_model.dart';
import '../../checkout/checkout.dart';

class TBottomAddToCart extends StatelessWidget {
  const TBottomAddToCart({super.key, this.quantity = 1, this.variationId = 0, this.pageSource = 'atcb', required this.product});

  final int quantity;
  final int variationId;
  final String pageSource;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    RxInt quantityInCart = quantity.obs;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.defaultSpace, vertical: AppSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 30,
            child: Obx(() {
              return QuantityAddButtons(
                size: 30,
                quantity: quantityInCart.value,
                // Accessing value of RxInt
                add: () => quantityInCart.value += 1,
                // Incrementing value
                remove: () => quantityInCart.value <= 1
                    ? null
                    : quantityInCart.value -= 1,
              );
            }),
          ),
          const SizedBox(width: AppSizes.spaceBtwInputFields),
          Expanded(
            flex: 50,
            child: ElevatedButton(
              onPressed: () {
                cartController.addToCart(
                  product: product,
                  quantity: quantityInCart.value,
                  variationId: variationId,
                  pageSource: pageSource
                );
              },
              child: const Text('ADD TO CART'),
            ),
          ),
          Expanded(
            flex: 20,
            child: TFavouriteIcon(product: product),
          )
        ],
      ),
    );
  }
}
