import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/loaders/loader.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../services/share/share.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../models/product_model.dart';

class TabviewProducts extends StatefulWidget {
  const TabviewProducts({
    super.key,
    this.itemUrl = '',
    this.itemName = '',
    required this.itemID,
    required this.futureMethod,
  });

  final String itemID;
  final String itemName;
  final String? itemUrl;
  final Future<List<ProductModel>> Function(String, String) futureMethod;

  @override
  _TabviewProductsState createState() => _TabviewProductsState();
}

class _TabviewProductsState extends State<TabviewProducts> {
  late final ScrollController _scrollController;
  final RxInt currentPage = 1.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _refreshAllProducts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getAllProducts() async {
    try {
      final List<ProductModel> newProducts = await widget.futureMethod(widget.itemID ?? '', currentPage.toString());
      products.addAll(newProducts);
    } catch (e) {
      throw TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> _refreshAllProducts() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      products.clear(); // Clear existing orders
      await _getAllProducts();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  void _scrollListener() async {
    if (_scrollController.position.extentAfter < 0.2 * _scrollController.position.maxScrollExtent) {
      if (!isLoadingMore.value) {
        isLoadingMore(true);
        final int itemsPerPage = int.parse(APIConstant.itemsPerPage); // Number of items per page
        if (products.length % itemsPerPage != 0) {
          isLoadingMore(false);
          return; // Stop fetching
        }
        currentPage.value++; // Increment current page
        await _getAllProducts();
        isLoadingMore(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.refreshIndicator,
      onRefresh: () async => _refreshAllProducts(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        padding: TSpacingStyle.defaultPagePadding,
        children: [
          Align(
            alignment: Alignment.centerRight, // Float the InkWell to the left
            child: InkWell(
              onTap: () => AppShare.shareUrl(
                  url: widget.itemUrl ?? '',
                  contentType: 'tap_bar',
                  itemName: widget.itemName,
                  itemId:  widget.itemID.toString()
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Shrink-wrap the Row's width to its content
                children: [
                  Text('Share',
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.linkColor)
                  ),
                  SizedBox(width: AppSizes.sm),
                  Icon(
                    TIcons.share,
                    size: AppSizes.md,
                    color: AppColors.linkColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSizes.sm),
          ProductGridLayout(controller: this, sourcePage: 'Tab_${widget.itemName}'),
        ],
      ),
    );
  }
}
