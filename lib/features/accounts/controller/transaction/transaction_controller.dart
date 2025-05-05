import 'package:fincom/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/dialog_massage.dart';
import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/transaction/transaction_repo.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../personalization/models/user_model.dart';
import '../../models/payment_method.dart';
import '../../models/transaction_model.dart';

class TransactionController extends GetxController {
  // Variables
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxInt transactionId = 0.obs;

  RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  RxList<TransactionModel> transactionsByEntity = <TransactionModel>[].obs;

  Rx<UserModel> selectedVendor = UserModel().obs;
  Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel().obs;

  final amount = TextEditingController();
  final date = TextEditingController();

  GlobalKey<FormState> transactionFormKey = GlobalKey<FormState>();
  final mongoTransactionRepo = Get.put(MongoTransactionRepo());

  @override
  Future<void> onInit() async {
    super.onInit();
    date.text = DateTime.now().toIso8601String(); // Store in ISO format
    transactionId.value = await mongoTransactionRepo.fetchTransactionGetNextId();
  }

  void addVendor(UserModel getSelectedVendor) {
    selectedVendor.value = getSelectedVendor;
  }

  void selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      date.text = pickedDate.toIso8601String(); // Store as ISO format
      update(); // Ensure UI update
    }
  }

  // Fetch all transactions
  Future<void> getAllTransactions() async {
    try {
      final fetchedTransactions = await mongoTransactionRepo.fetchAllTransactions(page: currentPage.value);
      transactions.addAll(fetchedTransactions);
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      rethrow;
    }
  }

  Future<void> refreshTransactions() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      transactions.clear(); // Clear existing transactions
      await getAllTransactions();
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in Transactions getting', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Get All products
  Future<void> getTransactionByEntity({required EntityType entityType, required int entityId}) async {
    try {
      final fetchedTransactions = await mongoTransactionRepo.fetchTransactionByEntity(
          entityType: entityType,
          entityId: entityId,
          page: currentPage.value
      );
      transactionsByEntity.addAll(fetchedTransactions);
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in vendors transactions', message: e.toString());
    }
  }

  // Get All products
  Future<TransactionModel> getTransactionByPurchaseId({required int purchaseId}) async {
    try {
      final fetchedTransactions = await mongoTransactionRepo.findTransactionByPurchaseId(purchaseId: purchaseId);
      return fetchedTransactions;
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in purchase transactions', message: e.toString());
      return TransactionModel();
    }
  }

  Future<void> refreshTransactionByEntity({required EntityType entityType, required int entityId}) async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      transactionsByEntity.clear(); // Clear existing orders
      await getTransactionByEntity(entityType: entityType, entityId: entityId);
    } catch (e) {
      AppMassages.warningSnackBar(title: 'Errors', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Save new transaction
  void saveTransaction() {
    TransactionModel transaction = TransactionModel(
      transactionId: transactionId.value,
      amount: double.tryParse(amount.text) ?? 0.0,
      date: DateTime.tryParse(date.text) ?? DateTime.now(),
      fromEntityId: selectedPaymentMethod.value.paymentId, // Example vendor ID
      fromEntityName: selectedPaymentMethod.value.paymentMethodName, // Example vendor ID
      fromEntityType: EntityType.payment,
      toEntityId: selectedVendor.value.userId,
      toEntityName: selectedVendor.value.company,
      toEntityType: EntityType.vendor,
      transactionType: TransactionType.payment,
    );

    addTransaction(transaction: transaction);
  }

  // Upload transaction
  Future<void> addTransaction({required TransactionModel transaction}) async {
    try {
      FullScreenLoader.openLoadingDialog('Updating your transaction...', Images.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        throw 'Internet Not connected';
      }

      // Form Validation
      if (!transactionFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        throw 'Form is not valid';
      }

      await processTransaction(transaction: transaction);

      clearTransaction();

      FullScreenLoader.stopLoading();
      AppMassages.showToastMessage(message: 'Transaction uploaded successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      FullScreenLoader.stopLoading();
      debugPrint('Error adding transaction: $e');
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> processTransaction({
    required TransactionModel transaction,
    bool isDelete = false,
    bool isUpdated = false,
  }) async {
    try{
      List<Future<void>> futures = [];
      if (transaction.fromEntityType != null) {
        // Create update requests
        Future<void> updateFromEntity = mongoTransactionRepo.updateBalance(
          collectionName: transaction.fromEntityType?.dbName ?? '',
          entityBalancePair: {
            'entityIdFieldName': transaction.fromEntityType?.fieldName ?? '',
            'entityId': transaction.fromEntityId,
            'balance': transaction.amount,
          },
          isAddition: isDelete ? true : false, // Set to true for addition, false for subtraction
        );
        futures.add(updateFromEntity);
      }

      if (transaction.toEntityType != null) {
        // Create update requests
        Future<void> updateToEntity = mongoTransactionRepo.updateBalance(
          collectionName: transaction.toEntityType?.dbName ?? '',
          entityBalancePair: {
            'entityIdFieldName': transaction.toEntityType?.fieldName ?? '',
            'entityId': transaction.toEntityId,
            'balance': transaction.amount,
          },
          isAddition: isDelete ? false : true, // Set to true for addition, false for subtraction
        );
        futures.add(updateToEntity);
      }
      if(isDelete) {
        futures.add(mongoTransactionRepo.deleteTransaction(id: transaction.id ?? ''));
      }else if(isUpdated){
        futures.add(mongoTransactionRepo.pushTransaction(transaction: transaction));
      } else{
        // Fetch next transaction ID and check for conflicts
        final fetchedTransactionId = await mongoTransactionRepo.fetchTransactionGetNextId();
        transaction.transactionId ??= fetchedTransactionId;
        mongoTransactionRepo.pushTransaction(transaction: transaction);
      }
      
      await Future.wait(futures);

    } catch(e) {
      rethrow;
    }
  }

  Future<void> clearTransaction() async {
    transactionId.value = await mongoTransactionRepo.fetchTransactionGetNextId();
    amount.text = '';
    date.text = DateTime.now().toIso8601String();
  }

  // Reset fields before editing transaction
  void resetValue(TransactionModel transaction) {
    transactionId.value = transaction.transactionId ?? 0;
    amount.text = transaction.amount.toString();
    date.text = transaction.date?.toIso8601String() ?? '';
  }

  void saveUpdatedTransaction({required TransactionModel previousTransaction}) {

    TransactionModel transaction = TransactionModel(
      id: previousTransaction.id,
      transactionId: previousTransaction.transactionId,
      amount: double.tryParse(amount.text) ?? previousTransaction.amount,
      date: DateTime.tryParse(date.text) ?? previousTransaction.date,
      fromEntityId: selectedPaymentMethod.value.paymentId ?? previousTransaction.fromEntityId,
      fromEntityName: selectedPaymentMethod.value.paymentMethodName ?? previousTransaction.fromEntityName,
      fromEntityType: previousTransaction.fromEntityType,
      toEntityId: selectedVendor.value.userId ?? previousTransaction.toEntityId,
      toEntityName: selectedVendor.value.company ?? previousTransaction.toEntityName,
      toEntityType: previousTransaction.toEntityType,
      transactionType: previousTransaction.transactionType,
    );

    updateTransaction(transaction: transaction, previousTransaction: previousTransaction);
  }

  Future<void> updateTransaction({required TransactionModel transaction, required TransactionModel previousTransaction}) async {
    try {
      FullScreenLoader.openLoadingDialog('Updating transaction...', Images.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        throw 'Internet Not connected';
      }

      // Form Validation
      if (!transactionFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        throw 'Form is not valid';
      }

      processUpdateTransaction(transaction: transaction, previousTransaction: previousTransaction);

      FullScreenLoader.stopLoading();
      AppMassages.showToastMessage(message: 'Transaction updated successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      FullScreenLoader.stopLoading();
      debugPrint('Error updating transaction: $e');
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> processUpdateTransaction({required TransactionModel transaction, required TransactionModel previousTransaction}) async {
    try{
      List<Future<void>> futures = [];

      futures.add(processTransaction(transaction: previousTransaction, isDelete: true));
      futures.add(processTransaction(transaction: transaction, isUpdated: true));

      await Future.wait(futures);

    } catch(e) {
      rethrow;
    }
  }


  // Get transaction by ID
  Future<TransactionModel> getTransactionByID({required String id}) async {
    try {
      return await mongoTransactionRepo.fetchTransactionById(id: id);
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error fetching transaction', message: e.toString());
      return TransactionModel();
    }
  }

  Future<void> deleteTransactionByDialog({required TransactionModel transaction, required BuildContext context}) async {
    try {
      transaction.transactionType == TransactionType.purchase
      ? DialogHelper.showDialog(
        context: context,
        title: 'Error in Delete Transaction',
        message: 'You can not delete purchase transactions instead you can delete that purchase '
            'this transaction will delete automatically',
        onSubmit: () async { },
        actionButtonText: 'Done',
      )
      : DialogHelper.showDialog(
        context: context,
        title: 'Delete Transaction',
        message: 'Are you sure you want to delete this transaction?',
        onSubmit: () async {
          // Reverse balance updates
          await processTransaction(transaction: transaction, isDelete: true);
          Navigator.pop(context);
        },
        toastMessage: 'Deleted successfully!',
      );
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> deleteTransactionByPurchaseId({required int purchaseId}) async {
    try {
      final fetchedTransactions = await mongoTransactionRepo.findTransactionByPurchaseId(purchaseId: purchaseId);
      await processTransaction(transaction: fetchedTransactions, isDelete: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTransactionByPurchaseId({required int purchaseId, required TransactionModel transaction}) async {
    try {
      final previousTransactions = await mongoTransactionRepo.findTransactionByPurchaseId(purchaseId: purchaseId);
      transaction.transactionId = previousTransactions.transactionId;
      await processUpdateTransaction(transaction: transaction, previousTransaction: previousTransactions);
    } catch (e) {
      rethrow;
    }
  }

}
