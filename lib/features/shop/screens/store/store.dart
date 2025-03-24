import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/navigation_bar/tabbar.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/brands/branditemcount.dart';
import '../../../../common/widgets/brands/brandshowcase.dart';
import '../../../../common/widgets/product/product_cards/product_card.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/product_controller.dart';
import '../brands/all_brands.dart';
import '../search/search_input_field.dart';


class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('store_screen');

    final controller = Get.put(ProductController());

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: const AppAppBar2(titleText: "Store", showCartIcon: true),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: Colors.white,
                expandedHeight: 440,
                flexibleSpace: Container(
                  padding: const EdgeInsets.all(Sizes.defaultSpace / 2),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Searchbar
                      const TSearchBar(
                        searchText: "Search in Store",
                      ),
                      // Heading featured brand
                      TSectionHeading(
                        title: 'Featured Brands',
                        seeActionButton: true,
                        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const AllBrandScreen()));},
                      ),
                      // Featured brand container
                      GridLayout(
                          itemCount: 4,
                          mainAxisExtent: 70,
                          itemBuilder: (context, index) {
                            return const TBrandItemCount();
                          }),
                    ],
                  ),
                ),
                /// tab bar design
                bottom: const TTabbar(
                  tabs: [
                    Tab(child: Text('Soldering Iron')),
                    Tab(child: Text('Screwdriver')),
                    Tab(child: Text('Stands')),
                    Tab(child: Text('Flux')),
                    Tab(child: Text('Rosin')),
                  ],
                )
              )
            ];
          },
          body:  TabBarView(children: [
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(Sizes.md),
                  child: Column(
                    children: [
                      ///-Brands
                      const TBrandShowcase(images: [Images.defaultWooPlaceholder, Images.defaultWooPlaceholder, Images.defaultWooPlaceholder],),
                      ///-Products
                      const TSectionHeading(title: 'You might like'),
                      const SizedBox(height: Sizes.spaceBtwItems,),
                      GridLayout(mainAxisExtent: 290,itemCount: 6, itemBuilder: (context, index) => ProductCard(product: controller.featuredProducts[index], pageSource: '',))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Sizes.md),
                  child: Column(
                    children: [
                      ///-Brands
                      const TBrandShowcase(images: [Images.defaultWooPlaceholder, Images.defaultWooPlaceholder, Images.defaultWooPlaceholder],),
                      ///-Products
                      const TSectionHeading(title: 'You might like'),
                      const SizedBox(height: Sizes.spaceBtwItems,),
                      GridLayout(mainAxisExtent: 290, itemCount: 6, itemBuilder: (context, index) => ProductCard(product: controller.featuredProducts[index], pageSource: '',))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Sizes.md),
                  child: Column(
                    children: [
                      ///-Brands
                      const TBrandShowcase(images: [Images.defaultWooPlaceholder, Images.defaultWooPlaceholder, Images.defaultWooPlaceholder],),
                      ///-Products
                      const TSectionHeading(title: 'You might like'),
                      const SizedBox(height: Sizes.spaceBtwItems,),
                      GridLayout(mainAxisExtent: 290, itemCount: 6, itemBuilder: (context, index) => ProductCard(product: controller.featuredProducts[index], pageSource: '',))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Sizes.md),
                  child: Column(
                    children: [
                      ///-Brands
                      const TBrandShowcase(images: [Images.defaultWooPlaceholder, Images.defaultWooPlaceholder, Images.defaultWooPlaceholder],),
                      ///-Products
                      const TSectionHeading(title: 'You might like'),
                      const SizedBox(height: Sizes.spaceBtwItems,),
                      GridLayout( mainAxisExtent: 290, itemCount: 6, itemBuilder: (context, index) => ProductCard(product: controller.featuredProducts[index], pageSource: '',))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(Sizes.md),
                  child: Column(
                    children: [
                      ///-Brands
                      const TBrandShowcase(images: [Images.defaultWooPlaceholder, Images.defaultWooPlaceholder, Images.defaultWooPlaceholder],),
                      ///-Products
                      const TSectionHeading(title: 'You might like'),
                      const SizedBox(height: Sizes.spaceBtwItems,),
                      GridLayout(mainAxisExtent: 290, itemCount: 6, itemBuilder: (context, index) => ProductCard(product: controller.featuredProducts[index], pageSource: '',))
                    ],
                  ),
                ),
              ],
            )
          ],
          ),
        ),
      ),
    );
  }
}




