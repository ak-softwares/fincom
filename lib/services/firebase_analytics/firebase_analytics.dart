import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

import '../../data/repositories/authentication/authentication_repository.dart';
import '../../features/personalization/controllers/customers_controller.dart';
import '../../features/settings/app_settings.dart';
import '../../features/shop/controllers/checkout_controller/checkout_controller.dart';
import '../../features/shop/controllers/order/order_controller.dart';
import '../../features/shop/models/cart_item_model.dart';
import '../../features/shop/models/product_model.dart';

class FBAnalytics {

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: _analytics);

  static final userController = Get.put(CustomersController());
  static final checkoutController = Get.put(CheckoutController());
  static final authenticationRepository = Get.put(AuthenticationRepository());

  static Future<void> setDefaultEventParameters() async {
    final appVersion = await AppSettings.getAppVersion();
    Map<String, dynamic> defaultParameters = {
      'timestamp': DateTime.now().toIso8601String(), // ISO format for better compatibility
      'platform': 'mobile', // Default to 'mobile'; adjust based on your platform
      'app_version': appVersion ?? 'NA', // Replace with the actual app version
    };

    // Check if the user is logged in, and add user-specific details
    if (authenticationRepository.isUserLogin.value) {
      defaultParameters.addAll({
        'user_id': userController.customer.value.customerId?.toString() ?? 'NA',
        'user_email': userController.customer.value.email ?? 'NA',
      });
    }

    // Set default event parameters
    await _analytics.setDefaultEventParameters(defaultParameters);
  }

  static void logLogin(String loginMethod) async {
    // print('loginMethod=========== $loginMethod');
    return _analytics.logLogin(loginMethod: loginMethod);
  }

  static void logSignup(String signUpMethod) async {
    // print('SignupMethod=========== $loginMethod');
    return _analytics.logSignUp(signUpMethod: signUpMethod);
  }

  static void logPageView(String pageName) {
    _analytics.logEvent(
        name: 'page_view',
        parameters: {
          'page_name': pageName
        }
    );
  }

  static void logViewItem({required ProductModel product}) {
    // print('logAddToCart: itemId - $itemId, itemName - $itemName, price - $price, quantity - $quantity,');
    _analytics.logViewItem(
      items: [
        AnalyticsEventItem(
          itemId: product.productId.toString(),
          itemName: product.name,
          price: product.getPrice(),
          itemCategory: product.categories?[0].name,
        ),
      ],
      value: product.getPrice(),
      currency: AppSettings.appCurrency,
    );
  }

  static void logShare({required String contentType, required String method, required String itemName, required String itemId}) {
    // Ensure default parameters are set before logging the event
    _analytics.logShare(
      contentType: contentType, // Type of content being shared, e.g., 'product', 'blog', 'category'
      itemId: itemId, // Unique identifier of the item being shared
      method: method, // Method of sharing, e.g., 'social_media', 'email', 'link'
      parameters: {
        'page_name': itemName,
      }
    );
  }

  static void logSearch({required String searchTerm}) {
    // Ensure default parameters are set before logging the event
    _analytics.logSearch(
      searchTerm: searchTerm,
    );
  }

  static void logViewSearchResults({required String searchTerm, required String resultsCount}) {
    // Ensure default parameters are set before logging the event
    _analytics.logViewSearchResults(
      searchTerm: searchTerm,
    );
  }

  static void logAddToWishlist({required ProductModel product}) {
    // print('logAddToCart: itemId - $itemId, itemName - $itemName, price - $price, quantity - $quantity,');
    _analytics.logAddToWishlist(
      items: [
        AnalyticsEventItem(
          itemId: product.productId.toString(),
          itemName: product.name,
          price: product.getPrice(),
          itemCategory: product.categories?[0].name,
        ),
      ],
      value: product.getPrice(),
      currency: AppSettings.appCurrency,
    );
  }

  static void logAddToCart({required CartModel cartItem}) {
    _analytics.logAddToCart(
      items: [
        AnalyticsEventItem(
          itemId: cartItem.productId.toString(),
          itemName: cartItem.name,
          price: cartItem.price,
          itemCategory: cartItem.category,
          quantity: cartItem.quantity,
        ),
      ],
      value: (cartItem.price! * cartItem.quantity).toDouble(),
      currency: AppSettings.appCurrency,
    );
  }

  static void logRemoveFromCart({required CartModel cartItem}) {
    // print('logAddToCart: itemId - $itemId, itemName - $itemName, price - $price, quantity - $quantity,');
    _analytics.logRemoveFromCart(
      items: [
        AnalyticsEventItem(
          itemId: cartItem.productId.toString(),
          itemName: cartItem.name,
          price: cartItem.price,
          itemCategory: cartItem.category,
          quantity: cartItem.quantity,
        ),
      ],
      value: (cartItem.price! * cartItem.quantity).toDouble(),
      currency: AppSettings.appCurrency,
    );
  }

  static void logViewCart({required List<CartModel> cartItems}) {
    if (cartItems.isEmpty) {
      return;
    }

    // Map cart items to AnalyticsEventItem
    final analyticsItems = cartItems.map((cartItem) {
      return AnalyticsEventItem(
        itemId: cartItem.productId.toString(),
        itemName: cartItem.name,
        price: cartItem.price,
        itemCategory: cartItem.category,
        quantity: cartItem.quantity,
      );
    }).toList();

    // Calculate the total value of the cart
    final totalValue = cartItems.fold<double>(
      0.0,
          (sum, cartItem) => sum + (cartItem.price! * cartItem.quantity).toDouble(),
    );

    _analytics.logViewCart(
      items: analyticsItems,
      value: totalValue,
      currency: AppSettings.appCurrency,
    );
  }

  static void logBeginCheckout({required List<CartModel> cartItems}) {
    // Ensure cartItems is not empty to avoid unnecessary logging
    if (cartItems.isEmpty) {
      return;
    }

    // Map cart items to AnalyticsEventItem
    final analyticsItems = cartItems.map((cartItem) {
      return AnalyticsEventItem(
        itemId: cartItem.productId.toString(),
        itemName: cartItem.name,
        price: cartItem.price,
        itemCategory: cartItem.category,
        quantity: cartItem.quantity,
      );
    }).toList();

    // Ensure required values are present before logging
    final couponCode = checkoutController.coupon.value.code ?? '';
    final shippingCost = checkoutController.shipping.value ?? 0.0;
    final grandTotal = checkoutController.total.value ?? 0.0;

    // Log the checkout event
    _analytics.logBeginCheckout(
      items: analyticsItems,
      value: grandTotal,
      currency: AppSettings.appCurrency, // Ensure this matches the expected currency format
      coupon: couponCode.isNotEmpty ? couponCode : null, // Log coupon only if it exists
    );
  }

  static void logCheckout({required List<CartModel> cartItems}) {
    // Ensure cartItems is not empty to avoid unnecessary logging
    if (cartItems.isEmpty) {
      return;
    }

    // Map cart items to AnalyticsEventItem
    final analyticsItems = cartItems.map((cartItem) {
      return AnalyticsEventItem(
        itemId: cartItem.productId.toString(),
        itemName: cartItem.name,
        price: cartItem.price,
        itemCategory: cartItem.category,
        quantity: cartItem.quantity,
      );
    }).toList();

    // Ensure required values are present before logging
    final paymentMethod = checkoutController.selectedPaymentMethod.value.title ?? 'NA';
    final couponCode = checkoutController.coupon.value.code ?? '';
    final shippingCost = checkoutController.shipping.value ?? 0.0;
    final grandTotal = checkoutController.total.value ?? 0.0;

    // Log the checkout event
    _analytics.logPurchase(
      items: analyticsItems,
      value: grandTotal,
      currency: AppSettings.appCurrency, // Ensure this matches the expected currency format
      coupon: couponCode.isNotEmpty ? couponCode : null, // Log coupon only if it exists
      shipping: shippingCost.toDouble(), // Convert shipping cost to double if it's not already
      parameters: {
        'payment_method': paymentMethod,
      }
    );
  }

  static void logAddPaymentInfo({required List<CartModel> cartItems}) {
    final couponCode = checkoutController.coupon.value.code ?? '';

    // Map cart items to AnalyticsEventItem
    final analyticsItems = cartItems.map((cartItem) {
      return AnalyticsEventItem(
        itemId: cartItem.productId.toString(),
        itemName: cartItem.name,
        price: cartItem.price,
        itemCategory: cartItem.category,
        quantity: cartItem.quantity,
      );
    }).toList();

    // Calculate the total value of the cart
    final totalValue = cartItems.fold<double>(
      0.0,
          (sum, cartItem) => sum + (cartItem.price! * cartItem.quantity).toDouble(),
    );

    // Ensure default parameters are set before logging the event
    _analytics.logAddPaymentInfo(
      items: analyticsItems,
      currency: AppSettings.appCurrency, // Ensure this matches the expected currency format
      coupon: couponCode.isNotEmpty ? couponCode : null, // Log coupon only if it exists
      paymentType: 'razorpay',
      value: totalValue,
    );
  }
}