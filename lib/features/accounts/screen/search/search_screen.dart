import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/customers_grid_layout.dart';
import '../../../../common/layout_models/orders_grid_layout.dart';
import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../controller/search_controller/search_controller.dart';
import '../../models/product_model.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    super.key,
    required this.title,
    required this.searchQuery,
    this.orientation = OrientationType.horizontal,
    required this.searchType,
    this.onProductTap,
  });

  final OrientationType orientation;
  final String title;
  final String searchQuery;
  final SearchType searchType;
  final ValueChanged<ProductModel>? onProductTap;

  @override
  Widget build(BuildContext context) {

    final ScrollController scrollController = ScrollController();
    final searchVoucherController = Get.put(SearchVoucherController());
    final Set<ProductModel> selectedProducts = {}; // Track selected products

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

      body: RefreshIndicator(
        color: AppColors.refreshIndicator,
        onRefresh: () async => searchVoucherController.refreshSearch(query: searchQuery, searchType: searchType),
        child: ListView(
          controller: scrollController,
          padding: AppSpacingStyle.defaultPagePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            TSectionHeading(title: title),
            switch (searchType) {
              SearchType.products => ProductGridLayout(
                controller: searchVoucherController,
                orientation: orientation,
                sourcePage: 'Search',
              ),
              SearchType.customers => CustomersGridLayout(
                controller: searchVoucherController,
                sourcePage: 'Search',
              ),
              SearchType.orders => OrdersGridLayout(
                controller: searchVoucherController,
                sourcePage: 'Search',
              ),
              // TODO: Handle this case.
              SearchType.vendor => throw UnimplementedError(),
              // TODO: Handle this case.
              SearchType.paymentMethod => throw UnimplementedError(),
            }
          ],
        ),
      ),
    );
  }
}