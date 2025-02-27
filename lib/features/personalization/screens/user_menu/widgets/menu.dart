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
import '../../../../shop/screen_account/banking/payments.dart';
import '../../../../shop/screen_account/customers/customers_voucher.dart';
import '../../../../shop/screen_account/products/products_voucher.dart';
import '../../../../shop/screen_account/purchase/purchase.dart';
import '../../../../shop/screen_account/purchase_list/purchase_list.dart';
import '../../../../shop/screen_account/sales/sales.dart';
import '../../../../shop/screen_account/vendor/vendor_voucher.dart';
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
              onTap: () => Get.to(() => ProductsVoucher()),
              leading: Icon(TIcons.products, size: 25),
              title: Text('Products', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('List of products', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const CustomersVoucher()),
              leading: Icon(TIcons.customers, size: 25),
              title: Text('Customers', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('List of customers', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const SalesVoucher()),
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
            ListTile(
              onTap: () => Get.to(() => const VendorVoucher()),
              leading: Icon(TIcons.customers,size: 20),
              title: Text('Vendors', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('All Vendors list', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const PurchaseList()),
              leading: Icon(TIcons.products, size: 20),
              title: Text('Purchase Item List', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text('Purchase Item List', style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        )
    );
  }
}
