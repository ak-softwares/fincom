import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../../../../common/dialog_box/dialog_massage.dart';
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
  RxInt paymentId = 0.obs;

  RxList<PaymentMethodModel> paymentMethods = <PaymentMethodModel>[].obs;

  final paymentMethodName = TextEditingController();
  final openingBalance = TextEditingController();

  GlobalKey<FormState> paymentFormKey = GlobalKey<FormState>();
  final mongoPaymentMethodsRepo = Get.put(MongoPaymentMethodsRepo());

  @override
  Future<void> onInit() async {
    super.onInit();
    paymentId.value = await mongoPaymentMethodsRepo.fetchPaymentGetNextId();
  }

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
      paymentId: paymentId.value,
      openingBalance: double.tryParse(openingBalance.text) ?? 0.0, // Convert string to double safely
      paymentMethodName: paymentMethodName.text,
      dateCreated: DateTime.now(), // Keep it as DateTime
    );

    addPayment(paymentMethod: paymentMethod);
  }

  // Upload vendor
  Future<void> addPayment({required PaymentMethodModel paymentMethod}) async {
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
      final fetchedPaymentId = await mongoPaymentMethodsRepo.fetchPaymentGetNextId();
      if(fetchedPaymentId != paymentId.value) {
        throw 'vendor id is same';
      }
      await mongoPaymentMethodsRepo.pushPaymentMethod(paymentMethod: paymentMethod); // Use batch insert function
      clearPayment();
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Vendor uploaded successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> clearPayment() async {
    paymentId.value = await mongoPaymentMethodsRepo.fetchPaymentGetNextId();
    paymentMethodName.text = '';
    openingBalance.text = '';
  }

  // Update vendor
  void resetValue(PaymentMethodModel payment) {
    paymentId.value = payment.paymentId ?? 0;
    paymentMethodName.text = payment.paymentMethodName ?? '';
    openingBalance.text = payment.openingBalance.toString();
  }

  void saveUpdatedPayment({required PaymentMethodModel previousPayment}) {
    PaymentMethodModel payment = PaymentMethodModel(
      id: previousPayment.id,
      paymentId: previousPayment.paymentId,
      openingBalance: double.tryParse(openingBalance.text) ?? 0.0, // Convert string to double safely
      balance: previousPayment.balance, // Convert string to double safely
      paymentMethodName: paymentMethodName.text,
      dateCreated: previousPayment.dateCreated, // Keep it as DateTime
    );

    updatePayment(payment: payment);
  }

  Future<void> updatePayment({required PaymentMethodModel payment}) async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are updating payment..', Images.docerAnimation);
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
      await mongoPaymentMethodsRepo.updatePayment(id: payment.id ?? '', payment: payment); // Use batch insert function
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Payment updated successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Get payment by id
  Future<PaymentMethodModel> getPaymentByID({required String id}) async {
    try {
      final fetchedPayment = await mongoPaymentMethodsRepo.fetchPaymentById(id: id);
      return fetchedPayment;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in payment getting', message: e.toString());
      return PaymentMethodModel();
    }
  }

  // Delete Payment
  Future<void> deletePayment ({required String id, required BuildContext context}) async {
    try {
      DialogHelper.showDialog(
          context: context,
          title: 'Delete Payment',
          message: 'Are you sure to delete this Payment',
          function: () async { await mongoPaymentMethodsRepo.deletePayment(id: id); },
          toastMessage: 'Deleted successfully!'
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}