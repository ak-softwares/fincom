import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/icons.dart';
import '../../../../shop/screen_account/customers/customers_voucher.dart';
import '../../../../shop/screen_account/payments/payments.dart';
import '../../../../shop/screen_account/products/products_voucher.dart';
import '../../../../shop/screen_account/purchase/purchase.dart';
import '../../../../shop/screen_account/purchase_list/purchase_list.dart';
import '../../../../shop/screen_account/sales/sales.dart';
import '../../../../shop/screen_account/transacton/transactions.dart';
import '../../../../shop/screen_account/vendor/vendor.dart';

class Menu extends StatelessWidget {
  const Menu({
    super.key, this.showHeading = true,
  });

  final bool showHeading;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ListTile(
          onTap: () => Get.to(() => ProductsVoucher()),
          leading: Icon(TIcons.products, size: 25),
          title: Text('Products'),
          subtitle: Text('List of products'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => const CustomersVoucher()),
          leading: Icon(TIcons.customers, size: 25),
          title: Text('Customers',),
          subtitle: Text('List of customers',),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => const SalesVoucher()),
          leading: Icon(TIcons.sales, size: 20),
          title: Text('Sales'),
          subtitle: Text('List of sales'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => const Purchase()),
          leading: Icon(TIcons.purchase, size: 20),
          title: Text('Purchase'),
          subtitle: Text('List of purchase'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => const Payments()),
          leading: Icon(Icons.money,size: 20),
          title: Text('Payments'),
          subtitle: Text('All Payments list'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => const Transactions()),
          leading: Icon(Icons.list_alt,size: 20),
          title: Text('Transactions'),
          subtitle: Text('All Transactions list'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => const Vendors()),
          leading: Icon(TIcons.customers,size: 20),
          title: Text('Vendors'),
          subtitle: Text('All Vendors list'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => const PurchaseList()),
          leading: Icon(TIcons.products, size: 20),
          title: Text('Purchase Item List'),
          subtitle: Text('Purchase Item List'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
      ],
    );
  }
}
