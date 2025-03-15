import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller_account/payment/payment_controller.dart';

class AddPayments extends StatelessWidget {
  const AddPayments({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentMethodController controller = Get.put(PaymentMethodController());

    return Scaffold(
      appBar: TAppBar2(titleText: 'Add New Payment'),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.md, vertical: Sizes.sm),
        child: ElevatedButton(
          onPressed: controller.savePaymentMethods,
          child: Text('Add Payment Method', style: TextStyle(fontSize: 16)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: Sizes.sm),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: controller.paymentFormKey,
            child: Column(
              spacing: Sizes.spaceBtwItems,
              children: [
                TextFormField(
                  controller: controller.openingBalance,
                  decoration: InputDecoration(
                    labelText: 'Opening Balance',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: controller.paymentMethodName,
                  decoration: InputDecoration(
                    labelText: 'Payment Method Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}