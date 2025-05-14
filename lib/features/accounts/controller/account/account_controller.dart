import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/dialog_massage.dart';
import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/accounts/mongo_account_repo.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../models/payment_method.dart';

class AccountsController extends GetxController {

  // Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxInt accountId = 0.obs;

  RxList<AccountModel> accounts = <AccountModel>[].obs;

  final accountsName = TextEditingController();
  final openingBalance = TextEditingController();

  GlobalKey<FormState> accountsFormKey = GlobalKey<FormState>();
  final mongoAccountsRepo = Get.put(MongoAccountsRepo());

  @override
  Future<void> onInit() async {
    super.onInit();
    accountId.value = await mongoAccountsRepo.fetchAccountGetNextId();
  }

  // Get All products
  Future<void> getAllPaymentMethods() async {
    try {
      final fetchedPayments = await mongoAccountsRepo.fetchAllAccountsMethod(page: currentPage.value);
      accounts.addAll(fetchedPayments);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refreshPaymentMethods() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      accounts.clear(); // Clear existing orders
      await getAllPaymentMethods();
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in Payment Methods getting', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Save
  void savePaymentMethods() {
    AccountModel paymentMethod = AccountModel(
      accountId: accountId.value,
      openingBalance: double.tryParse(openingBalance.text) ?? 0.0, // Convert string to double safely
      accountName: accountsName.text,
      dateCreated: DateTime.now(), // Keep it as DateTime
    );

    addPayment(paymentMethod: paymentMethod);
  }

  // Upload vendor
  Future<void> addPayment({required AccountModel paymentMethod}) async {
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog('We are updating your Address..', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!accountsFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }
      final fetchedPaymentId = await mongoAccountsRepo.fetchAccountGetNextId();
      if(fetchedPaymentId != accountId.value) {
        throw 'vendor id is same';
      }
      await mongoAccountsRepo.pushAccountsMethod(paymentMethod: paymentMethod); // Use batch insert function
      clearPayment();
      FullScreenLoader.stopLoading();
      AppMassages.showToastMessage(message: 'Vendor uploaded successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      //remove Loader
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> clearPayment() async {
    accountId.value = await mongoAccountsRepo.fetchAccountGetNextId();
    accountsName.text = '';
    openingBalance.text = '';
  }

  // Update vendor
  void resetValue(AccountModel payment) {
    accountId.value = payment.accountId ?? 0;
    accountsName.text = payment.accountName ?? '';
    openingBalance.text = payment.openingBalance.toString();
  }

  void saveUpdatedPayment({required AccountModel previousPayment}) {
    AccountModel payment = AccountModel(
      id: previousPayment.id,
      accountId: previousPayment.accountId,
      openingBalance: double.tryParse(openingBalance.text) ?? 0.0, // Convert string to double safely
      balance: previousPayment.balance, // Convert string to double safely
      accountName: accountsName.text,
      dateCreated: previousPayment.dateCreated, // Keep it as DateTime
    );

    updatePayment(payment: payment);
  }

  Future<void> updatePayment({required AccountModel payment}) async {
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog('We are updating payment..', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!accountsFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }
      await mongoAccountsRepo.updateAccount(id: payment.id ?? '', payment: payment); // Use batch insert function
      FullScreenLoader.stopLoading();
      AppMassages.showToastMessage(message: 'Payment updated successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      //remove Loader
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Get payment by id
  Future<AccountModel> getPaymentByID({required String id}) async {
    try {
      final fetchedPayment = await mongoAccountsRepo.fetchAccountById(id: id);
      return fetchedPayment;
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in payment getting', message: e.toString());
      return AccountModel();
    }
  }

  // Delete Payment
  Future<void> deletePayment ({required String id, required BuildContext context}) async {
    try {
      DialogHelper.showDialog(
          context: context,
          title: 'Delete Payment',
          message: 'Are you sure to delete this Payment',
          onSubmit: () async { await mongoAccountsRepo.deleteAccount(id: id); },
          toastMessage: 'Deleted successfully!'
      );
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<double> getTotalStockValue() async {
    try {
      final double totalStockValue = await mongoAccountsRepo.fetchTotalBalance();
      return totalStockValue;
    } catch (e) {
      rethrow;
    }
  }

}