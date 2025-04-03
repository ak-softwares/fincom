import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../personalization/models/address_model.dart';
import '../../../personalization/models/user_model.dart';
import '../../../personalization/screens/user_address/address_widgets/single_address.dart';
import '../../controller_account/Customers_voucher/customers_voucher_controller.dart';
import '../transacton/widget/transactions_by_entity.dart';
import 'add_customer.dart';

class SingleCustomer extends StatefulWidget {
  const SingleCustomer({super.key, required this.customer});

  final CustomerModel customer;

  @override
  State<SingleCustomer> createState() => _SingleCustomerState();
}

class _SingleCustomerState extends State<SingleCustomer> {
  late CustomerModel customer;
  final customerController = Get.find<CustomersVoucherController>();

  @override
  void initState() {
    super.initState();
    customer = widget.customer;
  }

  Future<void> _refreshCustomer() async {
    final updatedCustomer = await customerController.getCustomerByID(id: customer.id ?? '');
    setState(() {
      customer = updatedCustomer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar2(
        titleText: customer.name ?? 'Customer',
        widget: TextButton(
          onPressed: () => Get.to(() => AddCustomer(customer: customer)),
          child: Text('Edit', style: TextStyle(color: AppColors.linkColor)),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.refreshIndicator,
        onRefresh: _refreshCustomer,
        child: ListView(
          padding: TSpacingStyle.defaultPagePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Customer ID'),
                Text('#${customer.customerId}', style: TextStyle(fontSize: 14))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Customer Name'),
                Text(customer.name ?? '', style: TextStyle(fontSize: 14))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Email'),
                Text(customer.email ?? '', style: TextStyle(fontSize: 14))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Phone'),
                Text(customer.phone ?? '', style: TextStyle(fontSize: 14))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Balance'),
                AmountText(amount: customer.balance ?? 0.0)
              ],
            ),
            Text('Address'),
            SizedBox(height: AppSizes.xs),
            TSingleAddress(
              address: customer.billing ?? AddressModel.empty(),
              onTap: () {},
              hideEdit: true,
            ),

            // Transaction
            SizedBox(height: AppSizes.spaceBtwItems),
            Heading(title: 'Transactions'),
            SizedBox(height: AppSizes.spaceBtwItems),
            SizedBox(
                height: 350,
                child: TransactionsByEntity(entityType: EntityType.customer, entityId: customer.customerId ?? 0)
            ),

            // Delete
            Center(child: TextButton(
              onPressed: () => customerController.deleteCustomer(context: context, id: customer.id ?? ''),
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ))
          ],
        ),
      ),
    );
  }
}

class AmountText extends StatelessWidget {
  const AmountText({super.key, required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Text(amount.toString(),
        style: TextStyle(
            fontSize: 14,
            color: amount < 0 ? Colors.red : Colors.green
        )
    );
  }
}
