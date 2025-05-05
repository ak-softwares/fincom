import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/login_controller/forget_password_controller.dart';
import 'email_login.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {

    int seconds  = 60;
    return Scaffold(
      appBar: const AppAppBar(title: "Reset Password Link"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.spaceBtwSection),
              Image(
                  image: const AssetImage(Images.deliveredEmailIllustration),
                  width: THelperFunctions.screenWidth(context) * 0.6,
              ),
              const SizedBox(height: AppSizes.spaceBtwSection),
              Text(email, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.spaceBtwItems),
              Text(AppTexts.confirmEmail, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.spaceBtwItems),
              Text(AppTexts.confirmEmailSubtitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.spaceBtwItems),
              //Buttons
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Get.to(() => const EmailLoginScreen()),
                      child: const Text(AppTexts.tContinue)
                  )
              ),
              const SizedBox(height: AppSizes.inputFieldSpace),
              Countdown(
                seconds: seconds,
                interval: const Duration(milliseconds: 1000),
                build: (context, currentRemainingTime) {
                  if(currentRemainingTime == 0.0) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Didn\'t receive Email?',
                            style: Theme.of(context).textTheme.bodyMedium),
                        TextButton(
                            onPressed: () {
                              currentRemainingTime = seconds.toDouble();
                              ForgetPasswordController.instance.sendPasswordResetEmail(email);
                            },
                            child: Text(AppTexts.resendEmail,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.linkColor))
                        ),
                      ],
                    );
                  } else {
                    return Text('Didn\'t receive Email? Resend in ${currentRemainingTime.toStringAsFixed(0)} Sec',
                        style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
