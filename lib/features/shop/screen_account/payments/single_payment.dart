import 'package:fincom/features/shop/models/vendor_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../personalization/models/address_model.dart';
import '../../../personalization/screens/user_address/address_widgets/single_address.dart';
import '../../controller_account/payment/payment_controller.dart';
import '../../controller_account/vendor/vendor_controller.dart';
import '../../models/payment_method.dart';
import '../transacton/widget/transactions_by_entity.dart';
import '../vendor/single_vendor.dart';
import 'add_payment.dart';

class SinglePayment extends StatefulWidget {
  const SinglePayment({super.key, required this.payment});

  final PaymentMethodModel payment;

  @override
  State<SinglePayment> createState() => _SinglePaymentState();
}

class _SinglePaymentState extends State<SinglePayment> {
  late PaymentMethodModel payment;
  final paymentController = Get.put(PaymentMethodController());

  @override
  void initState() {
    super.initState();
    payment = widget.payment; // Initialize with the passed purchase
  }

  Future<void> _refreshPayment() async {
    final updatedPayment = await paymentController.getPaymentByID(id: payment.id ?? '');
    setState(() {
      payment = updatedPayment; // Update the purchase data
    });
  }

  @override
  Widget build(BuildContext context) {
    const double paymentTileHeight = Sizes.paymentTileHeight;
    const double paymentTileWidth = Sizes.paymentTileWidth;
    const double paymentTileRadius = Sizes.paymentTileRadius;
    const double paymentImageHeight = Sizes.paymentImageHeight;
    const double paymentImageWidth = Sizes.paymentImageWidth;

    return Scaffold(
        appBar: AppAppBar2(
          titleText: payment.paymentMethodName ?? 'Payment',
          widget: TextButton(
              onPressed: () => Get.to(() => AddPayments(payment: payment)),
              child: Text('Edit', style: TextStyle(color: TColors.linkColor),)
          )
        ),
      body: RefreshIndicator(
        color: TColors.refreshIndicator,
        onRefresh: () async => _refreshPayment(),
        child: ListView(
          padding: TSpacingStyle.defaultPagePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Container(
                width: paymentTileWidth,
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(paymentTileRadius),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payment Id'),
                        Text('#${payment.paymentId.toString()}', style: TextStyle(fontSize: 14))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payment Method'),
                        Text(payment.paymentMethodName ?? '', style: TextStyle(fontSize: 14))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Opening Balance'),
                        Text(payment.openingBalance.toString(), style: TextStyle(fontSize: 14))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Balance'),
                        AmountText(amount: payment.balance ?? 0.0)
                      ],
                    ),
                  ],
                )
            ),

            // Transaction
            SizedBox(height: Sizes.spaceBtwItems),
            Heading(title: 'Transaction'),
            SizedBox(height: Sizes.spaceBtwItems),
            SizedBox(
                height: 350,
                child: TransactionsByEntity(entityType: EntityType.payment, entityId: payment.paymentId ?? 0)
            ),

            // Delete
            Center(child: TextButton(
                onPressed: () => paymentController.deletePayment(context: context, id: payment.id ?? ''),
                child: Text('Delete', style: TextStyle(color: Colors.red),))
            )
          ],
        ),
      ),
    );
  }
}
