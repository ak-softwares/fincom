import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/product_list_layout.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/shimmers/brand_shimmer.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/brand_controller/brand_controller.dart';
import '../products/scrolling_products.dart';
import 'all_brands.dart';
import 'brand_tap_bar.dart';
import 'widgets/single_brand_tile.dart';

class ScrollingBrandsImage extends StatelessWidget {
  const ScrollingBrandsImage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final productBrandController = Get.put(BrandController());

    final double brandImageHeight = AppSizes.brandImageHeight;
    final double brandTileHeight = AppSizes.brandTileHeight;

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!productBrandController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          int itemsPerPage = int.parse(APIConstant.itemsPerPage); // Number of items per page
          if (productBrandController.productBrands.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          productBrandController.isLoadingMore(true);
          productBrandController.currentPage++; // Increment current page
          await productBrandController.getAllBrands();
          productBrandController.isLoadingMore(false);
        }
      }
    });

    return Obx(() {
      if (productBrandController.isLoading.value){
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: AppSizes.spaceBtwItems),
              child: TSectionHeading(title: 'Brands Loading...', seeActionButton: true, onPressed: () => Get.to(() => const AllBrandScreen())),
            ),
            BrandTileShimmer(itemCount: 4, orientation: OrientationType.horizontal),
          ],
        );
      } else if(productBrandController.productBrands.isEmpty) {
        return const SizedBox.shrink();
      } else {
        final brands = productBrandController.productBrands;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: AppSizes.spaceBtwItems),
              child: TSectionHeading(title: 'Shop by Brands', seeActionButton: true, onPressed: () => Get.to(() => const AllBrandScreen())),
            ),
            ListLayout(
              height: brandTileHeight,
              controller: scrollController,
              itemCount: productBrandController.isLoadingMore.value ? brands.length + 2 : brands.length,
              itemBuilder: (context, index) {
                if (index < brands.length) {
                  final brand = brands[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: AppSizes.defaultBtwTiles, top: AppSizes.defaultBtwTiles),
                    child: SingleBrandTile(
                        title: brand.name ?? '',
                        image: brand.image ?? '',
                        onTap: () => Get.to(BrandTapBarScreen(brandID: brand.id ?? 0))
                    ),
                  );
                } else {
                  return BrandTileShimmer(itemCount: 1, orientation: OrientationType.horizontal);
              }
              },
            ),
          ],
        );
      }
    });
  }
}
