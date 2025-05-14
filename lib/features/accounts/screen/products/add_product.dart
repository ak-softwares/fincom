import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller/product/add_product_controller.dart';
import '../../models/product_model.dart';

class AddProducts extends StatelessWidget {
  const AddProducts({super.key, this.product});

  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    final AddProductController controller = Get.put(AddProductController());

    if (product != null) {
      controller.resetProductValues(product!);
    }

    return Scaffold(
      appBar: AppAppBar(title: product != null ? 'Update Product' : 'Add Product'),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
        child: ElevatedButton(
          onPressed: () => product != null ? controller.saveUpdatedProduct(previousProduct: product!) : controller.saveProduct(),
          child: Text(product != null ? 'Update Product' : 'Add Product', style: TextStyle(fontSize: 16)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: AppSizes.sm),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: controller.productFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Product ID'),
                  ],
                ),
                SizedBox(height: AppSizes.spaceBtwItems),
                TextFormField(
                  controller: controller.productTitleController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: AppSizes.spaceBtwItems),
                TextFormField(
                  controller: controller.purchasePriceController,
                  decoration: InputDecoration(
                    labelText: 'Purchase Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: AppSizes.spaceBtwItems),
                TextFormField(
                  controller: controller.stockController,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: AppSizes.spaceBtwItems),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
