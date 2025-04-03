import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../../../../common/dialog_box/dialog_massage.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/expanses/expanses_repo.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../models/expense_model.dart';

class ExpenseController extends GetxController {
  // Variables
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxInt expenseId = 0.obs;
  RxDouble totalMonthlyExpense = 0.0.obs;
  RxInt categoryCount = 0.obs;

  RxList<ExpenseModel> expenses = <ExpenseModel>[].obs;

  // Form controllers
  final expenseTitle = TextEditingController();
  final amount = TextEditingController();
  final description = TextEditingController();
  final category = TextEditingController();
  final paymentMethod = TextEditingController();
  final date = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  GlobalKey<FormState> expenseFormKey = GlobalKey<FormState>();
  final mongoExpenseRepo = Get.put(MongoExpenseRepo());

  @override
  Future<void> onInit() async {
    super.onInit();
    expenseId.value = await mongoExpenseRepo.fetchExpenseNextId();
    await calculateMonthlySummary();
  }

  // Calculate monthly summary
  Future<void> calculateMonthlySummary() async {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    final monthlyExpenses = expenses.where((expense) =>
    expense.date != null &&
        expense.date!.isAfter(firstDayOfMonth) &&
        expense.date!.isBefore(lastDayOfMonth)
    ).toList();

    totalMonthlyExpense.value = monthlyExpenses.fold(0, (sum, expense) => sum + (expense.amount ?? 0));

    final uniqueCategories = monthlyExpenses.map((e) => e.category).toSet();
    categoryCount.value = uniqueCategories.length;
  }

  // Get all expenses
  Future<void> getAllExpenses() async {
    try {
      final fetchedExpenses = await mongoExpenseRepo.fetchAllExpenses(page: currentPage.value);
      expenses.addAll(fetchedExpenses);
      await calculateMonthlySummary();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refreshExpenses() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      expenses.clear(); // Clear existing expenses
      await getAllExpenses();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error loading expenses', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  // Create new expense
  void prepareExpense() {
    ExpenseModel expense = ExpenseModel(
      expenseId: expenseId.value,
      title: expenseTitle.text,
      amount: double.tryParse(amount.text) ?? 0.0,
      description: description.text,
      category: category.text,
      paymentMethod: paymentMethod.text,
      date: DateFormat('yyyy-MM-dd').parse(date.text),
    );

    addExpense(expense: expense);
  }

  // Add expense to database
  Future<void> addExpense({required ExpenseModel expense}) async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('Saving your expense...', Images.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!expenseFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final fetchedExpenseId = await mongoExpenseRepo.fetchExpenseNextId();
      if(fetchedExpenseId != expenseId.value) {
        throw 'Expense ID conflict detected';
      }

      await mongoExpenseRepo.pushExpense(expense: expense);
      clearExpenseForm();
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Expense added successfully!');
      Navigator.of(Get.context!).pop();
      await refreshExpenses();
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Clear form
  Future<void> clearExpenseForm() async {
    expenseId.value = await mongoExpenseRepo.fetchExpenseNextId();
    expenseTitle.clear();
    amount.clear();
    description.clear();
    category.clear();
    paymentMethod.clear();
    date.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // Pre-fill form for editing
  void prefillExpenseForm(ExpenseModel expense) {
    expenseId.value = expense.expenseId ?? 0;
    expenseTitle.text = expense.title ?? '';
    amount.text = expense.amount?.toString() ?? '0.0';
    description.text = expense.description ?? '';
    category.text = expense.category ?? '';
    paymentMethod.text = expense.paymentMethod ?? '';
    date.text = expense.date != null
        ? DateFormat('yyyy-MM-dd').format(expense.date!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  // Update expense
  void prepareUpdatedExpense({required ExpenseModel previousExpense}) {
    ExpenseModel expense = ExpenseModel(
      id: previousExpense.id,
      expenseId: previousExpense.expenseId,
      title: expenseTitle.text,
      amount: double.tryParse(amount.text) ?? 0.0,
      description: description.text,
      category: category.text,
      paymentMethod: paymentMethod.text,
      date: DateFormat('yyyy-MM-dd').parse(date.text),
    );

    updateExpense(expense: expense);
  }

  Future<void> updateExpense({required ExpenseModel expense}) async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('Updating expense...', Images.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!expenseFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await mongoExpenseRepo.updateExpense(id: expense.id ?? '', expense: expense);
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Expense updated successfully!');
      Navigator.of(Get.context!).pop();
      await refreshExpenses();
    } catch (e) {
      // Remove Loader
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Get expense by ID
  Future<ExpenseModel> getExpenseById({required String id}) async {
    try {
      final fetchedExpense = await mongoExpenseRepo.fetchExpenseById(id: id);
      return fetchedExpense;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error loading expense', message: e.toString());
      return ExpenseModel();
    }
  }

  // Delete expense
  Future<void> deleteExpense({required String id, required BuildContext context}) async {
    try {
      DialogHelper.showDialog(
          context: context,
          title: 'Delete Expense',
          message: 'Are you sure you want to delete this expense record?',
          function: () async {
            await mongoExpenseRepo.deleteExpense(id: id);
            await refreshExpenses();
          },
          toastMessage: 'Expense deleted successfully!'
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}