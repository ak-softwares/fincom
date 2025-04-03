import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../common/styles/spacing_style.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/navigation_helper.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/phone_otp_controller/phone_otp_controller.dart';
import '../email_login/email_login.dart';
import '../create_account/signup.dart';
import '../social_login/social_buttons.dart';

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('mobile_login_screen');
    final otpController = Get.put(OTPController());
    return Scaffold(
      // appBar: const TAppBar2(titleText: "Login", showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWidthAppbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 120,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //login, Title, Subtitle
                Column(
                  children: [
                    Text('Your Phone!', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: AppSizes.sm),
                    Text(TTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center)
                  ],
                ),
                const SizedBox(height: AppSizes.spaceBtwSection),

                //Form Field
                // PhoneFieldHint/TextField,
                // PhoneFieldHint(),
                // Phone number field with auto-fill
                IntlPhoneField(
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  validator: (value) => TValidator.validatePhoneNumber(value.toString()),
                  cursorColor: AppColors.primaryColor,
                  languageCode: "en",
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    otpController.countryCode.value = phone.countryCode; // +91
                    otpController.phoneNumber.value = phone.number;  // 8265849298
                  },
                  onCountryChanged: (country) {
                    otpController.countryCode.value = country.dialCode.toString();
                    // otpController.selectedCountry1.value = country.dialCode.toString();
                  },
                ),
                // TextField(
                //   keyboardType: TextInputType.phone,
                //   autofillHints: const [
                //     AutofillHints.telephoneNumber,
                //   ],
                //   controller: otpController.phone,
                //   // validator: (value) => TValidator.validatePhoneNumber(value),
                //   // cursorColor: TColors.primaryColor,
                //   decoration: InputDecoration(
                //       hintText: 'Enter Phone Number',
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //         borderSide: const BorderSide(color: Colors.black12),
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //         borderSide: const BorderSide(color: Colors.black12),
                //       ),
                //       prefixIcon: Padding(
                //         padding: const EdgeInsets.symmetric(vertical: 13, horizontal: TSizes.md),
                //         child: Obx(() => InkWell(
                //           onTap: () {
                //             showCountryPicker(
                //                 context: context,
                //                 countryListTheme: const CountryListThemeData(bottomSheetHeight: 600),
                //                 onSelect: (value) => otpController.selectedCountry.value = value
                //             );
                //           },
                //           child: Text('${otpController.selectedCountry.value.flagEmoji}  +${otpController.selectedCountry.value.phoneCode}',
                //               style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                //         )),
                //       )
                //   ),
                //
                // ),

                // Button Otp send
                const SizedBox(height: AppSizes.spaceBtwInputFields),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                        onPressed: () => otpController.fast2SmsSendOpt(phone: otpController.phoneNumber.value),
                        child: otpController.isLoading.value
                            ? const SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: AppColors.primaryBackground,))
                            : Text('Get OTP')
                    ),
                  ),
                ),

                //Not a Member?  Divider
                const SizedBox(height: AppSizes.spaceBtwSection),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[700],
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(TTexts.orContinueWith.capitalize!, style: Theme.of(context).textTheme.labelMedium),
                      ),
                      Expanded(child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[700],
                      )),
                    ],
                  ),
                ),

                //Social login
                const SizedBox(height: AppSizes.spaceBtwInputFields),
                const TSocialButtons(),

                //Continue with email and password
                const SizedBox(height: AppSizes.spaceBtwInputFields),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () => Get.to(() => const EmailLoginScreen()),
                      style: OutlinedButton.styleFrom(
                        alignment: Alignment.center,
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text('Login with Email and Password')
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
