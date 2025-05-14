import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/expanses/expanses_repo.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../models/expense_model.dart';
import '../../models/payment_method.dart';
import '../../models/transaction_model.dart';
import '../transaction/transaction_controller.dart';
import 'expenses_controller.dart';

class AddExpenseController extends GetxController {

  RxInt expenseId = 0.obs;

  // Form controllers
  final amount = TextEditingController();
  ExpenseType? selectedExpenseType;
  Rx<AccountModel> selectedAccountType = AccountModel().obs;
  final date = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  GlobalKey<FormState> expenseFormKey = GlobalKey<FormState>();

  final expenseController = Get.put(ExpenseController());
  final mongoExpenseRepo = Get.put(MongoExpenseRepo());
  final transactionController = Get.put(TransactionController());

  @override
  Future<void> onInit() async {
    super.onInit();
    expenseId.value = await mongoExpenseRepo.fetchExpenseNextId();
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


  // Create new expense
  void prepareExpense() {
    ExpenseModel expense = ExpenseModel(
      expenseId: expenseId.value,
      amount: double.tryParse(amount.text) ?? 0.0,
      expenseType: selectedExpenseType,
      account: selectedAccountType.value,
      dateCreated: DateFormat('yyyy-MM-dd').parse(date.text),
    );

    TransactionModel transaction = TransactionModel(
      amount: double.tryParse(amount.text) ?? 0.0,
      date: DateFormat('yyyy-MM-dd').parse(date.text),
      fromEntityType: EntityType.account,
      fromEntityId: selectedAccountType.value.id,
      fromEntityName: selectedAccountType.value.accountName,
      transactionType: TransactionType.expense,
    );

    addExpense(expense: expense, transaction: transaction);
  }

  // Add expense to database
  Future<void> addExpense({required ExpenseModel expense, required TransactionModel transaction}) async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog('Saving your expense...', Images.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!expenseFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      final fetchedExpenseId = await mongoExpenseRepo.fetchExpenseNextId();
      if(fetchedExpenseId != expenseId.value) {
        throw 'Expense ID conflict detected';
      }

      final String? transactionId =  await transactionController.processTransaction(transaction: transaction);
      transaction.id = transactionId;
      expense.transaction = transaction;
      await mongoExpenseRepo.pushExpense(expense: expense);

      clearExpenseForm();
      FullScreenLoader.stopLoading();
      AppMassages.showToastMessage(message: 'Expense added successfully!');
      Navigator.of(Get.context!).pop();
      await expenseController.refreshExpenses();
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Pre-fill form for editing
  void prefillExpenseForm(ExpenseModel expense) {
    expenseId.value = expense.expenseId ?? 0;
    amount.text = expense.amount?.toString() ?? '0.0';
    selectedExpenseType = expense.expenseType;
    selectedAccountType.value = expense.account ?? AccountModel();
    date.text = expense.dateCreated != null
        ? DateFormat('yyyy-MM-dd').format(expense.dateCreated!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // Update expense
  void prepareUpdatedExpense({required ExpenseModel previousExpense}) {
    ExpenseModel expense = ExpenseModel(
      id: previousExpense.id,
      expenseId: previousExpense.expenseId,
      amount: double.tryParse(amount.text) ?? 0.0,
      expenseType: selectedExpenseType,
      account: previousExpense.account,
      transaction: previousExpense.transaction,
      dateCreated: DateFormat('yyyy-MM-dd').parse(date.text),
    );

    TransactionModel newTransaction = TransactionModel(
      amount: double.tryParse(amount.text) ?? 0.0,
      date: DateFormat('yyyy-MM-dd').parse(date.text),
      fromEntityType: EntityType.account,
      fromEntityId: selectedAccountType.value.id,
      fromEntityName: selectedAccountType.value.accountName,
      transactionType: TransactionType.expense,
    );

    updateExpense(expense: expense, newTransaction: newTransaction);
  }

  Future<void> updateExpense({required ExpenseModel expense, required TransactionModel newTransaction}) async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog('Updating expense...', Images.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!expenseFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      await transactionController.processUpdateTransaction(previousTransaction: expense.transaction ?? TransactionModel(), transaction: newTransaction);
      await mongoExpenseRepo.updateExpense(id: expense.id ?? '', expense: expense);

      FullScreenLoader.stopLoading();
      AppMassages.showToastMessage(message: 'Expense updated successfully!');
      Navigator.of(Get.context!).pop();
      await expenseController.refreshExpenses();
    } catch (e) {
      // Remove Loader
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }


  // Clear form
  Future<void> clearExpenseForm() async {
    expenseId.value = await mongoExpenseRepo.fetchExpenseNextId();
    amount.clear();
    date.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

}