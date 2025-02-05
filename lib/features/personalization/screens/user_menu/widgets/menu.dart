import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/text/section_heading.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../settings/app_settings.dart';
import '../../../../shop/controllers/product/product_controller.dart';
import '../../../../shop/screens/all_products/all_products.dart';
import '../../../../shop/screens/coupon/coupon_screen.dart';
import '../../../../shop/screens/orders/order.dart';
import '../../../../shop/screens/recently_viewed/recently_viewed.dart';
import '../../../../shop/screens/store/my_store.dart';
import '../../../../shop/screens/store/store.dart';
import '../../user_address/user_address.dart';
class Menu extends StatelessWidget {
  const Menu({
    super.key, this.showHeading = false,
  });

  final bool showHeading;

  @override
  Widget build(BuildContext context) {

    return Container(
        color: TColors.primaryBackground,
        width: double.infinity,
        padding: TSpacingStyle.defaultPagePadding,
        child: Column(
          children: [
            showHeading
              ? const Column(
                  children: [
                    TSectionHeading(title: 'Menu', verticalPadding: false),
                    Divider(color: TColors.primaryColor, thickness: 2,),
                  ],
                )
              : const SizedBox.shrink(),
            ListTile(
              onTap: () => Get.to(() => MyStoreScreen()),
              leading: Icon(TIcons.store, size: 20),
              title: Text('My Store', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('Experience shopping like never before.', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const OrderScreen()),
              leading: Icon(TIcons.order, size: 20),
              title: Text('My Orders', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('Track and repeat orders', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const UserAddressScreen()),
              leading: Icon(TIcons.location, size: 20),
              title: Text('My Addresses', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('Set shopping delivery address.', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const CouponScreen()),
              leading: Icon(TIcons.coupons, size: 20),
              title: Text('My Coupons', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('List of all the discounted coupons.', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => launchUrlString(AppSettings.playStore),
              leading: Icon(TIcons.rateUs, size: 20),
              title: Text('Rate us', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('Rate us on play store', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const RecentlyViewed()),
              leading: Icon(TIcons.recentlyView,size: 20),
              title: Text('Recently Viewed', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('All your recently viewed products.', style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        )
    );
  }
}
