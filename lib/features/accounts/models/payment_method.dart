import 'package:mongo_dart/mongo_dart.dart';

import '../../../utils/constants/db_constants.dart';

class AccountModel {
  String? id;
  int? accountId;
  double? openingBalance;
  double? balance;
  DateTime? dateCreated;
  String? accountName;

  AccountModel({
    this.id,
    this.accountId,
    this.openingBalance,
    this.balance,
    this.dateCreated,
    this.accountName,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json[AccountFieldName.id] is ObjectId
          ? (json[AccountFieldName.id] as ObjectId).toHexString() // Convert ObjectId to string
          : json[AccountFieldName.id]?.toString(), // Fallback to string if not ObjectId
      accountId: json[AccountFieldName.accountId],
      openingBalance: (json[AccountFieldName.openingBalance] as num?)?.toDouble(),
      balance: (json[AccountFieldName.balance] as num?)?.toDouble(),
      dateCreated: json[AccountFieldName.dateCreated] != null
          ? DateTime.parse(json[AccountFieldName.dateCreated])
          : null,
      accountName: json[AccountFieldName.accountName] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AccountFieldName.accountId: accountId,
      AccountFieldName.openingBalance: openingBalance ?? 0,
      AccountFieldName.balance: balance ?? 0,
      AccountFieldName.dateCreated: dateCreated?.toIso8601String(),
      AccountFieldName.accountName: accountName,
    };
  }
}

