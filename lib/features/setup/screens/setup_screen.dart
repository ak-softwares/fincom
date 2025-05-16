import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/setup_controller.dart';
import '../models/ecommerce_platform.dart';


class SetupScreen extends StatelessWidget {

  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SetupController controller = Get.put(SetupController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Your E-commerce Integration'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Your E-commerce Platform',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Obx(() => Column(
              children: [
                RadioListTile<EcommercePlatform>(
                  title: Text('None'),
                  value: EcommercePlatform.none,
                  groupValue: controller.selectedPlatform.value,
                  onChanged: null, // This disables the tile
                  // onChanged: controller.selectPlatform,
                ),
                RadioListTile<EcommercePlatform>(
                  title: Text('WooCommerce'),
                  value: EcommercePlatform.woocommerce,
                  groupValue: controller.selectedPlatform.value,
                  onChanged: null, // This disables the tile
                  // onChanged: controller.selectPlatform,
                ),
                RadioListTile<EcommercePlatform>(
                  title: Text('Shopify'),
                  value: EcommercePlatform.shopify,
                  groupValue: controller.selectedPlatform.value,
                  onChanged: null, // This disables the tile
                  // onChanged: controller.selectPlatform,
                ),
                RadioListTile<EcommercePlatform>(
                  title: Text('Amazon'),
                  value: EcommercePlatform.amazon,
                  groupValue: controller.selectedPlatform.value,
                  onChanged: null, // This disables the tile
                  // onChanged: controller.selectPlatform,
                ),
              ],
            )),
            SizedBox(height: 24),
            Obx(() {
              switch (controller.selectedPlatform.value) {
                case EcommercePlatform.woocommerce:
                  return _wooCommerceForm();
                case EcommercePlatform.shopify:
                  return _shopifyForm();
                case EcommercePlatform.amazon:
                  return _amazonForm();
                case EcommercePlatform.none:
                  return SizedBox();
              }
            }),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: controller.saveSettings,
                child: Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wooCommerceForm() {
    final SetupController controller = Get.put(SetupController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WooCommerce Credentials',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Store Domain (e.g., mystore.com)',
            border: OutlineInputBorder(),
          ),
          onChanged: controller.wooCommerceDomain,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Consumer Key',
            border: OutlineInputBorder(),
          ),
          onChanged: controller.wooCommerceKey,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Consumer Secret',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          onChanged: controller.wooCommerceSecret,
        ),
      ],
    );
  }

  Widget _shopifyForm() {
    final SetupController controller = Get.put(SetupController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shopify Credentials',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Store Name (e.g., mystore.myshopify.com)',
            border: OutlineInputBorder(),
          ),
          onChanged: controller.shopifyStoreName,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'API Key',
            border: OutlineInputBorder(),
          ),
          onChanged: controller.shopifyApiKey,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          onChanged: controller.shopifyPassword,
        ),
      ],
    );
  }

  Widget _amazonForm() {
    final SetupController controller = Get.put(SetupController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amazon Seller Credentials',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Seller ID',
            border: OutlineInputBorder(),
          ),
          onChanged: controller.amazonSellerId,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Auth Token',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          onChanged: controller.amazonAuthToken,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Marketplace ID',
            border: OutlineInputBorder(),
          ),
          onChanged: controller.amazonMarketplaceId,
        ),
      ],
    );
  }
}