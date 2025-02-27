import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/customers/customers_repositories.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../personalization/models/address_model.dart';
import '../../../personalization/models/user_model.dart';

class AddVendorController extends GetxController {
  final companyController = TextEditingController();
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

  final mongoCustomersRepo = Get.put(MongoCustomersRepo());

  void saveVendor() {
      AddressModel address = AddressModel();
      address.phone = phoneController.text;
      address.email = emailController.text;
      address.address1 = address1Controller.text;
      address.address2 = address2Controller.text;
      address.company = companyController.text;
      address.city = cityController.text;
      address.state = stateController.text;
      address.pincode = pincodeController.text;
      address.country = countryController.text;

      CustomerModel vendor = CustomerModel();
      vendor.company = companyController.text;
      vendor.gstNumber = gstNumberController.text;
      vendor.email = emailController.text;
      vendor.billing = address;
      vendor.dateCreated = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      uploadVendor(customer: vendor);
  }

  // Upload vendor
  Future<void> uploadVendor({required CustomerModel customer}) async {
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

      await mongoCustomersRepo.pushCustomers(customers: [customer]); // Use batch insert function
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