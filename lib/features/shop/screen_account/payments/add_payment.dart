import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller_account/payment/payment_controller.dart';
import '../../models/payment_method.dart';

class AddPayments extends StatelessWidget {
  const AddPayments({super.key, this.payment});

  final PaymentMethodModel? payment;

  @override
  Widget build(BuildContext context) {
    final PaymentMethodController controller = Get.put(PaymentMethodController());

    if( payment != null) {
      controller.resetValue(payment!);
    }

    return Scaffold(
      appBar: AppAppBar2(titleText: payment != null ? 'Update Payment' : 'Add Payment'),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: Sizes.md, vertical: Sizes.sm),
        child: ElevatedButton(
          onPressed: () => payment != null ? controller.saveUpdatedPayment(previousPayment: payment!) : controller.savePaymentMethods(),
          child: Text(payment != null ? 'Update Payment' : 'Add Payment', style: TextStyle(fontSize: 16)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Payment id'),
                    payment != null
                        ? Text('#${payment!.paymentId}')
                        : Obx(() => Text('#${controller.paymentId.value}')),
                  ],
                ),
                TextFormField(
                  controller: controller.paymentMethodName,
                  decoration: InputDecoration(
                    labelText: 'Payment Method Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: controller.openingBalance,
                  decoration: InputDecoration(
                    labelText: 'Opening Balance',
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