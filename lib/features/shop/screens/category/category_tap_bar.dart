import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/product/cart/cart_counter_icon.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/icons.dart';
import '../../controllers/category_controller/category_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../search/search.dart';
import '../products/tabview_products.dart';

class CategoryTapBarScreen extends StatelessWidget {
  const CategoryTapBarScreen({super.key, this.categoryId = '0'});

  final String categoryId;

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('category_tap_bar_screen');
    final categoryController = Get.put(CategoryController());
    final productController = Get.put(ProductController());

    final categories = categoryController.categories;
    // Find the index of the category with the given id
    final initialIndex = categories.indexWhere((category) => category.id == categoryId);

    // Handle cases where the category ID is not found
    final safeInitialIndex = initialIndex >= 0 ? initialIndex : 0;
    return DefaultTabController(
          initialIndex: safeInitialIndex,
          length: categories.length,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: TColors.primaryColor,
              title: Text('Products by categories', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600)),
              actions: [
                IconButton( icon: Icon(TIcons.search), color: TColors.secondaryColor, onPressed: () => showSearch(context: context, delegate: TSearchDelegate())),
                TCartCounterIcon(iconColor: TColors.secondaryColor),
              ],
              bottom: TabBar(
                unselectedLabelColor: Colors.black87,
                indicatorColor: TColors.secondaryColor,
                isScrollable: true,
                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                tabs: categories.map((category) {
                  return Tab(
                    text: category.name,
                  );
                }).toList(),
              ),
            ),
            body: TabBarView(
              children: categories.map((category) {
                return TabviewProducts(
                    itemID: category.id.toString(),
                    itemName: category.name ?? '',
                    itemUrl: category.permalink,
                    futureMethod: productController.getProductsByCategoryId
                );
              }).toList(),
            ),
          ),
        );
  }
}
