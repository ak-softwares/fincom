import 'package:fincom/features/shop/models/vendor_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/vendors/vendors_repositories.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../personalization/models/address_model.dart';
import '../../../personalization/models/user_model.dart';

class AddVendorController extends GetxController {
  final companyController = TextEditingController();
  final nameController = TextEditingController();
  final gstNumberController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final countryController = TextEditingController();
  GlobalKey<FormState> vendorFormKey = GlobalKey<FormState>();

  final mongoVendorsRepo = Get.put(MongoVendorsRepo());

  void saveVendor() {
    AddressModel address = AddressModel(
      phone: phoneController.text,
      email: emailController.text,
      address1: address1Controller.text,
      address2: address2Controller.text,
      company: companyController.text,
      city: cityController.text,
      state: stateController.text,
      pincode: pincodeController.text,
      country: countryController.text,
    );

    VendorModel vendor = VendorModel(
      company: companyController.text,
      name: nameController.text,
      gstNumber: gstNumberController.text,
      email: emailController.text,
      billing: address,
      dateCreated: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    );

    uploadVendor(vendor: vendor);
  }


  // Upload vendor
  Future<void> uploadVendor({required VendorModel vendor}) async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are updating your Address..', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!vendorFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await mongoVendorsRepo.pushVendor(vendor: vendor); // Use batch insert function
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Vendor uploaded successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

}