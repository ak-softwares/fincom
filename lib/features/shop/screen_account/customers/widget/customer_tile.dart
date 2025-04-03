import 'package:fincom/common/widgets/custom_shape/image/circular_image.dart';
import 'package:fincom/features/personalization/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/styles/shadows.dart';
import '../../../../../common/styles/spacing_style.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../personalization/screens/user_profile/user_profile.dart';
import '../single_customer.dart';


class CustomerTile extends StatelessWidget {
  const CustomerTile({super.key, required this.customer});

  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    const double customerVoucherTileHeight = AppSizes.customerVoucherTileHeight;
    const double customerVoucherTileWidth = AppSizes.customerVoucherTileWidth;
    const double customerVoucherTileRadius = AppSizes.customerVoucherTileRadius;
    const double customerVoucherImageHeight = AppSizes.customerVoucherImageHeight;
    const double customerVoucherImageWidth = AppSizes.customerVoucherImageWidth;

    return GestureDetector(
        onTap: () => Get.to(() => SingleCustomer(customer: customer)),
        child: Container(
            color: Theme.of(context).colorScheme.surface,
            width: customerVoucherTileWidth,
            padding: TSpacingStyle.defaultPagePadding,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Customer Id'),
                    Text('#${customer.customerId}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Name'),
                    Text(customer.name),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Balance'),
                    // Text(customer.balance.toString()),
                  ],
                ),
              ],
            )
        )
    );
  }

}










