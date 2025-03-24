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
  RxInt vendorId = 0.obs;

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

  @override
  Future<void> onInit() async {
    super.onInit();
    vendorId.value = await mongoVendorsRepo.fetchVendorGetNextId();
  }

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
      vendorId: vendorId.value,
      company: companyController.text,
      name: nameController.text,
      gstNumber: gstNumberController.text,
      email: emailController.text,
      phone: phoneController.text,
      billing: address,
      dateCreated: DateTime.now().toString(),
    );

    addVendor(vendor: vendor);
  }

  // add vendor
  Future<void> addVendor({required VendorModel vendor}) async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are adding vendor..', Images.docerAnimation);
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

      final fetchedVendorId = await mongoVendorsRepo.fetchVendorGetNextId();
      if(fetchedVendorId != vendorId.value) {
        throw 'vendor id is same';
      }

      await mongoVendorsRepo.pushVendor(vendor: vendor); // Use batch insert function
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Vendor added successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Update vendor
  void resetValue(VendorModel vendor) {
    vendorId.value = vendor.vendorId ?? 0;
    companyController.text = vendor.company ?? '';
    nameController.text = vendor.name ?? '';
    gstNumberController.text = vendor.gstNumber ?? '';
    phoneController.text = vendor.phone.toString();
    emailController.text = vendor.email ?? '';

    address1Controller.text = vendor.billing?.address1 ?? '';
    address2Controller.text = vendor.billing?.address2 ?? '';
    cityController.text = vendor.billing?.city ?? '';
    stateController.text = vendor.billing?.state ?? '';
    pincodeController.text = vendor.billing?.pincode ?? '';
    countryController.text = vendor.billing?.country ?? '';

  }

  void saveUpdatedVendor({required VendorModel previousVendor}) {
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
      id: previousVendor.id,
      vendorId: previousVendor.vendorId,
      company: companyController.text,
      name: nameController.text,
      gstNumber: gstNumberController.text,
      email: emailController.text,
      phone: phoneController.text,
      billing: address,
      dateCreated: previousVendor.dateCreated
    );

    updateVendor(vendor: vendor);
  }

  Future<void> updateVendor({required VendorModel vendor}) async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are updating Vendor..', Images.docerAnimation);
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

      await mongoVendorsRepo.updateVendor(id: vendor.id ?? '', vendor: vendor); // Use batch insert function
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Vendor updated successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}