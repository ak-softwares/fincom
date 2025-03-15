import 'package:fincom/features/shop/screen_account/purchase/purchase_entry/widget/search_product_screen3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../../common/layout_models/product_grid_layout.dart';
import '../../../../../../data/repositories/mongodb/products/product_repositories.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/local_storage_constants.dart';
import '../../../../controller_account/search_controller/search_controller.dart';
import '../../../../models/product_model.dart';
import '../../../../screens/products/scrolling_products.dart';
import '../../../../screens/search/widgets/search_product_screen.dart';
import '../../../search/search.dart';

class SearchVoucher1 extends SearchDelegate {
  RxList<String> recentlySearches = <String>[].obs;
  RxList<String> suggestionList = RxList<String>(); // Observable for suggestion list

  final localStorage = GetStorage();
  final SearchType searchType; // Enum to differentiate search types
  final dynamic selectedItems; // Enum to differentiate search types

  @override
  String? get searchFieldLabel => 'Search ${_getSearchLabel()}...';

  SearchVoucher1({required this.searchType, this.selectedItems}) {
    recentlySearches.value = _getRecentSearches(); // Initialize searches
  }

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: TColors.primaryColor,
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.black),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }


  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _saveSearchQuery(query);
    return _buildSearchResults(context: context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context: context);
    // if (query.isNotEmpty && query.length >= 3) {
    //   return _buildSearchResults(context: context);
    // }

    // return SingleChildScrollView(
    //   child: Obx(() {
    //     _updateSuggestionList(query);
    //     return recentlySearches.isNotEmpty && suggestionList.isNotEmpty
    //         ? GridLayout(
    //             mainAxisSpacing: 0,
    //             mainAxisExtent: 35,
    //             itemCount: suggestionList.length,
    //             itemBuilder: (BuildContext context, int index) {
    //               return ListTile(
    //                 dense: true,
    //                 leading: const Icon(Icons.history, color: TColors.black, size: 18),
    //                 trailing: IconButton(
    //                   icon: const Icon(Icons.close, color: TColors.black, size: 18),
    //                   onPressed: () => _removeSearch(suggestionList[index]),
    //                 ),
    //                 title: Text(
    //                   suggestionList[index],
    //                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
    //                     color: const Color(0xFF1A0DAB),
    //                   ),
    //                 ),
    //                 onTap: () {
    //                   query = suggestionList[index];
    //                   showResults(context);
    //                 },
    //               );
    //             },
    //           )
    //         : const SizedBox.shrink();
    //   }),
    // );
  }

  Widget _buildSearchResults({required BuildContext context}) {
    return SearchScreen3(
      title: 'Search result for ${query.isEmpty ? '' : '"$query"'}',
      searchQuery: query,
      searchType: searchType,
      orientation: OrientationType.horizontal,
      selectedItems: selectedItems,
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: TColors.primaryBackground,
        titleTextStyle: theme.textTheme.titleLarge,
        toolbarTextStyle: theme.textTheme.bodyMedium,
      ),
      primaryColor: TColors.primaryColor,
    );
  }

  void _saveSearchQuery(String searchQuery) {
    if (searchQuery.isEmpty) return;
    List<String> getSearches = localStorage.read(LocalStorage.searches)?.cast<String>() ?? [];
    if (!getSearches.contains(searchQuery)) {
      recentlySearches.add(searchQuery);
      localStorage.write(LocalStorage.searches, recentlySearches);
    }
  }

  List<String> _getRecentSearches() {
    return localStorage.read(LocalStorage.searches)?.cast<String>() ?? [];
  }

  void _removeSearch(String searchQuery) {
    recentlySearches.remove(searchQuery);
    localStorage.write(LocalStorage.searches, recentlySearches);
  }

  void _updateSuggestionList(String query) {
    if (query.isEmpty) {
      suggestionList.value = recentlySearches.reversed.take(5).toList();
    } else {
      // Fetch suggestions based on search type
      List<String> searchResults;
      switch (searchType) {
        case SearchType.products:
          searchResults = _fetchProductSuggestions(query);
          break;
        case SearchType.customers:
          searchResults = _fetchCustomerSuggestions(query);
          break;
        case SearchType.orders:
          searchResults = _fetchUserSuggestions(query);
          break;
        case SearchType.vendor:
          // TODO: Handle this case.
          throw UnimplementedError();
        case SearchType.paymentMethod:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
      suggestionList.value = searchResults.take(5).toList();
    }
  }

  List<String> _fetchProductSuggestions(String query) {
    // Replace with actual product search logic
    return ['Product A', 'Product B', 'Product C'].where((p) => p.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<String> _fetchCustomerSuggestions(String query) {
    // Replace with actual customer search logic
    return ['John Doe', 'Jane Smith', 'Customer X'].where((c) => c.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<String> _fetchUserSuggestions(String query) {
    // Replace with actual user search logic
    return ['User1', 'User2', 'User3'].where((u) => u.toLowerCase().contains(query.toLowerCase())).toList();
  }

  String _getSearchLabel() {
    switch (searchType) {
      case SearchType.products:
        return 'Product';
      case SearchType.customers:
        return 'Customer';
      case SearchType.orders:
        return 'User';
      case SearchType.vendor:
        return 'Vendor';
      case SearchType.paymentMethod:
        return 'Payment Method';
    }
  }
}
