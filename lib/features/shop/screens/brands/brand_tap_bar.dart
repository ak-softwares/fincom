import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/product/cart/cart_counter_icon.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/brand_controller/brand_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../products/tabview_products.dart';
import '../search/search.dart';
import 'widgets/single_brand_tile.dart';

class BrandTapBarScreen extends StatelessWidget {
  const BrandTapBarScreen({super.key, this.brandID = 0});

  final int brandID;

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('brand_tap_bar_screen');
    final brandController = Get.put(BrandController());
    final productController = Get.put(ProductController());

    final brands = brandController.productBrands;
    // Find the index of the category with the given id
    final initialIndex = brands.indexWhere((brand) => brand.id == brandID);

    // Handle cases where the category ID is not found
    final safeInitialIndex = initialIndex >= 0 ? initialIndex : 0;
    return DefaultTabController(
      initialIndex: safeInitialIndex,
      length: brands.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: AppColors.white,
          title: Text('Shop by Brands', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600)),
          actions: [
            IconButton( icon: Icon(TIcons.search), color: AppColors.secondaryColor, onPressed: () => showSearch(context: context, delegate: TSearchDelegate())),
            TCartCounterIcon(iconColor: AppColors.secondaryColor),
          ],
          toolbarHeight: 80,
          bottom: TabBar(
            unselectedLabelColor: Colors.black87,
            indicatorColor: AppColors.secondaryColor,
            isScrollable: true,
            tabs: brands.map((brand) {
              return Padding(
                padding: const EdgeInsets.only(top: AppSizes.defaultBtwTiles, bottom: AppSizes.defaultBtwTiles),
                child: SingleBrandTile(
                    image: brand.image ?? '',
                ),
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: brands.map((brand) {
            return TabviewProducts(
                itemID: brand.id.toString(),
                itemName: brand.name ?? '',
                itemUrl: brand.permalink,
                futureMethod: productController.getProductsByBrandId
            );
          }).toList(),
        ),
      ),
    );
  }
}