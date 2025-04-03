import 'package:intl/intl.dart';

import '../../../utils/constants/db_constants.dart';

class ExpenseModel {
  final String? id;
  final int? expenseId;
  final String? title;
  final double? amount;
  final String? description;
  final String? category;
  final String? paymentMethod;
  final DateTime? date;
  final DateTime? dateCreated;

  ExpenseModel({
    this.id,
    this.expenseId,
    this.title,
    this.amount,
    this.description,
    this.category,
    this.paymentMethod,
    this.date,
    this.dateCreated,
  });

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      ExpenseFieldName.id: id,
      ExpenseFieldName.expenseId: expenseId,
      ExpenseFieldName.title: title,
      ExpenseFieldName.amount: amount,
      ExpenseFieldName.description: description,
      ExpenseFieldName.category: category,
      ExpenseFieldName.paymentMethod: paymentMethod,
      ExpenseFieldName.date: date != null ? DateFormat('yyyy-MM-dd').format(date!) : null,
      ExpenseFieldName.dateCreated: dateCreated != null ? DateFormat('yyyy-MM-dd').format(dateCreated!) : null,
    };
  }

  // Factory constructor to create model from JSON
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json[ExpenseFieldName.id]?.toString(),
      expenseId: json[ExpenseFieldName.expenseId] as int?,
      title: json[ExpenseFieldName.title] as String?,
      amount: json[ExpenseFieldName.amount] != null ? double.tryParse(json[ExpenseFieldName.amount].toString()) : null,
      description: json[ExpenseFieldName.description] as String?,
      category: json[ExpenseFieldName.category] as String?,
      paymentMethod: json[ExpenseFieldName.paymentMethod] as String?,
      date: json[ExpenseFieldName.date] != null ? DateFormat('yyyy-MM-dd').parse(json[ExpenseFieldName.date]) : null,
      dateCreated: json[ExpenseFieldName.dateCreated] != null ? DateFormat('yyyy-MM-dd').parse(json[ExpenseFieldName.dateCreated]) : null,
    );
  }

  /// Convert TransactionModel to a Map (alias for toJson)
  Map<String, dynamic> toMap() => toJson();

}