enum EcommercePlatform {
  none,
  woocommerce,
  shopify,
  amazon,
}

// models/woocommerce_credentials.dart
class WooCommerceCredentials {
  final String domain;
  final String key;
  final String secret;

  WooCommerceCredentials({
    required this.domain,
    required this.key,
    required this.secret,
  });

  Map<String, dynamic> toJson() => {
    'domain': domain,
    'key': key,
    'secret': secret,
  };

  factory WooCommerceCredentials.fromJson(Map<String, dynamic> json) => WooCommerceCredentials(
    domain: json['domain'],
    key: json['key'],
    secret: json['secret'],
  );
}

// models/shopify_credentials.dart
class ShopifyCredentials {
  final String storeName;
  final String apiKey;
  final String password;

  ShopifyCredentials({
    required this.storeName,
    required this.apiKey,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'storeName': storeName,
    'apiKey': apiKey,
    'password': password,
  };

  factory ShopifyCredentials.fromJson(Map<String, dynamic> json) => ShopifyCredentials(
    storeName: json['storeName'],
    apiKey: json['apiKey'],
    password: json['password'],
  );
}

// models/amazon_credentials.dart
class AmazonCredentials {
  final String sellerId;
  final String authToken;
  final String marketplaceId;

  AmazonCredentials({
    required this.sellerId,
    required this.authToken,
    required this.marketplaceId,
  });

  Map<String, dynamic> toJson() => {
    'sellerId': sellerId,
    'authToken': authToken,
    'marketplaceId': marketplaceId,
  };

  factory AmazonCredentials.fromJson(Map<String, dynamic> json) => AmazonCredentials(
    sellerId: json['sellerId'],
    authToken: json['authToken'],
    marketplaceId: json['marketplaceId'],
  );
}