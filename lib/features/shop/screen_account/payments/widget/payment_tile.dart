import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../common/styles/shadows.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/payment_method.dart';

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({super.key, required this.paymentMethod});

  final PaymentMethodModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    const double customerVoucherTileHeight = Sizes.customerVoucherTileHeight;
    const double customerVoucherTileWidth = Sizes.customerVoucherTileWidth;
    const double customerVoucherTileRadius = Sizes.customerVoucherTileRadius;
    const double customerVoucherImageHeight = Sizes.customerVoucherImageHeight;
    const double customerVoucherImageWidth = Sizes.customerVoucherImageWidth;

    return Container(
        width: customerVoucherTileWidth,
        padding: const EdgeInsets.all(Sizes.xs),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(customerVoucherTileRadius),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: ListTile(
          minTileHeight: customerVoucherTileHeight - 10,
          title: Text(paymentMethod.paymentMethodName ?? '', style: TextStyle(fontSize: 14)),
          subtitle: Text(paymentMethod.openingBalance.toString(), style: TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,), // Paying status
        )
    );
  }

}
