import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/payment/mongo_payment_methods_repo.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../models/payment_method.dart';

class PaymentMethodController extends GetxController {

  // Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  RxList<PaymentMethodModel> paymentMethods = <PaymentMethodModel>[].obs;

  final openingBalance = TextEditingController();
  final paymentMethodName = TextEditingController();

  GlobalKey<FormState> paymentFormKey = GlobalKey<FormState>();
  final mongoPaymentMethodsRepo = Get.put(MongoPaymentMethodsRepo());


  // Get All products
  Future<void> getAllPaymentMethods() async {
    try {
      final fetchedPayments = await mongoPaymentMethodsRepo.fetchAllPaymentMethod(page: currentPage.value);
      paymentMethods.addAll(fetchedPayments);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refreshPaymentMethods() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      paymentMethods.clear(); // Clear existing orders
      await getAllPaymentMethods();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Payment Methods getting', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Save
  void savePaymentMethods() {
    PaymentMethodModel paymentMethod = PaymentMethodModel(
      openingBalance: double.tryParse(openingBalance.text) ?? 0.0, // Convert string to double safely
      paymentMethodName: paymentMethodName.text,
      dateCreated: DateTime.now(), // Keep it as DateTime
    );

    uploadPayment(paymentMethod: paymentMethod);
  }

  // Upload vendor
  Future<void> uploadPayment({required PaymentMethodModel paymentMethod}) async {
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
      if (!paymentFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await mongoPaymentMethodsRepo.pushPaymentMethod(paymentMethod: paymentMethod); // Use batch insert function
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