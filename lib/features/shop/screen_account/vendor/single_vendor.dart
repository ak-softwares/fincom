import 'package:fincom/features/shop/models/vendor_model.dart';
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
import '../../../personalization/screens/user_address/address_widgets/single_address.dart';
import '../../controller_account/vendor/vendor_controller.dart';
import '../transacton/widget/transaction_simmer.dart';
import '../transacton/widget/transaction_tile.dart';
import '../transacton/widget/transactions_by_entity.dart';
import 'add_new_vendor.dart';

class SingleVendor extends StatefulWidget {
  const SingleVendor({super.key, required this.vendor});

  final VendorModel vendor;

  @override
  State<SingleVendor> createState() => _SingleVendorState();
}

class _SingleVendorState extends State<SingleVendor> {
  late VendorModel vendor;
  final vendorController = Get.find<VendorController>();

  @override
  void initState() {
    super.initState();
    vendor = widget.vendor; // Initialize with the passed purchase
  }

  Future<void> _refreshVendor() async {
    final updatedPurchase = await vendorController.getVendorByID(id: vendor.id ?? '');
    setState(() {
      vendor = updatedPurchase; // Update the purchase data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppAppBar2(
          titleText: vendor.company ?? 'Vendor',
          widget: TextButton(
              onPressed: () => Get.to(() => AddVendorPage(vendor: vendor)),
              child: Text('Edit', style: TextStyle(color: TColors.linkColor),)
          )
        ),
      body: RefreshIndicator(
        color: TColors.refreshIndicator,
        onRefresh: () async => _refreshVendor(),
        child: ListView(
          padding: TSpacingStyle.defaultPagePadding,
          physics: const AlwaysScrollableScrollPhysics(),
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
                Text('Opening Balance'),
                Text((vendor.openingBalance ?? 0).toString())
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Balance'),
                AmountText(amount: vendor.balance ?? 0.0)
              ],
            ),
            Text('Address'),
            SizedBox(height: Sizes.xs),
            TSingleAddress(
              address: vendor.billing ?? AddressModel.empty(),
              onTap: () {},
              hideEdit: true,
            ),

            // Transaction
            SizedBox(height: Sizes.spaceBtwItems),
            Heading(title: 'Transaction'),
            SizedBox(height: Sizes.spaceBtwItems),
            SizedBox(
              height: 350,
              child: TransactionsByEntity(entityType: EntityType.vendor, entityId: vendor.vendorId ?? 0)
            ),

            // Delete
            // SizedBox(height: 50),
            Center(child: TextButton(
                onPressed: () => vendorController.deletePurchase(context: context, id: vendor.id ?? ''),
                child: Text('Delete', style: TextStyle(color: Colors.red),))
            )
          ],
        ),
      ),
    );
  }
}

class AmountText extends StatelessWidget {
  const AmountText({
    super.key,
    required this.amount,
  });

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
