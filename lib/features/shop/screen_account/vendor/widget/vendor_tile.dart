import 'package:fincom/features/personalization/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/styles/shadows.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/vendor_model.dart';


class VendorTile extends StatelessWidget {
  const VendorTile({super.key, required this.vendor, this.pageSource = 'pc'});

  final VendorModel vendor;
  final String pageSource;

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
        leading: CircleAvatar(
          backgroundImage: NetworkImage(vendor.avatarUrl ?? ''), // User profile pic
          onBackgroundImageError: (_, __) => Icon(TIcons.customers), // Fallback icon
          maxRadius: 15,
        ),
        trailing: IconButton(onPressed: () {}, icon: Icon(TIcons.call, size: 15, color: Colors.blue,)),
        title: Text(vendor.company ?? '', style: TextStyle(fontSize: 14)),
        subtitle: Text(vendor.email ?? '', style: TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,), // Paying status
      )
    );
  }

}










