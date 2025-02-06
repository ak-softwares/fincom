import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/text/section_heading.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../account/screen/banking/payments.dart';
import '../../../../account/screen/customers/customers.dart';
import '../../../../account/screen/products/products.dart';
import '../../../../account/screen/purchase/purchase.dart';
import '../../../../account/screen/sales/sales.dart';
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
              onTap: () => Get.to(() => Products2()),
              leading: Icon(TIcons.products, size: 25),
              title: Text('Products', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('List of products', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const Customers()),
              leading: Icon(TIcons.customers, size: 25),
              title: Text('Customers', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('List of customers', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const Sales()),
              leading: Icon(TIcons.sales, size: 20),
              title: Text('Sales', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('List of sales', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const Purchase()),
              leading: Icon(TIcons.purchase, size: 20),
              title: Text('Purchase', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('List of purchase', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const Payments()),
              leading: Icon(Icons.money,size: 20),
              title: Text('Payments', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('All Payments list', style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        )
    );
  }
}
