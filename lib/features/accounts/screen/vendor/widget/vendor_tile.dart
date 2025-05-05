import 'package:flutter/material.dart';

import '../../../../../common/widgets/common/colored_amount.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../personalization/models/user_model.dart';


class VendorTile extends StatelessWidget {
  const VendorTile({super.key, required this.vendor, this.onTap});

  final UserModel vendor;
  final VoidCallback? onTap; // Function to handle tap events

  @override
  Widget build(BuildContext context) {
    const double vendorTileHeight = AppSizes.vendorTileHeight;
    const double vendorTileWidth = AppSizes.vendorTileWidth;
    const double vendorTileRadius = AppSizes.vendorTileRadius;
    const double vendorImageHeight = AppSizes.vendorImageHeight;
    const double vendorImageWidth = AppSizes.vendorImageWidth;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: vendorTileWidth,
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(vendorTileRadius),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Vendor ID'),
                Text('#${vendor.userId}', style: TextStyle(fontSize: 14))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Vendor'),
                Text(vendor.company ?? '', style: TextStyle(fontSize: 14))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('GST'),
                Text(vendor.gstNumber ?? '', style: TextStyle(fontSize: 14))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Balance'),
                ColoredAmount(amount: vendor.balance ?? 0),
              ],
            ),
          ],
        )
      ),
    );
  }

}










