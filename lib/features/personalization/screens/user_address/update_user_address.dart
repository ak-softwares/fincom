import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/data/state_iso_code_map.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/address_controller.dart';
import '../../models/address_model.dart';
import '../change_profile/change_user_profile.dart';

class UpdateAddressScreen extends StatelessWidget {
  const UpdateAddressScreen({super.key, this.title = "Update Address", required this.address, this.isShippingAddress = false});

  final String title;
  final AddressModel address;
  final bool isShippingAddress;

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('update_user_address_screen');

    final addressController = Get.put(AddressController());

    addressController.firstName.text = address.firstName!;
    addressController.lastName.text = address.lastName!;
    addressController.address1.text = address.address1!;
    addressController.address2.text = address.address2!;
    addressController.city.text = address.city!;
    addressController.pincode.text = address.pincode!;
    addressController.state.text = address.state!;
    addressController.country.text = address.country!;

    return Scaffold(
      appBar: AppAppBar2(titleText: title, showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Form(
            key: addressController.addressFormKey,
            child: Column(
              children: [

                // Name
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                          controller: addressController.firstName,
                          validator: (value) => TValidator.validateEmptyText('First Name', value),
                          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'First Name*'),
                        )
                    ),
                    const SizedBox(width: Sizes.spaceBtwInputFields),
                    // Last Name
                    Expanded(
                        child: TextFormField(
                            controller: addressController.lastName,
                            decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user4), labelText: 'Last name')
                        )
                    ),
                  ],
                ),

                // Address1
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                    controller: addressController.address1,
                    validator: (value) => TValidator.validateEmptyText('Street address', value),
                    decoration: const InputDecoration(prefixIcon: Icon(Iconsax.building), labelText: 'Street Address*')
                ),

                // Address2
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                    controller: addressController.address2,
                    decoration: const InputDecoration(prefixIcon: Icon(Iconsax.buildings), labelText: 'Land Mark')
                ),

                // City
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                          controller: addressController.city,
                          validator: (value) => TValidator.validateEmptyText('City', value),
                          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.building), labelText: 'City*'),
                        )
                    ),
                    const SizedBox(width: Sizes.spaceBtwInputFields),
                    // Pincode
                    Expanded(
                        child: TextFormField(
                          controller: addressController.pincode,
                          validator: (value) => TValidator.validatePinCode(value),
                          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.code), labelText: 'Pincode*')
                        )
                    ),
                  ],
                ),

                // State
                const SizedBox(height: Sizes.spaceBtwInputFields),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  items: StateData.indianStates.map((state) {
                    return DropdownMenuItem<String>(
                      value: state,
                      child: Text(state),
                    );
                  }).toList(),
                  value: addressController.state.text.isNotEmpty ? addressController.state.text : null,
                  onChanged: (value) {addressController.state.text = value!;},
                  validator: (value) => TValidator.validateEmptyText('State', value),
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.activity), labelText: 'State*'),
                ),

                // Country
                const SizedBox(height: Sizes.spaceBtwInputFields),
                TextFormField(
                    enabled: false,
                    controller: addressController.country,
                    decoration: const InputDecoration(prefixIcon: Icon(Iconsax.buildings), labelText: 'Country*')
                ),
                // DropdownButtonFormField<String>(
                //   isExpanded: true,
                //   items: CountryData.countries.map((country) {
                //     return DropdownMenuItem<String>(
                //       value: country,
                //       child: Text(country),
                //     );
                //   }).toList(),
                //   value: controller.country.text,
                //   onChanged: (value) {controller.country.text = value!;},
                //   validator: (value) => TValidator.validateEmptyText('Country', value),
                //   decoration: const InputDecoration(prefixIcon: Icon(Iconsax.global), labelText: 'Country*'),
                // ),

                const SizedBox(height: Sizes.spaceBtwItems),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('To Edit Phone and Email', style: Theme.of(context).textTheme.labelLarge),
                      TextButton(
                          onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeUserProfile()));},
                          child: Text('Click here', style: Theme.of(context).textTheme.labelLarge!.copyWith(color: TColors.linkColor)))
                    ]
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () => addressController.wooUpdateAddress(isShippingAddress),
                        child: const Text('Update Address')
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
