import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../common/web_view/my_web_view.dart';
import '../features/shop/controllers/product/product_controller.dart';
import '../features/shop/screens/all_products/all_products.dart';
import '../features/shop/screens/orders/order.dart';
import '../features/shop/screens/products/product_detail.dart';
import '../utils/constants/api_constants.dart';

class InternalAppRoutes {
  static final productController = Get.put(ProductController());

  static void internalRouteHandle({required String url}) {
    if (isValidWooCommerceUrl(url)) {
      // Extract the slug from the URL
      String slug = extractSlugFromUrl(url);

      navigateBasedOnUrlType(url, slug);
    } else {
      launchUrlString(url);
    }
  }

  static void navigateBasedOnUrlType(String url, String slug) {
    if (url.contains(APIConstant.urlContainProduct)) {
      Get.to(() => ProductDetailScreen(slug: slug));
    } else if (url.contains(APIConstant.urlContainProductCategory)) {
      Get.to(() => TAllProducts(title: 'Products', categoryId: slug, futureMethodTwoString: productController.getProductsByCategorySlug));
    } else if (url.contains(APIConstant.urlContainOrders)) {
      Get.to(() => const OrderScreen());
    } else {
      Get.to(() => MyWebView(title: 'Web view', url: url));
    }
  }

  // Function to extract the slug from the full URL
  static String extractSlugFromUrl(String url) {
    // Remove any trailing slashes from the URL
    url = url.replaceAll(RegExp(r'/$'), '');
    // Split the URL by '/' and get the last part
    List<String> urlParts = url.split('/');
    String slug = urlParts.last;
    return slug;
  }

  static bool isValidWooCommerceUrl(String url) {
    final domain = APIConstant.wooBaseUrl;
    RegExp regExp = RegExp(
      r"^https?:\/\/" + domain + r"\/.*$",
      caseSensitive: false,
    );
    return regExp.hasMatch(url);
  }
}
