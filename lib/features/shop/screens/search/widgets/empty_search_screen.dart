import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/product/product_controller.dart';
import '../../category/scrolling_category_name.dart';
import '../../products/scrolling_products.dart';
class EmptySearchScreen extends StatelessWidget {
  const EmptySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());

    return SingleChildScrollView(
      child: Column(
        children: [
          const ScrollingCategoryName(),
          const SizedBox(height: AppSizes.sm),
          ScrollingProducts(title: 'Popular Products',  futureMethod: productController.getAllProducts),
          // const SizedBox(height: TSizes.sm),
          // ProductsScrollingByCategory(title: 'Soldering Irons', parameter: '61', futureMethod: productController.getProductsByCategoryId,),
        ],
      ),
    );
  }
}
