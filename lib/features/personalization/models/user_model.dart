import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/constants/db_constants.dart';
import '../../../utils/formatters/formatters.dart';
import 'address_model.dart';

//for woocommerce
class CustomerModel {
  String? id;
  int? customerId;
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? role;
  String? username;
  String? company;
  String? gstNumber;
  AddressModel? billing;
  AddressModel? shipping;
  double? balance;
  bool? isPayingCustomer;
  String? avatarUrl;
  String? dateCreated;
  bool? isPhoneVerified;
  String? fCMToken;
  bool? isCODBlocked;

  CustomerModel({
    this.id,
    this.customerId,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.role,
    this.username,
    this.gstNumber,
    this.billing,
    this.shipping,
    this.balance,
    this.isPayingCustomer,
    this.avatarUrl,
    this.dateCreated,
    this.isPhoneVerified,
    this.fCMToken,
    this.isCODBlocked,
  });

  static CustomerModel empty() => CustomerModel();
  String get name => '${firstName ?? ''} ${lastName ?? ''}';
  String get phone => billing?.phone ?? '';

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json[CustomerFieldName.customerId] ?? 0,
      email: json[CustomerFieldName.email] ?? '',
      firstName: json[CustomerFieldName.firstName] ?? '',
      lastName: json[CustomerFieldName.lastName] ?? '',
      role: json[CustomerFieldName.role] ?? '',
      username: json[CustomerFieldName.username] ?? '',
      billing: AddressModel.fromJson(json[CustomerFieldName.billing] ?? {}),
      shipping: AddressModel.fromJson(json[CustomerFieldName.shipping] ?? {}),
      isPayingCustomer: json[CustomerFieldName.isPayingCustomer] ?? false,
      avatarUrl: json[CustomerFieldName.avatarUrl] ?? '',
      dateCreated: json[CustomerFieldName.dateCreated] ?? '',
      isPhoneVerified: (json[CustomerFieldName.metaData] as List?)?.any((meta) => meta['key'] == CustomerMetaDataName.verifyPhone && meta['value'] == true) ?? false,
      fCMToken: (json[CustomerFieldName.metaData] as List?)?.firstWhere((meta) => meta['key'] == CustomerMetaDataName.fCMToken, orElse: () => {'value': ''},)['value'] ?? '',
      isCODBlocked: (json[CustomerFieldName.metaData] as List?)?.any((meta) => meta['key'] == CustomerFieldName.isCODBlocked && meta['value'] == "1") ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      CustomerFieldName.customerId: customerId,
      CustomerFieldName.email: email,
      CustomerFieldName.firstName: firstName,
      CustomerFieldName.lastName: lastName,
      CustomerFieldName.role: role,
      CustomerFieldName.username: username,
      CustomerFieldName.billing: billing?.toMap(),
      CustomerFieldName.shipping: shipping?.toMap(),
      CustomerFieldName.isPayingCustomer: isPayingCustomer,
      CustomerFieldName.avatarUrl: avatarUrl,
      CustomerFieldName.dateCreated: dateCreated,
      CustomerFieldName.metaData: [
        {
          'key': CustomerMetaDataName.verifyPhone,
          'value': isPhoneVerified,
        },
        {
          'key': CustomerMetaDataName.fCMToken,
          'value': fCMToken,
        },
        {
          'key': CustomerFieldName.isCODBlocked,
          'value': isCODBlocked ?? false ? "1" : "0",
        }
      ],
    };
  }

  Map<String, dynamic> toJsonForWooSingUp(){
    return {
      CustomerFieldName.firstName: firstName,
      CustomerFieldName.username: username,
      CustomerFieldName.email: email,
      CustomerFieldName.password: password,
      CustomerFieldName.billing: billing?.toJsonForWoo(),
      CustomerFieldName.shipping: shipping?.toJsonForWoo(),
    };
  }
}

class CustomerMetaDataModel{
  final int? id;
  final String? key;
  final String? value;

  CustomerMetaDataModel({
    this.id,
    this.key,
    this.value,
  });

  //Convert a cartItem to a Json map
  Map<String, dynamic> toJsonForWoo() {
    return {
      OrderMetaDataName.key: key ?? '',
      OrderMetaDataName.value: value ?? '',
    };
  }
}

class UserModel {

  String? id;
  String? activeTime;
  String? avatarUrl;
  DateTime? dateCreated;
  DateTime? dateModified;
  String? email;
  String? userId;
  bool? isPayingCustomer;
  String? name;
  String? password;
  String?  phone;
  String? role;
  Map<String, dynamic>? metaData;
  List<dynamic>? cartItems;
  List<dynamic>? wishlistItems;
  List<dynamic>? recentItems;
  List<dynamic>? customerOrders;

  ///Constructor for UserModel.
  UserModel({
    this.activeTime,
    this.avatarUrl,
    this.dateCreated,
    this.dateModified,
    this.email,
    this.userId,
    this.isPayingCustomer,
    this.name,
    this.password,
    this.phone,
    this.role,
    this.metaData,
    this.cartItems,
    this.wishlistItems,
    this.recentItems,
    this.customerOrders,
  });

  ///Helper function to Format phone number
  String get formattedPhoneNo => AppFormatter.formatPhoneNumber(phone ?? '');

  /// static function to create an empty user model.
  static UserModel empty() => UserModel(phone: '');

  ///Covert model to json structure for storing data in FireStore.
  Map<String, dynamic> toJson() {
    // Create metaData map with cartItems, wishlistItems, and recentItems
    Map<String, dynamic> metaData = {
      UserFieldName.cartItems: {
        UserFieldName.items: cartItems,
        UserFieldName.dateModified: Timestamp.now().toDate(),
      },
      UserFieldName.wishlistItems: {
        UserFieldName.items: wishlistItems,
        UserFieldName.dateModified: Timestamp.now().toDate(),
      },
      UserFieldName.recentItems: {
        UserFieldName.items: recentItems,
        UserFieldName.dateModified: Timestamp.now().toDate(),
      },
      UserFieldName.customerOrders: {
        UserFieldName.items: customerOrders,
        UserFieldName.dateModified: Timestamp.now().toDate(),
      },
    };

    return {
      UserFieldName.activeTime: activeTime,
      UserFieldName.avatarUrl: avatarUrl,
      UserFieldName.dateCreated: dateCreated,
      UserFieldName.dateModified: dateModified,
      UserFieldName.email: email,
      UserFieldName.userId: userId,
      UserFieldName.isPayingCustomer: isPayingCustomer,
      UserFieldName.name: name,
      // UserFieldName.password: password,
      UserFieldName.phone: phone,
      UserFieldName.role: role,
      UserFieldName.metaData: metaData,
    };
  }
  Map<String, dynamic> toMap() {
    return {
      UserFieldName.name: name,
      UserFieldName.email: email,
      UserFieldName.password: password,
      UserFieldName.phone: phone,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json[UserFieldName.name] ?? '',
      email: json[UserFieldName.email] ?? '',
      password: json[UserFieldName.password] ?? '',
      phone: json[UserFieldName.phone] ?? '',
    );
  }

  // Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    if (data != null) {
      return UserModel(
        activeTime: data[UserFieldName.activeTime] ?? '',
        avatarUrl: data[UserFieldName.avatarUrl] ?? '',
        dateCreated: (data[AddressFieldName.dateCreated] as Timestamp?)?.toDate() ?? DateTime(2000),
        dateModified: (data[AddressFieldName.dateModified] as Timestamp?)?.toDate() ?? DateTime(2000),
        email: data[UserFieldName.email] ?? '',
        userId: data[UserFieldName.userId] ?? '',
        isPayingCustomer: data[UserFieldName.isPayingCustomer] ?? false,
        name: data[UserFieldName.name] ?? '',
        // password: data[UserFieldName.password] ?? '',
        phone: data[UserFieldName.phone] ?? '',
        role: data[UserFieldName.role] ?? '',
      );
    } else {
      return UserModel.empty();
    }
  }


}







