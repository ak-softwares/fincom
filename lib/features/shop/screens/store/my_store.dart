import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../controllers/product/product_controller.dart';
import '../all_products/all_products.dart';

class MyStoreScreen extends StatelessWidget {
  const MyStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('my_store_screen');
    final productController = Get.put(ProductController());

    // Navigate directly to TAllProducts
    Future.microtask(() {
      Get.to(() => TAllProducts(
        title: 'My Store',
        futureMethod: productController.getAllProducts,
      ))?.then((_) {
        // Automatically pop this screen when returning from TAllProducts
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      });
    });

    // Return a placeholder or loading screen while the navigation occurs
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
