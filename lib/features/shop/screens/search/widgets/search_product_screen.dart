import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/layout_models/product_grid_layout.dart';
import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/text/section_heading.dart';
import '../../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../controllers/search_controller/search_controller.dart';
import '../../products/scrolling_products.dart';

class SearchProductScreen extends StatelessWidget {
  const SearchProductScreen({super.key, required this.title, required this.searchQuery, this.orientation = OrientationType.vertical});

  final OrientationType orientation;
  final String title;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('search_screen');

    final ScrollController scrollController = ScrollController();
    final searchController = Get.put(SearchQueryController());
    // searchController.searchQuery.value = searchQuery;

    // Schedule the search refresh to occur after the current frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!searchController.isLoading.value) {
        searchController.refreshSearch(searchQuery);
      }
    });

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!searchController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (searchController.products.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          searchController.isLoadingMore(true);
          searchController.currentPage++; // Increment current page
          await searchController.getProductsBySearchQuery(searchQuery);
          searchController.isLoadingMore(false);
        }
      }
    });

    return RefreshIndicator(
      color: TColors.refreshIndicator,
      onRefresh: () async => searchController.refreshSearch(searchQuery),
      child: ListView(
        controller: scrollController,
        padding: TSpacingStyle.defaultPagePadding,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          TSectionHeading(title: title),
          ProductGridLayout(controller: searchController, orientation: orientation, sourcePage: 'Search',),
        ],
      ),
    );
  }
}
