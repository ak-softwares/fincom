import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../common/styles/shadows.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/payment_method.dart';
import '../../vendor/single_vendor.dart';
import '../single_payment.dart';

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({super.key, required this.payment, this.onTap});

  final PaymentMethodModel payment;
  final VoidCallback? onTap; // Function to handle tap events

  @override
  Widget build(BuildContext context) {
    const double paymentTileHeight = AppSizes.paymentTileHeight;
    const double paymentTileWidth = AppSizes.paymentTileWidth;
    const double paymentTileRadius = AppSizes.paymentTileRadius;
    const double paymentImageHeight = AppSizes.paymentImageHeight;
    const double paymentImageWidth = AppSizes.paymentImageWidth;

    return InkWell(
      onTap: onTap,
      child: Container(
          width: paymentTileWidth,
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(paymentTileRadius),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment Id'),
                  Text('#${payment.paymentId.toString()}', style: TextStyle(fontSize: 14))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payment Method'),
                  Text(payment.paymentMethodName ?? '', style: TextStyle(fontSize: 14))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Opening Balance'),
                  Text(payment.openingBalance.toString(), style: TextStyle(fontSize: 14))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Balance'),
                  AmountText(amount: payment.balance ?? 0.0)
                ],
              ),
            ],
          )
      ),
    );
  }

}
