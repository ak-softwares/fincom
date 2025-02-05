import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../features/authentication/controllers/create_account_controller/signup_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class TTermsAndConditionsCheckBox extends StatelessWidget {
  const TTermsAndConditionsCheckBox({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    return Row(
      children: [
        SizedBox(width: 24, height: 24,
          child: Obx(() => Checkbox(
              value: controller.privacyPolicyChecked.value,
              onChanged: (value) => controller.privacyPolicyChecked.value = !controller.privacyPolicyChecked.value,
          )),
        ),
        const SizedBox(width: Sizes.spaceBtwItems),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'I agree to '),
              TextSpan(
                text: 'Privacy Policy',
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: TColors.linkColor,
                        decoration: TextDecoration.underline,
                        decorationColor: TColors.linkColor,
                        )
              ),
              const TextSpan(text: ' And '),
              TextSpan(
                  text: 'Terms of Use',
                  style: Theme.of(context).textTheme.bodyMedium!.apply(
                    color: TColors.linkColor,
                    decoration: TextDecoration.underline,
                    decorationColor: TColors.linkColor,
                  )
              )
            ]
          )
        )
      ],
    );
  }
}
