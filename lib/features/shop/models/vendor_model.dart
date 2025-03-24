import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

import '../../../utils/constants/db_constants.dart';
import '../../personalization/models/address_model.dart';

class VendorModel {
  String? id;
  int? vendorId;
  String? email;
  String? phone;
  String? name;
  String? company;
  String? gstNumber;
  AddressModel? billing;
  AddressModel? shipping;
  String? avatarUrl;
  String? dateCreated;
  double? balance;
  double? openingBalance;

  VendorModel({
    this.id,
    this.vendorId,
    this.email,
    this.name,
    this.phone,
    this.company,
    this.gstNumber,
    this.billing,
    this.shipping,
    this.avatarUrl,
    this.dateCreated,
    this.balance,
    this.openingBalance,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      VendorFieldName.vendorId: vendorId,
      VendorFieldName.email: email,
      VendorFieldName.phone: phone,
      VendorFieldName.name: name,
      VendorFieldName.company: company,
      VendorFieldName.gstNumber: gstNumber,
      VendorFieldName.billing: billing?.toMap(),
      VendorFieldName.shipping: shipping?.toMap(),
      VendorFieldName.avatarUrl: avatarUrl,
      VendorFieldName.dateCreated: dateCreated,
      VendorFieldName.balance: balance ?? 0.0,
      VendorFieldName.openingBalance: openingBalance ?? 0.0,
    };
  }

  // Convert from Map (JSON)
  factory VendorModel.fromMap(Map<String, dynamic> map) {
    return VendorModel(
      id: map[VendorFieldName.id] is ObjectId
          ? (map[VendorFieldName.id] as ObjectId).toHexString() // Convert ObjectId to string
          : map[VendorFieldName.id]?.toString(), // Fallback to string if not ObjectId
      vendorId: map[VendorFieldName.vendorId],
      email: map[VendorFieldName.email],
      phone: map[VendorFieldName.phone],
      name: map[VendorFieldName.name],
      company: map[VendorFieldName.company],
      gstNumber: map[VendorFieldName.gstNumber],
      billing: map[VendorFieldName.billing] != null ? AddressModel.fromJson(map[VendorFieldName.billing]) : null,
      shipping: map[VendorFieldName.shipping] != null ? AddressModel.fromJson(map[VendorFieldName.shipping]) : null,
      avatarUrl: map[VendorFieldName.avatarUrl],
      dateCreated: map[VendorFieldName.dateCreated],
      balance: map[VendorFieldName.balance]?.toDouble(),
      openingBalance: map[VendorFieldName.openingBalance]?.toDouble(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() => toMap();

  // Convert from JSON
  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel.fromMap(json);
}