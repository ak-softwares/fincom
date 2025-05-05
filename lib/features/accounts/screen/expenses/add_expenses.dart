import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller/expenses/expenses_controller.dart';
import '../../models/expense_model.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key, this.expense});

  final ExpenseModel? expense;

  @override
  Widget build(BuildContext context) {
    final ExpenseController controller = Get.put(ExpenseController());
    final theme = Theme.of(context);

    if (expense != null) {
      controller.prefillExpenseForm(expense!);
    }

    return Scaffold(
      appBar: AppAppBar(
        title: expense != null ? 'Update Expense' : 'Add New Expense',
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Form(
            key: controller.expenseFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expense ID (readonly)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Expense ID', style: theme.textTheme.bodyLarge),
                    expense != null
                        ? Text('#${expense!.expenseId}',
                        style: theme.textTheme.bodyLarge)
                        : Obx(() => Text('#${controller.expenseId.value}',
                        style: theme.textTheme.bodyLarge)),
                  ],
                ),
                const SizedBox(height: AppSizes.spaceBtwSection),

                // Expense Title
                TextFormField(
                  controller: controller.expenseTitle,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'What was this expense for?',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a title'
                      : null,
                ),
                const SizedBox(height: AppSizes.inputFieldSpace),

                // Amount
                TextFormField(
                  controller: controller.amount,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.inputFieldSpace),

                // Category
                TextFormField(
                  controller: controller.category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'e.g. Food, Transportation, Utilities',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select a category'
                      : null,
                ),
                const SizedBox(height: AppSizes.inputFieldSpace),

                // Payment Method
                TextFormField(
                  controller: controller.paymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                    hintText: 'How did you pay?',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSizes.inputFieldSpace),

                // Date
                TextFormField(
                  controller: controller.date,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      controller.date.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                ),
                const SizedBox(height: AppSizes.inputFieldSpace),

                // Description
                TextFormField(
                  controller: controller.description,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSizes.spaceBtwSection),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () => expense != null
              ? controller.prepareUpdatedExpense(previousExpense: expense!)
              : controller.prepareExpense(),
          child: Text(
            expense != null ? 'Update Expense' : 'Add Expense',
            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}