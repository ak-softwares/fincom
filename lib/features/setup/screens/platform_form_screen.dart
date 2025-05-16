import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/setup_controller.dart';
import '../models/ecommerce_platform.dart';

class PlatformFormScreen extends StatelessWidget {
  const PlatformFormScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final SetupController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
          controller.selectedPlatform.value == EcommercePlatform.woocommerce
              ? 'WooCommerce Setup'
              : controller.selectedPlatform.value == EcommercePlatform.shopify
              ? 'Shopify Setup'
              : 'Amazon Setup',
        )),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Obx(() {
          switch (controller.selectedPlatform.value) {
            case EcommercePlatform.woocommerce:
              return _WooCommerceForm();
            case EcommercePlatform.shopify:
              return _ShopifyForm();
            case EcommercePlatform.amazon:
              return _AmazonForm();
            case EcommercePlatform.none:
              return SizedBox();
          }
        }),
      ),
    );
  }
}

class _WooCommerceForm extends StatelessWidget {
  final SetupController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Enter your WooCommerce credentials',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 24),
        TextField(
          decoration: InputDecoration(
            labelText: 'Store Domain (e.g., mystore.com)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.public),
          ),
          onChanged: _controller.wooCommerceDomain,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Consumer Key',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.vpn_key),
          ),
          onChanged: _controller.wooCommerceKey,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Consumer Secret',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.security),
          ),
          obscureText: true,
          onChanged: _controller.wooCommerceSecret,
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: _controller.saveSettings,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text('Connect Store'),
        ),
      ],
    );
  }
}

class _ShopifyForm extends StatelessWidget {
  final SetupController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Enter your Shopify credentials',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 24),
        TextField(
          decoration: InputDecoration(
            labelText: 'Store Name (e.g., mystore.myshopify.com)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.store),
          ),
          onChanged: _controller.shopifyStoreName,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'API Key',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.vpn_key),
          ),
          onChanged: _controller.shopifyApiKey,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.security),
          ),
          obscureText: true,
          onChanged: _controller.shopifyPassword,
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: _controller.saveSettings,
          child: Text('Connect Store'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }
}

class _AmazonForm extends StatelessWidget {
  final SetupController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Enter your Amazon Seller credentials',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 24),
        TextField(
          decoration: InputDecoration(
            labelText: 'Seller ID',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          onChanged: _controller.amazonSellerId,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Auth Token',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.security),
          ),
          obscureText: true,
          onChanged: _controller.amazonAuthToken,
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Marketplace ID',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.public),
          ),
          onChanged: _controller.amazonMarketplaceId,
        ),
        SizedBox(height: 32),
        ElevatedButton(
          onPressed: _controller.saveSettings,
          child: Text('Connect Store'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }
}