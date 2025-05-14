
import '../../../utils/constants/db_constants.dart';

class CouponModel {
  final int? id;
  final String? code;
  final String? amount;
  final String? dateCreated;
  final String? discount;
  final String? discountType;
  final String? description;
  final String? dateExpires;
  final bool? freeShipping;
  final bool? individualUse;
  final String? minimumAmount;
  final String? maximumAmount;
  final String? maxDiscount;
  final bool? isCODBlocked;
  final bool? showOnCheckout;

  CouponModel({
    this.id,
    this.code,
    this.amount,
    this.dateCreated,
    this.discount,
    this.discountType,
    this.description,
    this.dateExpires,
    this.freeShipping,
    this.individualUse,
    this.minimumAmount,
    this.maximumAmount,
    this.maxDiscount,
    this.isCODBlocked,
    this.showOnCheckout,
  });
  static CouponModel empty() => CouponModel();

  String? getValidityErrorMessage() {

    // Check if the coupon is expired
    if (dateExpires != null && DateTime.parse(dateExpires!).isBefore(DateTime.now())) {
      return 'Coupon is expired';
    }

    return null;
  }

  bool areAllPropertiesNull() {
    return id == null &&
        code == null &&
        amount == null &&
        dateCreated == null &&
        discountType == null &&
        description == null &&
        dateExpires == null &&
        freeShipping == null &&
        individualUse == null &&
        minimumAmount == null &&
        maximumAmount == null &&
        maxDiscount == null;
  }

  bool isFreeShipping() {
    // Check if the coupon provides free shipping
    return freeShipping ?? false;
  }

  bool isIndividualUse() {
    // Check if the coupon provides free shipping
    return individualUse ?? false;
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json[CouponFieldName.id],
      code: json[CouponFieldName.code],
      amount: json[CouponFieldName.amount],
      discount: json[CouponFieldName.discount],
      dateCreated: json[CouponFieldName.dateCreated],
      discountType: json[CouponFieldName.discountType],
      description: json[CouponFieldName.description],
      dateExpires: json[CouponFieldName.dateExpires],
      freeShipping: json[CouponFieldName.freeShipping],
      individualUse: json[CouponFieldName.individualUse],
      minimumAmount: json[CouponFieldName.minimumAmount],
      maximumAmount: json[CouponFieldName.maximumAmount],
      maxDiscount: (json[CouponFieldName.metaData] as List?)?.firstWhere((meta) => meta['key'] == CouponFieldName.maxDiscount, orElse: () => {'value': ''},)['value'] ?? '',
      isCODBlocked: (json[CouponFieldName.metaData] as List?)?.any((meta) => meta['key'] == CouponFieldName.isCODBlocked && meta['value'] == "1") ?? false,
      showOnCheckout: (json[CouponFieldName.metaData] as List?)?.any((meta) => meta['key'] == CouponFieldName.showOnCheckout && meta['value'] == "1") ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) CouponFieldName.id: id,
      if (code != null) CouponFieldName.code: code,
      if (amount != null) CouponFieldName.amount: amount,
      if (discount != null) CouponFieldName.discount: discount,
      if (dateCreated != null) CouponFieldName.dateCreated: dateCreated,
      if (discountType != null) CouponFieldName.discountType: discountType,
      if (description != null) CouponFieldName.description: description,
      if (dateExpires != null) CouponFieldName.dateExpires: dateExpires,
      if (freeShipping != null) CouponFieldName.freeShipping: freeShipping,
      if (individualUse != null) CouponFieldName.individualUse: individualUse,
      if (minimumAmount != null) CouponFieldName.minimumAmount: minimumAmount,
      if (maximumAmount != null) CouponFieldName.maximumAmount: maximumAmount,
    };
  }

  Map<String, dynamic> toJsonForWoo() {
    return {
      CouponFieldName.code: code,
    };
  }

}
