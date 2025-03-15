import 'package:fincom/common/navigation_bar/appbar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/styles/spacing_style.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/validators/validation.dart';
import '../../controller_account/vendor/add_vendor_controller.dart';
class AddVendorPage extends StatelessWidget {

  const AddVendorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AddVendorController controller = Get.put(AddVendorController());

    return Scaffold(
      appBar: TAppBar2(titleText: 'Add New Vendor'),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: Sizes.sm),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: controller.vendorFormKey,
            child: Column(
              spacing: Sizes.spaceBtwItems,
              children: [
                TextFormField(
                  controller: controller.companyController,
                  validator: (value) => TValidator.validateEmptyText('Company Name', value),
                  decoration: InputDecoration(
                    labelText: 'Company Name*',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    labelText: 'Representative Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: controller.gstNumberController,
                  decoration: InputDecoration(
                    labelText: 'GST Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  controller: controller.phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: controller.address1Controller,
                  decoration: InputDecoration(
                    labelText: 'Address 1',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: controller.address2Controller,
                  decoration: InputDecoration(
                    labelText: 'Address 2',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: controller.cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: controller.stateController,
                  decoration: InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(),
                  ),
                ),
                TextFormField(
                  controller: controller.pincodeController,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: controller.countryController,
                  decoration: InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.saveVendor,
                    child: Text('Save Vendor', style: TextStyle(fontSize: 16)),
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
