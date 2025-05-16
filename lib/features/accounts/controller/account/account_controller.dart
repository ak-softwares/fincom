import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/dialog_massage.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../data/repositories/mongodb/accounts/mongo_account_repo.dart';
import '../../../authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../models/account_model.dart';

class AccountController extends GetxController {

  // Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  RxList<AccountModel> accounts = <AccountModel>[].obs;

  final mongoAccountsRepo = Get.put(MongoAccountsRepo());

  String get userId => AuthenticationController.instance.admin.value.id!;

  // Get All products
  Future<void> getAllPaymentMethods() async {
    try {
      final fetchedPayments = await mongoAccountsRepo.fetchAllAccountsMethod(userId: userId ,page: currentPage.value);
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

  Future<double> getTotalBalance() async {
    try {
      final double totalStockValue = await mongoAccountsRepo.fetchTotalBalance(userId: userId);
      return totalStockValue;
    } catch (e) {
      rethrow;
    }
  }

}