import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../controllers/coupon/coupon_controller.dart';
import '../../coupon/coupon_screen.dart';
class TCouponCode extends StatelessWidget {
  const TCouponCode({super.key});

  @override
  Widget build(BuildContext context) {
    final couponController = Get.put(CouponController());

    return Column(
      children: [
        SizedBox(
          height: 60,
          child: TextFormField(
            controller: couponController.coupon,
            decoration: InputDecoration(
              hintText: 'Enter coupon code',
              prefixIcon: const Icon(Iconsax.discount_shape),
              prefixIconColor: AppColors.primaryColor,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {couponController.applyCoupon(couponController.coupon.text.trim());},
                  child: Obx(() => couponController.isCouponLoad.value
                      ? const SizedBox(width: 25, height: 25, child: CircularProgressIndicator(color: AppColors.linkColor),)
                      : const Text('Apply', style: TextStyle(color: Colors.blue))),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
              onPressed: () => Get.to(() => const CouponScreen()),
              child: Text('View All Coupons', style: Theme.of(context).textTheme.labelLarge),
          ),
        )
      ],
    );
  }
}
