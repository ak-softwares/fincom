import 'package:fincom/utils/constants/enums.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../utils/constants/db_constants.dart';
import '../../../utils/formatters/formatters.dart';
import '../../personalization/models/address_model.dart';
import '../../settings/app_settings.dart';
import 'cart_item_model.dart';
import 'coupon_model.dart';
import 'image_model.dart'; // Assuming this exists for purchaseInvoiceImages

class OrderModel {
  String? id;
  int? orderId;
  int? invoiceNumber;
  OrderStatus? status;
  String? currency;
  bool? pricesIncludeTax;
  DateTime? dateCreated;
  DateTime? dateModified;
  DateTime? dateCompleted;
  DateTime? datePaid;
  String? discountTotal;
  String? discountTax;
  String? shippingTotal;
  String? shippingTax;
  String? cartTax;
  double? total;
  String? totalTax;
  int? userId;
  AddressModel? billing;
  AddressModel? shipping;
  String? paymentMethod;
  String? paymentMethodTitle;
  String? transactionId;
  String? customerIpAddress;
  String? customerUserAgent;
  String? customerNote;
  List<OrderMedaDataModel>? metaData;
  List<CartModel>? lineItems;
  List<CouponModel>? couponLines;
  String? paymentUrl;
  String? currencySymbol;
  bool? setPaid;
  List<ImageModel>? purchaseInvoiceImages;
  OrderType? orderType;

  OrderModel({
    this.id,
    this.invoiceNumber,
    this.orderId,
    this.status,
    this.currency,
    this.pricesIncludeTax,
    this.dateCreated,
    this.dateModified,
    this.dateCompleted,
    this.datePaid,
    this.discountTotal,
    this.discountTax,
    this.shippingTotal,
    this.shippingTax,
    this.cartTax,
    this.total,
    this.totalTax,
    this.userId,
    this.billing,
    this.shipping,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.transactionId,
    this.customerIpAddress,
    this.customerUserAgent,
    this.customerNote,
    this.metaData,
    this.lineItems,
    this.couponLines,
    this.paymentUrl,
    this.currencySymbol,
    this.setPaid,
    this.purchaseInvoiceImages,
    this.orderType,
  });

  int get getDaysDelayed {
    final now = DateTime.now();
    return now.difference(dateCreated ?? DateTime.now()).inDays;
  }

  int calculateTotalSum() {
    return lineItems?.fold<int>(
      0,
          (previousValue, currentItem) => previousValue + (int.tryParse(currentItem.subtotal ?? '') ?? 0),
    ) ?? 0;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json, {bool isWoo = false}) {
    final OrderType orderType = OrderType.values.firstWhere(
          (e) => e.name == json[OrderFieldName.orderType],
      orElse: () => OrderType.sale, // or a default fallback
    );
    return OrderModel(
        id: json[OrderFieldName.id] is ObjectId
            ? (json[OrderFieldName.id] as ObjectId).toHexString()
            : json[OrderFieldName.id]?.toString(),
        orderId: isWoo ? json[OrderFieldName.wooId] : json[OrderFieldName.orderId],
        invoiceNumber: json[OrderFieldName.invoiceNumber] ?? 0,
        status: OrderStatusExtension.fromString(json[OrderFieldName.status] ?? ''),
        currency: json[OrderFieldName.currency] ?? '',
        pricesIncludeTax: json[OrderFieldName.pricesIncludeTax] ?? false,
        dateCreated: json[OrderFieldName.dateCreated] ?? DateTime.now(),
        dateModified: json[OrderFieldName.dateModified] ?? DateTime.now(),
        dateCompleted: json[OrderFieldName.dateCompleted] ?? DateTime.now(),
        datePaid: json[OrderFieldName.datePaid] ?? DateTime.now(),
        discountTotal: json[OrderFieldName.discountTotal] ?? '',
        discountTax: json[OrderFieldName.discountTax] ?? '',
        shippingTotal: json[OrderFieldName.shippingTotal] ?? '',
        shippingTax: json[OrderFieldName.shippingTax] ?? '',
        cartTax: json[OrderFieldName.cartTax] ?? '',
        totalTax: json[OrderFieldName.totalTax] ?? '',
        total: json[OrderFieldName.total] ?? 0,
        userId: isWoo ? (json[OrderFieldName.customerId] ?? 0) : (json[OrderFieldName.userId] ?? 0),
        billing: json[OrderFieldName.billing] != null ? AddressModel.fromJson(json[OrderFieldName.billing]) : AddressModel(),
        shipping: json[OrderFieldName.shipping] != null ? AddressModel.fromJson(json[OrderFieldName.shipping]) : AddressModel(),
        paymentMethod: json[OrderFieldName.paymentMethod] ?? '',
        paymentMethodTitle: json[OrderFieldName.paymentMethodTitle] ?? '',
        transactionId: json[OrderFieldName.transactionId] ?? '',
        customerIpAddress: json[OrderFieldName.customerIpAddress] ?? '',
        customerUserAgent: json[OrderFieldName.customerUserAgent] ?? '',
        customerNote: json[OrderFieldName.customerNote] ?? '',
        lineItems: List<CartModel>.from(json[OrderFieldName.lineItems].map((item) => CartModel.fromJson(item))),
        paymentUrl: json[OrderFieldName.paymentUrl] ?? '',
        currencySymbol: json[OrderFieldName.currencySymbol] ?? '',
        purchaseInvoiceImages: List<ImageModel>.from(json[OrderFieldName.purchaseInvoiceImages]?.map((item) => ImageModel.fromJson(item)) ?? []),
        orderType: orderType,
      );
  }

  Map<String, dynamic> toMap() {
    return {
      if (orderId != null) OrderFieldName.orderId: orderId,
      if (invoiceNumber != null) OrderFieldName.invoiceNumber: invoiceNumber,
      if (status != null) OrderFieldName.status: status?.name,
      if (currency != null) OrderFieldName.currency: currency,
      if (pricesIncludeTax != null) OrderFieldName.pricesIncludeTax: pricesIncludeTax,
      if (dateCreated != null) OrderFieldName.dateCreated: dateCreated,
      if (dateModified != null) OrderFieldName.dateModified: dateModified,
      if (discountTotal != null) OrderFieldName.discountTotal: discountTotal,
      if (discountTax != null) OrderFieldName.discountTax: discountTax,
      if (shippingTotal != null) OrderFieldName.shippingTotal: shippingTotal,
      if (shippingTax != null) OrderFieldName.shippingTax: shippingTax,
      if (cartTax != null) OrderFieldName.cartTax: cartTax,
      if (total != null) OrderFieldName.total: total,
      if (totalTax != null) OrderFieldName.totalTax: totalTax,
      if (userId != null) OrderFieldName.userId: userId,
      if (billing != null) OrderFieldName.billing: billing?.toMap(),
      if (shipping != null) OrderFieldName.shipping: shipping?.toMap(),
      if (paymentMethod != null) OrderFieldName.paymentMethod: paymentMethod,
      if (paymentMethodTitle != null) OrderFieldName.paymentMethodTitle: paymentMethodTitle,
      if (transactionId != null) OrderFieldName.transactionId: transactionId,
      if (customerIpAddress != null) OrderFieldName.customerIpAddress: customerIpAddress,
      if (customerUserAgent != null) OrderFieldName.customerUserAgent: customerUserAgent,
      if (customerNote != null) OrderFieldName.customerNote: customerNote,
      if (dateCompleted != null) OrderFieldName.dateCompleted: dateCompleted,
      if (datePaid != null) OrderFieldName.datePaid: datePaid,
      if (lineItems != null) OrderFieldName.lineItems: lineItems?.map((item) => item.toMap()).toList(),
      if (paymentUrl != null) OrderFieldName.paymentUrl: paymentUrl,
      if (currencySymbol != null) OrderFieldName.currencySymbol: currencySymbol,
      if (purchaseInvoiceImages != null)
        OrderFieldName.purchaseInvoiceImages: purchaseInvoiceImages?.map((img) => img.toJson()).toList(),
      if (orderType != null) OrderFieldName.orderType: orderType?.name,
    };
  }

  Map<String, dynamic> toJsonForWoo() {
    final Map<String, dynamic> json = {
      OrderFieldName.userId: userId ?? 0,
      OrderFieldName.status: status ?? '',
      OrderFieldName.paymentMethod: paymentMethod ?? '',
      OrderFieldName.paymentMethodTitle: paymentMethodTitle ?? '',
      OrderFieldName.transactionId: transactionId ?? '',
      OrderFieldName.setPaid: setPaid ?? false,
      OrderFieldName.billing: billing?.toJsonForWoo(),
      OrderFieldName.shipping: shipping?.toJsonForWoo(),
      OrderFieldName.lineItems: lineItems?.map((item) => item.toJsonForWoo()).toList(),
      OrderFieldName.metaData: metaData?.map((item) => item.toJsonForWoo()).toList(),
    };

    if (couponLines != null && couponLines!.isNotEmpty) {
      final List<Map<String, dynamic>> couponJsonList = couponLines!
          .where((coupon) => !coupon.areAllPropertiesNull())
          .map((coupon) => coupon.toJsonForWoo())
          .toList();
      json[OrderFieldName.couponLines] = couponJsonList;
    }
    return json;
  }

  final List<Map<String, dynamic>> shippingLines = [
    {
      "method_id": "flat_rate",
      "method_title": "Shipping",
      "total": '${AppSettings.shippingCharge}'
    }
  ];

  OrderModel copyWith({
    String? id,
    int? orderId,
    int? invoiceNumber,
    OrderStatus? status,
    String? currency,
    bool? pricesIncludeTax,
    DateTime? dateCreated,
    DateTime? dateModified,
    DateTime? dateCompleted,
    DateTime? datePaid,
    String? discountTotal,
    String? discountTax,
    String? shippingTotal,
    String? shippingTax,
    String? cartTax,
    double? total,
    String? totalTax,
    int? userId,
    AddressModel? billing,
    AddressModel? shipping,
    String? paymentMethod,
    String? paymentMethodTitle,
    String? transactionId,
    String? customerIpAddress,
    String? customerUserAgent,
    String? customerNote,
    List<OrderMedaDataModel>? metaData,
    List<CartModel>? lineItems,
    List<CouponModel>? couponLines,
    String? paymentUrl,
    String? currencySymbol,
    bool? setPaid,
    List<ImageModel>? purchaseInvoiceImages,
    OrderType? orderType,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      pricesIncludeTax: pricesIncludeTax ?? this.pricesIncludeTax,
      dateCreated: dateCreated ?? this.dateCreated,
      dateModified: dateModified ?? this.dateModified,
      discountTotal: discountTotal ?? this.discountTotal,
      discountTax: discountTax ?? this.discountTax,
      shippingTotal: shippingTotal ?? this.shippingTotal,
      shippingTax: shippingTax ?? this.shippingTax,
      cartTax: cartTax ?? this.cartTax,
      total: total ?? this.total,
      totalTax: totalTax ?? this.totalTax,
      userId: userId ?? this.userId,
      billing: billing ?? this.billing,
      shipping: shipping ?? this.shipping,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentMethodTitle: paymentMethodTitle ?? this.paymentMethodTitle,
      transactionId: transactionId ?? this.transactionId,
      customerIpAddress: customerIpAddress ?? this.customerIpAddress,
      customerUserAgent: customerUserAgent ?? this.customerUserAgent,
      customerNote: customerNote ?? this.customerNote,
      dateCompleted: dateCompleted ?? this.dateCompleted,
      datePaid: datePaid ?? this.datePaid,
      metaData: metaData ?? this.metaData,
      lineItems: lineItems ?? this.lineItems,
      couponLines: couponLines ?? this.couponLines,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      setPaid: setPaid ?? this.setPaid,
      purchaseInvoiceImages: purchaseInvoiceImages ?? this.purchaseInvoiceImages,
      orderType: orderType ?? this.orderType,
    );
  }

}

class OrderMedaDataModel {
  final int? id;
  final String? key;
  final String? value;

  OrderMedaDataModel({
    this.id,
    this.key,
    this.value,
  });

  Map<String, dynamic> toJsonForWoo() {
    return {
      OrderMetaDataName.key: key ?? '',
      OrderMetaDataName.value: value ?? '',
    };
  }
}