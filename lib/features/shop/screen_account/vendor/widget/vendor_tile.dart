import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


import '../../../../../utils/constants/sizes.dart';
import '../../../models/vendor_model.dart';
import '../single_vendor.dart';


class VendorTile extends StatelessWidget {
  const VendorTile({super.key, required this.vendor, this.onTap});

  final VendorModel vendor;
  final VoidCallback? onTap; // Function to handle tap events

  @override
  Widget build(BuildContext context) {
    const double vendorTileHeight = Sizes.vendorTileHeight;
    const double vendorTileWidth = Sizes.vendorTileWidth;
    const double vendorTileRadius = Sizes.vendorTileRadius;
    const double vendorImageHeight = Sizes.vendorImageHeight;
    const double vendorImageWidth = Sizes.vendorImageWidth;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: vendorTileWidth,
        padding: const EdgeInsets.all(Sizes.defaultSpace),
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
                Text('#${vendor.vendorId}', style: TextStyle(fontSize: 14))
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
                Text((vendor.balance ?? 0).toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color: vendor.balance != null && vendor.balance! < 0 ? Colors.red : Colors.green
                    )
                )
              ],
            ),
            // Divider(color: Theme.of(context).colorScheme.outline),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     InkWell(
            //       onTap: () {},
            //       child: Row(
            //         spacing: Sizes.spaceBtwItems,
            //         children: [
            //           Text('Purchase'),
            //           Icon(Iconsax.money),
            //         ],
            //       ),
            //     ),
            //     Container(width: 1, height: 25, color: Theme.of(context).colorScheme.outline),
            //     InkWell(
            //       onTap: () {},
            //       child: Row(
            //         spacing: Sizes.spaceBtwItems,
            //         children: [
            //           Text('Transaction'),
            //           Icon(Iconsax.transaction_minus),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        )
      ),
    );
  }

}










