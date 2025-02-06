import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/cart_controller/cart_controller.dart';
import '../../../models/cart_item_model.dart';

class RepeatOrderWidget extends StatelessWidget {
  const RepeatOrderWidget({
    super.key, required this.cartItems,
  });

  final List<CartModel> cartItems;
  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    return InkWell(
        onTap: () => cartController.repeatOrder(cartItems),
        child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cartController.isLoading.value
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: TColors.linkColor))
                : Row(
                  children: [
                    Text('Repeat Order', style: Theme.of(context).textTheme.bodyMedium!,),
                    const SizedBox(width: Sizes.sm),
                    const Icon(Icons.refresh, size: 18, color: Colors.green),
                  ],
              )
            ],
          ),
        )
    );
  }
}
