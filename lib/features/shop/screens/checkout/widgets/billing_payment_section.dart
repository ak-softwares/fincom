import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/text/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/checkout_controller/checkout_controller.dart';
import '../../../controllers/checkout_controller/payment_controller.dart';
import '../../../models/payment_model.dart';

class TBillingPaymentSection extends StatelessWidget {
  const TBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());
    final checkoutController = CheckoutController.instance;

    // Set the default selected payment method
    checkoutController.selectedPaymentMethod.value = paymentController.getAllPaymentMethod.first;

    return Column(
      children: [
        const TSectionHeading(title: 'Payment Method'),
        Column(
          children: [
            for (var paymentMethod in paymentController.getAllPaymentMethod)
              buildPaymentOption(paymentMethod: paymentMethod)
          ],
        ),
      ],
    );
  }

  Widget buildPaymentOption({required PaymentModel paymentMethod}) {
    final checkoutController = CheckoutController.instance;

    final isCOD = paymentMethod.id == 'cod'; // Assuming 'COD' is the ID for the COD payment method.
    return Obx(() {
          // RxBool isCODDisabled = (isCOD && checkoutController.isCODDisabled.value).obs;

          return Opacity(
            opacity: checkoutController.isCODDisabled.value && isCOD ? 0.5 : 1.0,
            // Dim the option if it's disabled.
            child: InkWell(
              onTap: checkoutController.isCODDisabled.value && isCOD
                  ? null // Disable tap interaction if COD is blocked.
                  : () => checkoutController.updateSelectedPaymentOption(paymentMethod),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizes.sm),
                child: Obx(() => Row(
                      children: [
                        // Text(checkoutController.isCODDisabled.value.toString() ?? 'No blocked pincodes'),
                        Radio(
                          activeColor: TColors.info,
                          value: paymentMethod.id,
                          groupValue: checkoutController.selectedPaymentMethod.value.id,
                          onChanged: isCOD && checkoutController.isCODDisabled.value
                              ? null // Disable the radio button if COD is blocked.
                              : (String? newValue) {checkoutController.updateSelectedPaymentOption(paymentMethod);},
                        ),
                        SizedBox(
                          width: 250, // or specify a fixed width if needed
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (paymentMethod.image != null &&
                                  paymentMethod.image!.isNotEmpty)
                                Image(
                                  image: AssetImage(paymentMethod.image!),
                                  fit: BoxFit.contain,
                                  height: 25,
                                ),
                              Text(
                                !(isCOD && checkoutController.isCODDisabled.value)
                                    ? paymentMethod.description
                                    : "COD is unavailable for this ${checkoutController.codDisabledReason.value}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }
}
