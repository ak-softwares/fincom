import 'package:fincom/features/accounts/models/transaction_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../utils/constants/db_constants.dart';
import '../../../utils/constants/enums.dart';
import 'payment_method.dart';

class ExpenseModel {
  final String? id;
  final int? expenseId;
  final ExpenseType? expenseType;
  final double? amount;
  final String? description;
  final AccountModel? account;
  final DateTime? dateCreated;
  TransactionModel? transaction;

  ExpenseModel({
    this.id,
    this.expenseId,
    this.amount,
    this.description,
    this.expenseType,
    this.account,
    this.dateCreated,
    this.transaction,
  });


  // Factory constructor to create model from JSON
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json[ExpenseFieldName.id] is ObjectId
          ? (json[ExpenseFieldName.id] as ObjectId).toHexString()
          : json[ExpenseFieldName.id]?.toString(),
      expenseId: json[ExpenseFieldName.expenseId] as int?,
      amount: json[ExpenseFieldName.amount] != null ? double.tryParse(json[ExpenseFieldName.amount].toString()) : null,
      description: json[ExpenseFieldName.description] as String?,
      expenseType: ExpenseTypeExtension.fromString(json[ExpenseFieldName.expenseType] ?? ''),
      account: json[ExpenseFieldName.account] != null
          ? AccountModel.fromJson(json[ExpenseFieldName.account])
          : AccountModel(),
      dateCreated: json[ExpenseFieldName.dateCreated],
      transaction: json[ExpenseFieldName.transaction] != null
          ? TransactionModel.fromJson(json[ExpenseFieldName.transaction])
          : TransactionModel(),
    );
  }

  // Convert model to JSON for database insertion
  Map<String, dynamic> toJson() {
    return {
      ExpenseFieldName.id: id,
      ExpenseFieldName.expenseId: expenseId,
      ExpenseFieldName.amount: amount,
      ExpenseFieldName.description: description,
      ExpenseFieldName.expenseType: expenseType?.name,
      ExpenseFieldName.account: account?.toMap(),
      ExpenseFieldName.dateCreated: dateCreated,
      ExpenseFieldName.transaction: transaction?.toMap(),
    };
  }

  /// Convert TransactionModel to a Map (alias for toJson)
  Map<String, dynamic> toMap() => toJson();

}

class ExpenseSummary {
  final String name;
  final int total;
  final double percent;

  ExpenseSummary({
    required this.name,
    required this.total,
    required this.percent,
  });
}
