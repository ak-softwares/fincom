import '../../../utils/constants/db_constants.dart';

class PaymentMethodModel {
  int? id;
  double? openingBalance;
  DateTime? dateCreated;
  String? paymentMethodName;

  PaymentMethodModel({
    this.id,
    this.openingBalance,
    this.dateCreated,
    this.paymentMethodName,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json[PaymentMethodFieldName.id] as int?,
      openingBalance: (json[PaymentMethodFieldName.openingBalance] as num?)?.toDouble(),
      dateCreated: json[PaymentMethodFieldName.dateCreated] != null
          ? DateTime.parse(json[PaymentMethodFieldName.dateCreated])
          : null,
      paymentMethodName: json[PaymentMethodFieldName.paymentMethodName] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      PaymentMethodFieldName.id: id,
      PaymentMethodFieldName.openingBalance: openingBalance,
      PaymentMethodFieldName.dateCreated: dateCreated?.toIso8601String(),
      PaymentMethodFieldName.paymentMethodName: paymentMethodName,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      PaymentMethodFieldName.id: id,
      PaymentMethodFieldName.openingBalance: openingBalance,
      PaymentMethodFieldName.dateCreated: dateCreated?.toIso8601String(),
      PaymentMethodFieldName.paymentMethodName: paymentMethodName,
    };
  }
}

