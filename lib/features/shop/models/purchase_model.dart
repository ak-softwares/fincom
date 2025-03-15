import 'package:mongo_dart/mongo_dart.dart';

import '../../../utils/constants/db_constants.dart';
import 'cart_item_model.dart';
import 'image_model.dart';
import 'payment_method.dart';
import 'vendor_model.dart';


class PurchaseModel {
  String? id; // Store _id as a String
  int? purchaseID;
  DateTime? date;
  VendorModel? vendor;
  String? invoiceNumber;
  List<CartModel>? purchasedItems;
  List<ImageModel>? purchaseInvoiceImages;
  double? total;
  PaymentMethodModel? paymentMethod;
  double? paymentAmount;

  PurchaseModel({
    this.id,
    this.purchaseID,
    this.date,
    this.vendor,
    this.invoiceNumber,
    this.purchasedItems,
    this.total,
    this.paymentMethod,
    this.paymentAmount,
    this.purchaseInvoiceImages,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json[PurchaseFieldName.id] is ObjectId
          ? (json[PurchaseFieldName.id] as ObjectId).toHexString() // Convert ObjectId to string
          : json[PurchaseFieldName.id]?.toString(), // Fallback to string if not ObjectId
      purchaseID: json[PurchaseFieldName.purchaseID],
      date: DateTime.parse(json[PurchaseFieldName.date]),
      vendor: VendorModel.fromJson(json[PurchaseFieldName.vendor]),
      invoiceNumber: json[PurchaseFieldName.invoiceNumber],
      purchasedItems: (json[PurchaseFieldName.purchasedItems] as List)
          .map((item) => CartModel.fromJson(item))
          .toList(),
      purchaseInvoiceImages: (json[PurchaseFieldName.purchaseInvoiceImages] ?? [])
          .map<ImageModel>((item) => ImageModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: (json[PurchaseFieldName.total] as num).toDouble(),
      paymentMethod: PaymentMethodModel.fromJson(json[PurchaseFieldName.paymentMethod]),
      paymentAmount: (json[PurchaseFieldName.paymentAmount] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      PurchaseFieldName.purchaseID: purchaseID,
      PurchaseFieldName.date: date?.toIso8601String(),
      PurchaseFieldName.vendor: vendor?.toJson(),
      PurchaseFieldName.invoiceNumber: invoiceNumber,
      PurchaseFieldName.purchasedItems: purchasedItems?.map((item) => item.toJson()).toList(),
      PurchaseFieldName.purchaseInvoiceImages: purchaseInvoiceImages?.map((item) => item.toJson()).toList(),
      PurchaseFieldName.total: total,
      PurchaseFieldName.paymentMethod: paymentMethod?.toJson(),
      PurchaseFieldName.paymentAmount: paymentAmount,
    };
  }
}
