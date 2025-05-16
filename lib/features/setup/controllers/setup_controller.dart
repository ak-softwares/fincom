import 'package:get/get.dart';

import '../models/ecommerce_platform.dart';


class SetupController extends GetxController {
  final Rx<EcommercePlatform> selectedPlatform = EcommercePlatform.none.obs;

  // WooCommerce
  final wooCommerceDomain = ''.obs;
  final wooCommerceKey = ''.obs;
  final wooCommerceSecret = ''.obs;

  // Shopify
  final shopifyStoreName = ''.obs;
  final shopifyApiKey = ''.obs;
  final shopifyPassword = ''.obs;

  // Amazon
  final amazonSellerId = ''.obs;
  final amazonAuthToken = ''.obs;
  final amazonMarketplaceId = ''.obs;

  void selectPlatform(EcommercePlatform platform) {
    selectedPlatform.value = platform;
    // Clear previous values when selecting a new platform
    _clearAllFields();
  }

  void _clearAllFields() {
    wooCommerceDomain.value = '';
    wooCommerceKey.value = '';
    wooCommerceSecret.value = '';
    shopifyStoreName.value = '';
    shopifyApiKey.value = '';
    shopifyPassword.value = '';
    amazonSellerId.value = '';
    amazonAuthToken.value = '';
    amazonMarketplaceId.value = '';
  }

  Future<void> saveSettings() async {
    try {
      if (selectedPlatform.value != EcommercePlatform.none) {
        // Validate fields based on selected platform
        if (!_validateCredentials()) {
          Get.snackbar('Error', 'Please fill all required fields');
          return;
        }
      }

      // final userId = Get.find<AuthController>().user.id;

      Map<String, dynamic> data = {
        'platform': selectedPlatform.value.toString(),
        // 'userId': userId,
      };

      switch (selectedPlatform.value) {
        case EcommercePlatform.woocommerce:
          data['credentials'] = WooCommerceCredentials(
            domain: wooCommerceDomain.value,
            key: wooCommerceKey.value,
            secret: wooCommerceSecret.value,
          ).toJson();
          break;
        case EcommercePlatform.shopify:
          data['credentials'] = ShopifyCredentials(
            storeName: shopifyStoreName.value,
            apiKey: shopifyApiKey.value,
            password: shopifyPassword.value,
          ).toJson();
          break;
        case EcommercePlatform.amazon:
          data['credentials'] = AmazonCredentials(
            sellerId: amazonSellerId.value,
            authToken: amazonAuthToken.value,
            marketplaceId: amazonMarketplaceId.value,
          ).toJson();
          break;
        case EcommercePlatform.none:
          break;
      }

      // Save to MongoDB
      // final response = await Get.find<DatabaseController>().saveUserSettings(data);
      //
      // if (response.success) {
      //   Get.offAllNamed('/dashboard');
      // } else {
      //   Get.snackbar('Error', 'Failed to save settings');
      // }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  bool _validateCredentials() {
    switch (selectedPlatform.value) {
      case EcommercePlatform.woocommerce:
        return wooCommerceDomain.value.isNotEmpty &&
            wooCommerceKey.value.isNotEmpty &&
            wooCommerceSecret.value.isNotEmpty;
      case EcommercePlatform.shopify:
        return shopifyStoreName.value.isNotEmpty &&
            shopifyApiKey.value.isNotEmpty &&
            shopifyPassword.value.isNotEmpty;
      case EcommercePlatform.amazon:
        return amazonSellerId.value.isNotEmpty &&
            amazonAuthToken.value.isNotEmpty &&
            amazonMarketplaceId.value.isNotEmpty;
      case EcommercePlatform.none:
        return true;
    }
  }
}