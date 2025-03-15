import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/dialog_box/dialog_massage.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/cart_controller/cart_controller.dart';
import '../../../controllers/order/order_controller.dart';

class CancelOrderWidget extends StatelessWidget {
  const CancelOrderWidget({
    super.key, required this.orderId,
  });

  final String orderId;
  @override
  Widget build(BuildContext context) {
    final orderController = Get.put(OrderController());
    final cartController = Get.put(CartController());

    return InkWell(
        // onTap: () async => await orderController.cancelOrder(orderId),
        onTap: () => DialogHelper.showDialog(
          context: context,
          title: 'Cancel Order',
          message: 'Are you sure you want to cancel this order?',
          toastMessage: 'Order cancel Successfully',
          function: () async {
            await orderController.cancelOrder(orderId);
          },
        ),
        child: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          cartController.isCancelLoading.value
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: TColors.linkColor))
            : Row(
                children: [
                  Text('Cancel Order', style: Theme.of(context).textTheme.bodyMedium!,),
                  const SizedBox(width: Sizes.sm),
                  const Icon(Icons.cancel, size: 18, color: Colors.red),
                ],
              )
          ],
        ))
    );
  }
}