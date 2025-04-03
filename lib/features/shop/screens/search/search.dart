import 'package:fincom/features/shop/screen_account/search/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/local_storage_constants.dart';
import '../../../../utils/constants/sizes.dart';
import '../products/scrolling_products.dart';
import 'widgets/empty_search_screen.dart';
import 'widgets/search_product_screen.dart';

class TSearchDelegate extends SearchDelegate {

  RxList<String> recentlySearches = <String>[].obs;
  RxList<String> suggestionList = RxList<String>(); // Observable for suggestion list

  final localStorage = GetStorage();

  @override
  String? get searchFieldLabel => 'Search Product..';

  TSearchDelegate() {
    recentlySearches.value  = _getRecentSearches(); // Call this in the constructor to initialize searches
  }

  // Add this property to customize the search text field style
  @override
  TextStyle? get searchFieldStyle => const TextStyle(
    fontSize: 15, // Customize font size
    fontWeight: FontWeight.w500,
    color: AppColors.secondaryColor, // Customize font color
  );


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear, color: Colors.black),
          onPressed: () {
            query = '';
          }
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black,),
        onPressed: () {
          close(context, null);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // FBAnalytics.logViewSearchResults(searchTerm: query, resultsCount: '');
    _saveSearchQuery(query);
    return SearchScreen(
        title: 'Search result for ${query.isEmpty ? '' : '"$query"'}',
        searchQuery: query,
        orientation: OrientationType.vertical,
        searchType: SearchType.products,
    );
  }

  // Call this function whenever `query` changes
  void onQueryChanged(String query) {
    _updateSuggestionList(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty && query.length >= 3) {
      FBAnalytics.logSearch(searchTerm: query); // Log search only when query length is >= 3
      return SearchScreen(
        title: 'Search result for ${query.isEmpty ? '' : '"$query"'}',
        searchQuery: query,
        orientation: OrientationType.horizontal,
        searchType: SearchType.products,
      );
    }
    return SingleChildScrollView(
      child: Obx(() {
        _updateSuggestionList(query);
        return Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  recentlySearches.isNotEmpty && suggestionList.isNotEmpty
                      ? GridLayout(
                        mainAxisSpacing: 0,
                        mainAxisExtent: 35,
                        itemCount: suggestionList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            dense: true, // Reduce default padding inside ListTile
                            leading: const Icon(Icons.history, color: AppColors.black, size: 18),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, color: AppColors.black, size: 18),
                              onPressed: () => _removeSearch(suggestionList[index]),
                            ),
                            title: Text(
                              suggestionList[index],
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: const Color(0xFF1A0DAB),
                              ),
                            ),
                            onTap: () {
                              query = suggestionList[index];
                              showResults(context);
                            },
                          );
                        },
                      )
                      : SizedBox.shrink(),
                  EmptySearchScreen(),
                ],
              );
      })
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        // iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        titleTextStyle: theme.textTheme.titleLarge,
        toolbarTextStyle: theme.textTheme.bodyMedium,
      ),
      primaryColor: AppColors.primaryColor,
      inputDecorationTheme: searchFieldDecorationTheme ??
          InputDecorationTheme(
            hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: AppSizes.xs, horizontal: AppSizes.md), // Define input field height
            // fillColor: Colors.grey.shade200, // Customize the background color
            // filled: true, // Ensure the fill color is applied
            // hintStyle: const TextStyle(
            //   fontSize: 15, // Customize hint text font size
            //   color: Colors.grey, // Customize hint text color
            // ),

            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.blue, // Customize the border color when enabled
            //     width: 2.0, // Customize the border width
            //   ),
            //   borderRadius: BorderRadius.all(Radius.circular(TSizes.sm)), // Optional: Customize the border radius
            // ),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.green, // Customize the border color when focused
            //     width: 2.0, // Customize the border width
            //   ),
            //   borderRadius: BorderRadius.all(Radius.circular(TSizes.sm))
            // ),
            // border: const OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.transparent, // Customize the default border color
            //     width: 1.0, // Customize the default border width
            //   ),
            //   borderRadius: BorderRadius.all(Radius.circular(TSizes.sm))
            // ),
          ),
    );
  }

  void _saveSearchQuery(String searchQuery) {
    if (searchQuery.isEmpty) return;

    List<String> getSearches = localStorage.read(LocalStorage.searches)?.cast<String>() ?? [];

    if (!getSearches.contains(searchQuery)) {
      recentlySearches.add(searchQuery);
      localStorage.write(LocalStorage.searches, recentlySearches); // save data in Local Storage
    }
  }

  List<String> _getRecentSearches() {
    List<String> getSearches = localStorage.read(LocalStorage.searches)?.cast<String>() ?? [];
    return getSearches;
  }

  void _removeSearch(String searchQuery) {
    // Remove the query from the list
    recentlySearches.remove(searchQuery);
    // Update local storage
    localStorage.write(LocalStorage.searches, recentlySearches);
  }

  void _updateSuggestionList(String query) {
    if (query.isEmpty) {
      suggestionList.value = recentlySearches.reversed.take(5).toList();
    } else {
      suggestionList.value = recentlySearches.reversed.where((search) => search.toLowerCase().contains(query.toLowerCase())).take(5).toList();
    }
  }

}