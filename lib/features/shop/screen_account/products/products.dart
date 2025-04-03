import 'package:fincom/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:fincom/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:line_icons/line_icons.dart';

import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../controller_account/product/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../screens/products/scrolling_products.dart';
import '../search/search.dart';
import 'add_product.dart';
import 'widget/product_shimmer.dart';
import 'widget/product_tile.dart';

class ProductsVoucher extends StatelessWidget {
  const ProductsVoucher({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final controller = Get.put(ProductsVoucherController());

    controller.refreshProducts();

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!controller.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (controller.products.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          controller.isLoadingMore(true);
          controller.currentPage++; // Increment current page
          await controller.getAllProducts();
          controller.isLoadingMore(false);
        }
      }
    });

    final Widget emptyWidget = TAnimationLoaderWidgets(
      text: 'Whoops! No Products Found...',
      animation: Images.pencilAnimation,
    );

    return Scaffold(
        appBar: AppAppBar2(
            titleText: 'Products',
            searchType: SearchType.products,
            widget: Obx(() => controller.isSyncing.value
                  ? TextButton(
                      onPressed: () => controller.stopSyncing(),
                      child: Row(
                        spacing: AppSizes.sm,
                        children: [
                          SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.linkColor,strokeWidth: 2,)),
                          Text('Stop', style: TextStyle(color: AppColors.linkColor),),
                        ],
                      ),
                    )
                  : TextButton(
                      onPressed: () => controller.syncProducts(),
                      child: Text('Sync', style: TextStyle(color: AppColors.linkColor),),
                    ))
        ),
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: Colors.blue,
          onPressed: () => Get.to(() => AddProducts()),
          tooltip: 'Add Products',
          child: Icon(LineIcons.plus, size: 30, color: Colors.white,),
        ),
        body: RefreshIndicator(
          color: AppColors.refreshIndicator,
          onRefresh: () async => controller.refreshProducts(),
          child: ListView(
            controller: scrollController,
            padding: TSpacingStyle.defaultPagePadding,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // Obx(() => Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Column(
              //         children: [
              //           Text('Woocommerce count'),
              //           productsVoucherController.isGettingCount.value
              //               ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator())
              //               : Text(productsVoucherController.wooProductsCount.value.toString())
              //         ],
              //       ),
              //       Column(
              //         children: [
              //           Text('Fincom count'),
              //           productsVoucherController.isGettingCount.value
              //               ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator())
              //               : Text(productsVoucherController.fincomProductsCount.value.toString())
              //         ],
              //       )
              //     ],
              //   )),
              // SizedBox(height: Sizes.spaceBtwItems),
              Obx(() {
                if (controller.isLoading.value) {
                    return  ProductTileShimmer(itemCount: 2);
                } else if(controller.products.isEmpty) {
                    return emptyWidget;
                } else {
                  final products = controller.products;
                  return GridLayout(
                    itemCount: controller.isLoadingMore.value ? products.length + 2 : products.length,
                    crossAxisCount:  1,
                    mainAxisExtent: AppSizes.productVoucherTileHeight,
                    itemBuilder: (context, index) {
                      if (index < products.length) {
                        return ProductTile(product: products[index]);
                      } else {
                        return ProductTileShimmer();
                      }
                    }
                  );
                }
              })
            ],
          ),
        )
    );
  }
}


