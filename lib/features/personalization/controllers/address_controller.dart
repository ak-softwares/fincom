import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/text/section_heading.dart';
import '../../../common/widgets/loaders/loader.dart';
import '../../../common/widgets/network_manager/network_manager.dart';
import '../../../data/repositories/firebase/address/address_repository.dart';
import '../../../data/repositories/woocommerce_repositories/customers/woo_customer_repository.dart';
import '../../../utils/constants/db_constants.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/data/state_iso_code_map.dart';
import '../../../utils/helpers/cloud_helper_function.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../shop/controllers/checkout_controller/checkout_controller.dart';
import '../models/address_model.dart';
import '../models/user_model.dart';
import '../screens/user_address/address_widgets/single_address.dart';
import 'customers_controller.dart';

class AddressController extends GetxController{
  static AddressController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final pincode = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final country = TextEditingController();
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();

  RxBool refreshData = true.obs;
  final Rx<AddressModel> selectedAddress = AddressModel.empty().obs;
  final userController = Get.put(CustomersController());
  final addressRepository = Get.put(AddressRepository());
  final wooCustomersRepository = Get.put(WooCustomersRepository());
  final checkoutController = Get.put(CheckoutController());


  Future<void> wooUpdateAddress(bool isShippingAddress) async {
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
      if (!addressFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if(isShippingAddress){
        //update single field user
        Map<String, dynamic> updateShippingField = {
          CustomerFieldName.shipping: {
            AddressFieldName.firstName: firstName.text.trim(),
            AddressFieldName.lastName: lastName.text.trim(),
            AddressFieldName.address1: address1.text.trim(),
            AddressFieldName.address2: address2.text.trim(),
            AddressFieldName.city: city.text.trim(),
            AddressFieldName.pincode: pincode.text.trim(),
            AddressFieldName.state: StateData.getISOFromState(state.text.trim()),
            AddressFieldName.country: CountryData.getISOFromCountry(country.text.trim()),
          },
        };
        final userId = Get.put(CustomersController()).customer.value.id.toString();
        final CustomerModel customer = await wooCustomersRepository.updateCustomerById(userID: userId, data: updateShippingField);
        userController.customer(customer);
      } else {
        //update single field user
        Map<String, dynamic> updateBillingField = {
          CustomerFieldName.billing: {
            AddressFieldName.firstName: firstName.text.trim(),
            AddressFieldName.lastName: lastName.text.trim(),
            AddressFieldName.address1: address1.text.trim(),
            AddressFieldName.address2: address2.text.trim(),
            AddressFieldName.city: city.text.trim(),
            AddressFieldName.pincode: pincode.text.trim(),
            AddressFieldName.state: StateData.getISOFromState(state.text.trim()),
            AddressFieldName.country: CountryData.getISOFromCountry(country.text.trim()),
          },
        };
        final userId = Get.put(CustomersController()).customer.value.id.toString();
        final CustomerModel customer = await wooCustomersRepository.updateCustomerById(userID: userId, data: updateBillingField);
        userController.customer(customer);
        checkoutController.updateCheckout();
      }
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Address updated successfully!');
      Navigator.of(Get.context!).pop();
    } catch (error) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: error.toString());
    }
  }

  // //Fetch all Addresses for specific user
  // Future<List<AddressModel>> getCustomerAddress() async {
  //   try{
  //     final addresses = await wooAddressRepository.fetchAddressCustomerId();
  //     return addresses;
  //   } catch (e) {
  //     TLoaders.errorSnackBar(title: 'Address not found', message: e.toString());
  //     return[];
  //   }
  // }

  //Fetch all Addresses for specific user
  Future<List<AddressModel>> getAllUserAddresses() async {
    try{
      final addresses = await addressRepository.fetchUserAddresses();
      selectedAddress.value = addresses.firstWhere((element) => element.selectedAddress ?? false, orElse: () => AddressModel.empty());
      return addresses;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Address not found', message: e.toString());
      return[];
    }
  }

  //Get single Address for specific user
  Future<AddressModel> getSelectedAddresses() async {
    try{
      final address = await addressRepository.fetchSelectedAddress();
      selectedAddress.value = address;
      return address;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Address not found', message: e.toString());
      return AddressModel.empty();
    }
  }

  //Get single Address for specific user
  Future<AddressModel> getSingleAddresses(String selectedAddressId) async {
    try{
      final address = await addressRepository.fetchSingleAddress(selectedAddressId);
      return address;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Address not found', message: e.toString());
      return AddressModel.empty();
    }
  }

  Future selectAddress(AddressModel newSelectedAddress) async {
    try{
      //clear the 'selected' field
      if(selectedAddress.value.id!.isNotEmpty){
        await addressRepository.updateSelectedField(selectedAddress.value.id ?? '', false);
      }
      //Assign selected address
      newSelectedAddress.selectedAddress = true;
      selectedAddress.value = newSelectedAddress;

      //set the 'Selected' field to true for the newly selected address
      await addressRepository.updateSelectedField(selectedAddress.value.id ?? '', true);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Selection', message: e.toString());
    }
  }

  Future addNewAddress() async {
    try{
      //Start Loading
      TFullScreenLoader.openLoadingDialog('Storing Address..', Images.docerAnimation);

      //Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Form validation
      if(!addressFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }
      //Save Address data
      final address = AddressModel(
        id: '',
        firstName: name.text.trim(),
        phone: phone.text.trim(),
        address1: address1.text.trim(),
        address2: address2.text.trim(),
        city: city.text.trim(),
        state: state.text.trim(),
        pincode: pincode.text.trim(),
        country: country.text.trim(),
        dateCreated: Timestamp.now().toDate(),
        selectedAddress: true,
      );
      final id = await addressRepository.addAddress(address);

      //update selected address status
      address.id = id;
      selectedAddress(address);

      //remove loader
      TFullScreenLoader.stopLoading();

      //Show Success message
      TLoaders.successSnackBar(title: 'Congratulation', message: 'Your address has been saved successfully.');

      //Refresh Addresses data
      refreshData.toggle();

      //Reset fields
      resetFormField();

      //redirect
      Navigator.of(Get.context!).pop();
    } catch(e) {
      //remove loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Address not found', message: e.toString());
    }
  }

  //function to reset form fields
  void resetFormField() {
    name.clear();
    phone.clear();
    address1.clear();
    address2.clear();
    pincode.clear();
    city.clear();
    state.clear();
    country.clear();
    addressFormKey.currentState?.reset();
  }

  //show address ModalBottomSheet at checkout
  Future<dynamic> selectNewAddressPopup(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(Sizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TSectionHeading(title: 'Select Address',
              onPressed: () {},
              seeActionButton: true,
              buttonTitle: 'Add new address',
            ),
            Expanded(
              child: FutureBuilder(
                future: getAllUserAddresses(),
                builder: (_, snapshot) {
                  //Helper function handle loader no record no error massage
                  final response = TCloudHelperFunction.checkMultiRecodeState(snapshot: snapshot);
                  if(response != null) return response;
                  final addresses = snapshot.data!;
                  return ListView.separated(
                      shrinkWrap: true,
                      itemCount: addresses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: Sizes.spaceBtwItems),
                      itemBuilder: (_, index) => TSingleAddress(
                          address: addresses[index],
                          onTap: () => selectAddress(addresses[index])
                      )
                  );
                }
              ),
            ),
            const SizedBox(height: Sizes.defaultSpace * 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Select Address'),
              ),
            )
          ],
        ),
      )
    );
  }
}