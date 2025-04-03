import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/layout_models/product_list_layout.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/product/product_cards/product_card.dart';
import '../../../../common/widgets/shimmers/product_shimmer.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/sizes.dart';
import '../../models/product_model.dart';
import '../all_products/all_products.dart';

enum OrientationType { horizontal, vertical }

class ScrollingProducts extends StatefulWidget {
  final String title;
  final OrientationType orientation;
  final Future<List<ProductModel>> Function(String) futureMethod;

  const ScrollingProducts({
    super.key,
    required this.title,
    required this.futureMethod,
    this.orientation = OrientationType.vertical, // Default value
  });

  @override
  _ScrollingProductsState createState() => _ScrollingProductsState();

}

class _ScrollingProductsState extends State<ScrollingProducts> {
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
    refreshAllProducts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getAllProducts() async {
    try {
      // final List<ProductModel> newProducts = await Isolate.run(() => widget.futureMethod(_currentPage.toString()));
      final List<ProductModel> newProducts = await widget.futureMethod(currentPage.toString());
      products.addAll(newProducts);
    } catch (e) {
      throw TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> refreshAllProducts() async {
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
    return Obx(() {
      if (isLoading.value){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: AppSizes.spaceBtwItems),
              child: TSectionHeading(title: 'Products Loading..'),
            ),
            Padding(
                padding: EdgeInsets.all(AppSizes.defaultSpaceBWTCard / 2),
                child: ProductShimmer(
                  itemCount: widget.orientation == OrientationType.horizontal ? 1 : 2,
                  crossAxisCount: widget.orientation == OrientationType.horizontal ? 1 : 2,
                  orientation: widget.orientation,
                )
            ),
          ],
        );
      } else if (products.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: AppSizes.spaceBtwItems),
              child: TSectionHeading(
                title: widget.title,
                seeActionButton: true,
                verticalPadding: true,
                onPressed: () => Get.to(() => TAllProducts(title: widget.title, futureMethod: widget.futureMethod)),
              ),
            ),
            ListLayout(
              height: widget.orientation == OrientationType.vertical
                  ? AppSizes.productCardVerticalHeight + 10
                  : AppSizes.productCardHorizontalHeight + 10,
              controller: _scrollController,
              itemCount: isLoadingMore.value ? products.length + 1 : products.length,
              itemBuilder: (context, index) {
                if (index < products.length) {
                  return Padding(
                    padding: EdgeInsets.all(AppSizes.defaultSpaceBWTCard / 2),
                    child: ProductCard(product: products[index], orientation: widget.orientation, pageSource: widget.title,),
                  );
                } else {
                  return Padding(
                      padding: EdgeInsets.all(AppSizes.defaultSpaceBWTCard / 2),
                      child: ProductShimmer(
                        itemCount: 1,
                        crossAxisCount: 1,
                        isLoading: true,
                        orientation: widget.orientation,
                      )
                  );
                }
              },
            ),
          ],
        );
      }
    });
  }
}

