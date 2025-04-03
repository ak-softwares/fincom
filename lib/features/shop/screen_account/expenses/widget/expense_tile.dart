import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/shadows.dart';
import '../../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../models/expense_model.dart';
import '../single_expense.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.expense,
    this.onTap,
    this.showBorder = true,
  });

  final ExpenseModel expense;
  final VoidCallback? onTap;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    const double expenseTileHeight = AppSizes.expenseTileHeight;
    const double expenseTileWidth = AppSizes.expenseTileWidth;
    const double expenseTileRadius = AppSizes.expenseTileRadius;
    const double expenseImageHeight = AppSizes.expenseImageHeight;
    const double expenseImageWidth = AppSizes.expenseImageWidth;

    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return GestureDetector(
      onTap: onTap ?? () => Get.to(() => SingleExpenseScreen(expense: expense)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(expenseTileRadius),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row - Title and Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Expanded(
                  child: Text(
                    expense.title ?? 'No Title',
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Amount (highlighted)
                Text(
                  currencyFormat.format(expense.amount ?? 0),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceBtwItems / 2),

            // Second Row - Category and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category with icon
                Row(
                  children: [
                    Icon(Icons.category_outlined,
                        size: 16,
                        color: dark ? AppColors.light : AppColors.darkGrey),
                    const SizedBox(width: AppSizes.sm / 2),
                    Text(
                      expense.category ?? 'Uncategorized',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),

                // Date
                Text(
                  expense.date != null
                      ? DateFormat('MMM dd').format(expense.date!)
                      : 'No date',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spaceBtwItems / 2),

            // Third Row - Payment Method (if available)
            if (expense.paymentMethod?.isNotEmpty ?? false)
              Row(
                children: [
                  Icon(Icons.credit_card,
                      size: 16,
                      color: dark ? AppColors.light : AppColors.darkGrey),
                  const SizedBox(width: AppSizes.sm / 2),
                  Text(
                    expense.paymentMethod!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}