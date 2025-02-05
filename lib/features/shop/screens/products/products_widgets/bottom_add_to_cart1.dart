import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/cart_controller/cart_controller.dart';
import '../../../models/product_model.dart';
import '../../checkout/checkout.dart';

class TBottomAddToCart1 extends StatelessWidget {
  const TBottomAddToCart1({super.key, this.quantity = 1, this.pageSource = '', required this.product});

  final int quantity;
  final String pageSource;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace, vertical: Sizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => cartController.addToCart(product: product, quantity: quantity, pageSource: pageSource),
              child: const Text('ADD TO CART'),
            ),
          ),
          const SizedBox(width: Sizes.spaceBtwInputFields),
          Expanded(
            child: ElevatedButton(
              onPressed: (){
                // Usage example
                try {
                  onPressed: () => cartController.addToCart(product: product, quantity: quantity, pageSource: pageSource);
                  Get.to(() => const CheckoutScreen());
                } catch (e) {
                  null;
                }
              },
              child: const Text('BUY NOW'),
            ),
          )
        ],
      ),
    );
  }
}
