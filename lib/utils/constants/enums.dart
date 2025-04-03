import 'db_constants.dart';

enum TextSizes { small, medium, large }
enum TransactionType { payment, refund, transfer, purchase}
extension TransactionTypeExtension on TransactionType {

  String get name {
    switch (this) {
      case TransactionType.payment:
        return 'payment';
      case TransactionType.refund:
        return 'refund';
      case TransactionType.transfer:
        return 'transfer';
      case TransactionType.purchase:
        return 'purchase';
    }
  }
}
enum PurchaseListType { vendors, purchasable, purchased, notAvailable }

enum EntityType { vendor, payment, customer, expense }
extension EntityTypeExtension on EntityType {

  String get name {
    switch (this) {
      case EntityType.vendor:
        return 'vendor';
      case EntityType.payment:
        return 'payment';
      case EntityType.customer:
        return 'customer';
      case EntityType.expense:
        return 'expense';
    }
  }

  String get dbName {
    switch (this) {
      case EntityType.vendor:
        return DbCollections.vendors;
      case EntityType.payment:
        return DbCollections.payments;
      case EntityType.customer:
        return DbCollections.customers;
      case EntityType.expense:
        // TODO: Handle this case.
        throw DbCollections.expenses;
    }
  }

  String get fieldName {
    switch (this) {
      case EntityType.vendor:
        return VendorFieldName.vendorId;
      case EntityType.payment:
        return PaymentMethodFieldName.paymentId;
      case EntityType.customer:
        return CustomerFieldName.customerId;
      case EntityType.expense:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}


enum PaymentMethods { cod, prepaid, paytm, razorpay }
extension PaymentMethodsExtension on PaymentMethods {
  String get name {
    switch (this) {
      case PaymentMethods.cod:
        return PaymentMethodName.cod;
      case PaymentMethods.prepaid:
        return PaymentMethodName.prepaid;
      case PaymentMethods.paytm:
        return PaymentMethodName.paytm;
      case PaymentMethods.razorpay:
        return PaymentMethodName.razorpay;
    }
  }

  String get title {
    switch (this) {
      case PaymentMethods.cod:
        return PaymentMethodTitle.cod;
      case PaymentMethods.prepaid:
        return PaymentMethodTitle.prepaid;
      case PaymentMethods.paytm:
        return PaymentMethodTitle.paytm;
      case PaymentMethods.razorpay:
        return PaymentMethodTitle.razorpay;
    }
  }

  static PaymentMethods fromString(String method) {
    return PaymentMethods.values.firstWhere(
          (e) => e.name == method,
      orElse: () => PaymentMethods.cod, // Default to COD if unknown
    );
  }
}

enum OrderStatus {
  cancelled,
  processing,
  readyToShip,
  pendingPickup,
  pendingPayment,
  inTransit,
  completed,
  returnInTransit,
  returnPending,
  unknown
}

extension OrderStatusExtension on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.cancelled:
        return OrderStatusName.cancelled;
      case OrderStatus.processing:
        return OrderStatusName.processing;
      case OrderStatus.readyToShip:
        return OrderStatusName.readyToShip;
      case OrderStatus.pendingPickup:
        return OrderStatusName.pendingPickup;
      case OrderStatus.pendingPayment:
        return OrderStatusName.pendingPayment;
      case OrderStatus.inTransit:
        return OrderStatusName.inTransit;
      case OrderStatus.completed:
        return OrderStatusName.completed;
      case OrderStatus.returnInTransit:
        return OrderStatusName.returnInTransit;
      case OrderStatus.returnPending:
        return OrderStatusName.returnPending;
      case OrderStatus.unknown:
        return OrderStatusName.unknown;
    }
  }

  String get prettyName {
    switch (this) {
      case OrderStatus.cancelled:
        return OrderStatusPritiName.cancelled;
      case OrderStatus.processing:
        return OrderStatusPritiName.processing;
      case OrderStatus.readyToShip:
        return OrderStatusPritiName.readyToShip;
      case OrderStatus.pendingPickup:
        return OrderStatusPritiName.pendingPickup;
      case OrderStatus.pendingPayment:
        return OrderStatusPritiName.pendingPayment;
      case OrderStatus.inTransit:
        return OrderStatusPritiName.inTransit;
      case OrderStatus.completed:
        return OrderStatusPritiName.completed;
      case OrderStatus.returnInTransit:
        return OrderStatusPritiName.returnInTransit;
      case OrderStatus.returnPending:
        return OrderStatusPritiName.returnPending;
      case OrderStatus.unknown:
        return OrderStatusName.unknown;
    }
  }

  static OrderStatus? fromString(String status) {
    return OrderStatus.values.firstWhere(
          (e) => e.name == status,
      orElse: () => OrderStatus.unknown, // Handle unknown statuses
    );
  }
}

