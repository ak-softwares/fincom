import 'package:mongo_dart/mongo_dart.dart';

import '../../../utils/constants/db_constants.dart';

class PaymentMethodModel {
  String? id;
  int? paymentId;
  double? openingBalance;
  double? balance;
  DateTime? dateCreated;
  String? paymentMethodName;

  PaymentMethodModel({
    this.id,
    this.paymentId,
    this.openingBalance,
    this.balance,
    this.dateCreated,
    this.paymentMethodName,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json[PaymentMethodFieldName.id] is ObjectId
          ? (json[PaymentMethodFieldName.id] as ObjectId).toHexString() // Convert ObjectId to string
          : json[PaymentMethodFieldName.id]?.toString(), // Fallback to string if not ObjectId
      paymentId: json[PaymentMethodFieldName.paymentId],
      openingBalance: (json[PaymentMethodFieldName.openingBalance] as num?)?.toDouble(),
      balance: (json[PaymentMethodFieldName.balance] as num?)?.toDouble(),
      dateCreated: json[PaymentMethodFieldName.dateCreated] != null
          ? DateTime.parse(json[PaymentMethodFieldName.dateCreated])
          : null,
      paymentMethodName: json[PaymentMethodFieldName.paymentMethodName] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      PaymentMethodFieldName.paymentId: paymentId,
      PaymentMethodFieldName.openingBalance: openingBalance ?? 0.0,
      PaymentMethodFieldName.balance: balance ?? 0.0,
      PaymentMethodFieldName.dateCreated: dateCreated?.toIso8601String(),
      PaymentMethodFieldName.paymentMethodName: paymentMethodName,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      PaymentMethodFieldName.paymentId: paymentId,
      PaymentMethodFieldName.openingBalance: openingBalance,
      PaymentMethodFieldName.balance: balance,
      PaymentMethodFieldName.dateCreated: dateCreated?.toIso8601String(),
      PaymentMethodFieldName.paymentMethodName: paymentMethodName,
    };
  }
}

