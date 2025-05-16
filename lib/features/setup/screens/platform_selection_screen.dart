import 'package:fincom/common/widgets/custom_shape/image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/layout_models/product_grid_layout.dart';
import '../../../common/navigation_bar/appbar.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/setup_controller.dart';
import '../models/ecommerce_platform.dart';
import 'platform_form_screen.dart';


class PlatformSelectionScreen extends StatelessWidget {

  const PlatformSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppAppBar(title: 'Connect Your Store'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Select your e-commerce platform',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: AppSizes.md),
            _PlatformCard(
              platform: EcommercePlatform.woocommerce,
              name: 'WooCommerce',
              image: 'assets/images/ecommerce_platform/woocommerce_logo.png',
              color: Colors.blue,
            ),
            SizedBox(height: AppSizes.md),
            _PlatformCard(
              platform: EcommercePlatform.shopify,
              name: 'Shopify',
              image: 'assets/images/ecommerce_platform/shopify_logo.png',
              color: Colors.green,
            ),
            SizedBox(height: AppSizes.md),
            _PlatformCard(
              platform: EcommercePlatform.amazon,
              name: 'Amazon',
              image: 'assets/images/ecommerce_platform/amazon_logo.png',
              color: Colors.orange,
            ),
            SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}

class _PlatformCard extends StatelessWidget {
  final EcommercePlatform platform;
  final String name;
  final String image;
  final Color color;

  const _PlatformCard({
    required this.platform,
    required this.name,
    required this.image,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Get.put(SetupController()).selectPlatform(platform);
            if (platform == EcommercePlatform.none) {
              Get.find<SetupController>().saveSettings();
            } else {
              Get.to(() => PlatformFormScreen());
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedImage(
                width: 200,
                image: image,
              ),
              SizedBox(height: 16),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}