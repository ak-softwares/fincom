import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/cart_controller/cart_controller.dart';
import '../../../models/cart_item_model.dart';

class ReturnOrderWidget extends StatelessWidget {
  const ReturnOrderWidget({
    super.key, required this.cartItems,
  });

  final List<CartItemModel> cartItems;
  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    return InkWell(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.refresh, size: 18, color: Colors.red),
            const SizedBox(width: Sizes.sm),
            Text('Return Order', style: Theme.of(context).textTheme.bodyMedium!,),
          ],
        )
    );
  }
}
