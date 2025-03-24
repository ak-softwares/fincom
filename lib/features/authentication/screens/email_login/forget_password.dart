import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/login_controller/forget_password_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final String? email;
  const ForgetPasswordScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('forget_password_screen');

    final controller = Get.put(ForgetPasswordController());
    if (email?.isNotEmpty == true) {
      controller.email.text = email!;
    }
    return Scaffold(
      appBar: const AppAppBar2(titleText: "Forget Password", showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWidthAppbarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //login, Title, Subtitle
              Column(
                children: [
                  Text('Forget password', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: Sizes.sm),
                  Text('Do not worry sometime people can forget too, Enter your email and we will send you password reset link',
                      style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center)
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
              //Form Field
              Form(
                key: controller.forgetPasswordFormKey,
                  child: Column(
                      children: [
                        //Email
                        TextFormField(
                            controller: controller.email,
                            validator: (value) => TValidator.validateEmail(value),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.direct_right),
                                labelText: TTexts.email
                            )
                        ),
                        // Forget password button
                        const SizedBox(height: Sizes.spaceBtwSections),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () => controller.sendPasswordResetEmail(controller.email.text.trim()),
                          ),
                        ),
                      ]
                  )
              ),
            ]
          ),
        ),
      ),
    );
  }
}
