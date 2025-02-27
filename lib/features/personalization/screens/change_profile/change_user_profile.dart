import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/change_profile_controller.dart';
import '../../controllers/customers_controller.dart';


class ChangeUserProfile extends StatelessWidget {
  const ChangeUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('change_user_profile_screen');

    final changeProfileController = Get.put(ChangeProfileController());
    final userController = Get.put(CustomersController());
    changeProfileController.firstName.text = userController.customer.value.firstName ?? '';
    changeProfileController.lastName.text = userController.customer.value.lastName ?? '';
    changeProfileController.email.text = userController.customer.value.email ?? '';
    changeProfileController.phone.text = TValidator.getFormattedTenDigitNumber(userController.customer.value.phone) ?? '';

    return Scaffold(
      appBar: const TAppBar2(titleText: "Update Profile", showBackArrow: true),
      body: RefreshIndicator(
        color: TColors.refreshIndicator,
        onRefresh: () async => userController.refreshCustomer(),
        child: SingleChildScrollView(
          child: Padding(
            padding: TSpacingStyle.paddingWidthAppbarHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: changeProfileController.changeProfileFormKey,
                    child: Column(
                        children: [
                          const SizedBox(height: Sizes.spaceBtwSection),
                          //Name
                          Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                    controller: changeProfileController.firstName,
                                    validator: (value) => TValidator.validateEmptyText('First Name', value),
                                    decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'First Name*'),
                                  )
                              ),
                              const SizedBox(width: Sizes.spaceBtwInputFields),
                              //Pincode
                              Expanded(
                                  child: TextFormField(
                                      controller: changeProfileController.lastName,
                                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user4), labelText: 'Last name')
                                  )
                              ),
                            ],
                          ),
                          const SizedBox(height: Sizes.spaceBtwInputFields),
                          //email
                          TextFormField(
                              controller: changeProfileController.email,
                              validator: (value) => TValidator.validateEmail(value),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.direct_right),
                                labelText: TTexts.tEmail,
                              )
                          ),
                          const SizedBox(height: Sizes.spaceBtwInputFields),
                          // phone
                          TextFormField(
                              controller: changeProfileController.phone,
                              validator: (value) => TValidator.validatePhoneNumber(value),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.call),
                                labelText: TTexts.tPhone,
                              )
                          ),
                          const SizedBox(height: Sizes.spaceBtwSection),
                          // save button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: const Text('Update'),
                              onPressed: () => changeProfileController.wooChangeProfileDetails(),
                            ),
                          ),
                        ]
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

