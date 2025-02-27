import 'package:fincom/features/personalization/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/personalization/screens/user_profile/user_profile.dart';

import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../styles/shadows.dart';

class CustomerVoucherTile extends StatelessWidget {
  const CustomerVoucherTile({super.key, required this.customer, this.pageSource = 'pc'});

  final CustomerModel customer;
  final String pageSource;

  @override
  Widget build(BuildContext context) {
    const double customerVoucherTileHeight = Sizes.customerVoucherTileHeight;
    const double customerVoucherTileWidth = Sizes.customerVoucherTileWidth;
    const double customerVoucherTileRadius = Sizes.customerVoucherTileRadius;
    const double customerVoucherImageHeight = Sizes.customerVoucherImageHeight;
    const double customerVoucherImageWidth = Sizes.customerVoucherImageWidth;

    return GestureDetector(
        onTap: () => Get.to(() => const UserProfileScreen()),
        child: Container(
          width: customerVoucherTileWidth,
          padding: const EdgeInsets.all(Sizes.xs),
          decoration: BoxDecoration(
            boxShadow: [TShadowStyle.verticalProductShadow],
            borderRadius: BorderRadius.circular(customerVoucherTileRadius),
            color: Colors.white,
          ),
          child: ListTile(
            minTileHeight: customerVoucherTileHeight - 10,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(customer.avatarUrl ?? ''), // User profile pic
              onBackgroundImageError: (_, __) => Icon(TIcons.customers), // Fallback icon
              maxRadius: 15,
            ),
            trailing: IconButton(onPressed: () {}, icon: Icon(TIcons.call, size: 15, color: Colors.blue,)),
            title: Text(customer.name != ' ' ? customer.name : 'User', style: TextStyle(fontSize: 14)),
            subtitle: Text(customer.email ?? '', style: TextStyle(fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis,), // Paying status
          )
        )
    );
  }

}










