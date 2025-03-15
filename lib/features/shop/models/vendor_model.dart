import 'dart:convert';

import '../../../utils/constants/db_constants.dart';
import '../../personalization/models/address_model.dart';

class VendorModel {
  int? id;
  String? email;
  String? name;
  String? company;
  String? gstNumber;
  AddressModel? billing;
  AddressModel? shipping;
  String? avatarUrl;
  String? dateCreated;
  double? balance;

  VendorModel({
    this.id,
    this.email,
    this.name,
    this.company,
    this.gstNumber,
    this.billing,
    this.shipping,
    this.avatarUrl,
    this.dateCreated,
    this.balance,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      VendorFieldName.id: id,
      VendorFieldName.email: email,
      VendorFieldName.name: name,
      VendorFieldName.company: company,
      VendorFieldName.gstNumber: gstNumber,
      VendorFieldName.billing: billing?.toMap(),
      VendorFieldName.shipping: shipping?.toMap(),
      VendorFieldName.avatarUrl: avatarUrl,
      VendorFieldName.dateCreated: dateCreated,
      VendorFieldName.balance: balance,
    };
  }

  // Convert from Map (JSON)
  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      id: map[VendorFieldName.id],
      email: map[VendorFieldName.email],
      name: map[VendorFieldName.name],
      company: map[VendorFieldName.company],
      gstNumber: map[VendorFieldName.gstNumber],
      billing: map[VendorFieldName.billing] != null ? AddressModel.fromJson(map[VendorFieldName.billing]) : null,
      shipping: map[VendorFieldName.shipping] != null ? AddressModel.fromJson(map[VendorFieldName.shipping]) : null,
      avatarUrl: map[VendorFieldName.avatarUrl],
      dateCreated: map[VendorFieldName.dateCreated],
      balance: map[VendorFieldName.balance]?.toDouble(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => toMap();

  // Convert from JSON
  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel.fromMap(json);
}