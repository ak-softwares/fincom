import 'package:fincom/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:fincom/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

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

class ProductsVoucher extends StatelessWidget {
  const ProductsVoucher({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final productsVoucherController = Get.put(ProductsVoucherController());

    productsVoucherController.refreshProducts();

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!productsVoucherController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (productsVoucherController.products.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          productsVoucherController.isLoadingMore(true);
          productsVoucherController.currentPage++; // Increment current page
          await productsVoucherController.getAllProducts();
          productsVoucherController.isLoadingMore(false);
        }
      }
    });

    final Widget emptyWidget = TAnimationLoaderWidgets(
      text: 'Whoops! No Products Found...',
      animation: Images.pencilAnimation,
    );
    return Scaffold(
        appBar: const AppAppBar2(titleText: 'Products Voucher', searchType: SearchType.products),
        body: RefreshIndicator(
          color: TColors.refreshIndicator,
          onRefresh: () async => productsVoucherController.refreshProducts(),
          child: ListView(
            controller: scrollController,
            padding: TSpacingStyle.defaultPagePadding,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Obx(() => productsVoucherController.isSyncing.value
                  ? TRoundedContainer(
                      showBorder: true,
                      radius: 4,
                      borderColor: Colors.black,
                      padding: EdgeInsets.symmetric(horizontal: Sizes.xl),
                      child: Row(
                          spacing: Sizes.spaceBtwItems,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                            Column(
                              children: [
                                Text('Syncing ${productsVoucherController.totalProcessedProducts}/${productsVoucherController.wooProductsCount}', style: TextStyle(fontSize: 13),),
                                Text('New Products Found ${productsVoucherController.processedProducts}', style: TextStyle(fontSize: 13)),
                              ],
                            ),
                            IconButton(
                                onPressed: productsVoucherController.stopSyncing, // Stop button
                                icon: Icon(Iconsax.close_circle, color: TColors.error)
                            )
                          ],
                        ),
                    )
                  : OutlinedButton(
                      onPressed: productsVoucherController.syncProducts,
                      child: Text('Sync Products'),
                    )),
              SizedBox(height: Sizes.spaceBtwItems),
              Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('Woocommerce count'),
                        productsVoucherController.isGettingCount.value
                            ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator())
                            : Text(productsVoucherController.wooProductsCount.value.toString())
                      ],
                    ),
                    Column(
                      children: [
                        Text('Fincom count'),
                        productsVoucherController.isGettingCount.value
                            ? SizedBox(height: 15, width: 15, child: CircularProgressIndicator())
                            : Text(productsVoucherController.fincomProductsCount.value.toString())
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: Sizes.spaceBtwItems),
              ProductGridLayout(controller: productsVoucherController, orientation: OrientationType.horizontal, emptyWidget: emptyWidget, sourcePage: 'recently_view',),
            ],
          ),
        )
    );
  }
}


