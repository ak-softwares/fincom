import 'package:fincom/common/widgets/shimmers/customers_voucher_shimmer.dart';
import 'package:fincom/features/shop/screen_account/payments/widget/payment_tile_simmer.dart';
import 'package:fincom/features/shop/screen_account/vendor/widget/vendor_tile_simmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/layout_models/customers_grid_layout.dart';
import '../../../../../../common/layout_models/orders_grid_layout.dart';
import '../../../../../../common/layout_models/product_grid_layout.dart';
import '../../../../../../common/styles/spacing_style.dart';
import '../../../../../../common/text/section_heading.dart';
import '../../../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../../../common/widgets/product/product_voucher/product_voucher_card.dart';
import '../../../../../../common/widgets/shimmers/product_voucher_shimmer.dart';
import '../../../../../../common/widgets/tiles/Customers/customer_tile.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../controller_account/search_controller/search_controller.dart';
import '../../../../models/product_model.dart';
import '../../../../screens/products/scrolling_products.dart';
import '../../../payments/widget/payment_tile.dart';
import '../../../search/search.dart';
import '../../../vendor/widget/vendor_tile.dart';

class SearchScreen3 extends StatelessWidget {
  const SearchScreen3({
    super.key,
    required this.title,
    required this.searchQuery,
    this.orientation = OrientationType.horizontal,
    required this.searchType,
    this.selectedItems,
  });

  final OrientationType orientation;
  final String title;
  final String searchQuery;
  final SearchType searchType;
  final dynamic selectedItems;

  @override
  Widget build(BuildContext context) {

    final ScrollController scrollController = ScrollController();
    final searchVoucherController = Get.put(SearchVoucherController());

    // Schedule the search refresh to occur after the current frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!searchVoucherController.isLoading.value) {
        searchVoucherController.refreshSearch(query: searchQuery, searchType: searchType);
      }
    });

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!searchVoucherController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (searchVoucherController.products.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          searchVoucherController.isLoadingMore(true);
          searchVoucherController.currentPage++; // Increment current page
          await searchVoucherController.getItemsBySearchQuery(query: searchQuery, searchType: searchType, page: searchVoucherController.currentPage.value);
          searchVoucherController.isLoadingMore(false);
        }
      }
    });

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
        child: ElevatedButton(
            onPressed: () => searchVoucherController.confirmSelection(context: context, searchType: searchType),
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Done '),
                Text(searchVoucherController.getItemsCount(searchType: searchType).toString())
              ],
            )),
        ),
      ),
      body: RefreshIndicator(
        color: TColors.refreshIndicator,
        onRefresh: () async => searchVoucherController.refreshSearch(query: searchQuery, searchType: searchType),
        child: ListView(
          controller: scrollController,
          padding: TSpacingStyle.defaultPagePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            TSectionHeading(title: title),
            switch (searchType) {
              SearchType.products => Obx(() {
                    if (searchVoucherController.isLoading.value) {
                      return  ProductVoucherShimmer(itemCount: 2, orientation: orientation);
                    } else if(searchQuery.isEmpty) {
                        final products = searchVoucherController.selectedProducts;
                        return GridLayout(
                          itemCount: searchVoucherController.selectedProducts.length,
                          crossAxisCount: 1,
                          mainAxisExtent: Sizes.productVoucherTileHeight,
                          itemBuilder: (context, index) {
                            if (index < products.length) {
                              return Obx(() {
                                final product = searchVoucherController.selectedProducts[index];
                                final isSelected = searchVoucherController.selectedProducts.contains(product);
                                return Stack(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: ProductVoucherCard(
                                        product: products[index],
                                        orientation: orientation,
                                        onTap: () => searchVoucherController.toggleProductSelection(product),
                                      ),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Icon(Icons.check_circle,
                                            color: Colors
                                                .blue), // Selection indicator
                                      ),
                                  ],
                                );
                              });
                            } else {
                              return ProductVoucherShimmer(orientation: orientation);
                            }
                          }
                      );
                    } else if(searchVoucherController.products.isEmpty) {
                      return const TAnimationLoaderWidgets(text: 'Whoops! No products found...', animation: Images.pencilAnimation);
                    } else {
                      final products = searchVoucherController.products;
                      return GridLayout(
                          itemCount: searchVoucherController.isLoadingMore.value ? products.length + 2 : products.length,
                          crossAxisCount: orientation == OrientationType.vertical ? 2 : 1,
                          mainAxisExtent: orientation == OrientationType.vertical ? Sizes.productCardVerticalHeight : Sizes.productVoucherTileHeight,
                          itemBuilder: (context, index) {
                            if (index < products.length) {
                              return Obx(() {
                                final product = searchVoucherController.products[index];
                                final isSelected = searchVoucherController.selectedProducts.contains(product);
                                return Stack(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: ProductVoucherCard(
                                        product: products[index],
                                        orientation: orientation,
                                        onTap: () => searchVoucherController.toggleProductSelection(product),
                                      ),
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Icon(Icons.check_circle,
                                            color: Colors
                                                .blue), // Selection indicator
                                      ),
                                  ],
                                );
                              });
                            } else {
                              return ProductVoucherShimmer(orientation: orientation);
                            }
                          }
                      );
                    }
                  }),
              SearchType.customers => CustomersGridLayout(
                controller: searchVoucherController,
                sourcePage: 'Search',
              ),
              SearchType.orders => OrdersGridLayout(
                controller: searchVoucherController,
                sourcePage: 'Search',
              ),
              SearchType.vendor => Obx(() {
                const double vendorTileHeight = Sizes.vendorTileHeight; // Updated constant
                if (searchVoucherController.isLoading.value) {
                  return VendorTileSimmer(itemCount: 2);
                } else if(searchQuery.isEmpty) {
                  return searchVoucherController.selectedVendor.value.company != null
                      ? Obx(() {
                          final vendor = searchVoucherController.selectedVendor.value;
                          return Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: InkWell(
                                  onTap: () => searchVoucherController.toggleVendorSelection(vendor),
                                  child: VendorTile(
                                    vendor: vendor,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Icon(Icons.check_circle,
                                    color: Colors
                                        .blue), // Selection indicator
                              ),
                            ],
                          );
                        })
                      : SizedBox.shrink();
                } else if(searchVoucherController.vendors.isEmpty) {
                  return const TAnimationLoaderWidgets(text: 'Whoops! No Vendor found...', animation: Images.pencilAnimation);
                } else {
                  final vendors = searchVoucherController.vendors;
                  return GridLayout(
                      itemCount: searchVoucherController.isLoadingMore.value ? vendors.length + 2 : vendors.length,
                      crossAxisCount: 1,
                      mainAxisExtent: vendorTileHeight,
                      itemBuilder: (context, index) {
                        if (index < vendors.length) {
                          return Obx(() {
                            final vendor = searchVoucherController.vendors[index];
                            final isSelected = searchVoucherController.vendors.contains(searchVoucherController.selectedVendor.value);
                            return Stack(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: VendorTile(
                                    vendor: vendor,
                                    onTap: () => searchVoucherController.toggleVendorSelection(vendor),
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Icon(Icons.check_circle,
                                        color: Colors
                                            .blue), // Selection indicator
                                  ),
                              ],
                            );
                          });
                        } else {
                          return VendorTileSimmer();
                        }
                      }
                  );
                }
              }),
              SearchType.paymentMethod => Obx(() {
                const double paymentTileHeight = Sizes.paymentTileHeight; // Updated constant
                if (searchVoucherController.isLoading.value) {
                  return  PaymentTileSimmer(itemCount: 2);
                } else if(searchQuery.isEmpty) {
                  return searchVoucherController.selectedPayment.value.paymentMethodName != null
                      ? Obx(() {
                          final selectedPayment = searchVoucherController.selectedPayment.value;
                          return Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: PaymentMethodTile(
                                  payment: selectedPayment,
                                  onTap: () => searchVoucherController.togglePaymentSelection(selectedPayment),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Icon(Icons.check_circle, color: Colors.blue), // Selection indicator
                              ),
                            ],
                          );
                        })
                      : SizedBox.shrink();
                } else if(searchVoucherController.payments.isEmpty) {
                  return const TAnimationLoaderWidgets(text: 'Whoops! No Payment Method Method found...', animation: Images.pencilAnimation);
                } else {
                  final payments = searchVoucherController.payments;
                  return GridLayout(
                      itemCount: searchVoucherController.isLoadingMore.value ? payments.length + 2 : payments.length,
                      crossAxisCount: 1,
                      mainAxisExtent: paymentTileHeight,
                      itemBuilder: (context, index) {
                        if (index < payments.length) {
                          return Obx(() {
                            final payment = searchVoucherController.payments[index];
                            final isSelected = searchVoucherController.payments.contains(searchVoucherController.selectedPayment.value);
                            return Stack(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: InkWell(
                                    onTap: () => searchVoucherController.togglePaymentSelection(payment),
                                      child: PaymentMethodTile(payment: payment)
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Icon(Icons.check_circle, color: Colors.blue), // Selection indicator
                                  ),
                              ],
                            );
                          });
                        } else {
                          return PaymentTileSimmer();
                        }
                      }
                  );
                }
              }),
            }
          ],
        ),
      ),
    );
  }
}