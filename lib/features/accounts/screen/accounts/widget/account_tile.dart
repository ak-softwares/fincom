import 'package:flutter/material.dart';

import '../../../../../common/widgets/common/colored_amount.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/account_model.dart';

class AccountTile extends StatelessWidget {
  const AccountTile({super.key, required this.payment, this.onTap});

  final AccountModel payment;
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
                  Text('Account Id'),
                  Text('#${payment.accountId.toString()}', style: TextStyle(fontSize: 14))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Accounts Name'),
                  Text(payment.accountName ?? '', style: TextStyle(fontSize: 14))
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
                  ColoredAmount(amount: payment.balance ?? 0.0)
                ],
              ),
            ],
          )
      ),
    );
  }

}
