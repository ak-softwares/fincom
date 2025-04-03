import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/shimmers/single_product_shimmer.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../services/share/share.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../settings/app_settings.dart';
import '../../controllers/cart_controller/cart_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../../controllers/recently_viewed/recently_viewed_controller.dart';
import '../../models/product_attribute_model.dart';
import '../../models/product_model.dart';
import '../all_products/all_products.dart';
import 'scrolling_products.dart';
import 'scrolling_products_by_item_id.dart';
import '../review/product_review.dart';
import '../review/product_review_horizontal.dart';
import 'products_widgets/bottom_add_to_cart.dart';
import 'products_widgets/in_stock_label.dart';
import 'products_widgets/product_image_slider.dart';
import 'products_widgets/product_price.dart';
import 'products_widgets/sale_label.dart';

class ProductScreen extends StatefulWidget {
  ProductScreen({
    Key? key,
    this.product,
    this.slug,
    this.productId,
    this.pageSource = 'product_detail_screen',
  }) : super(key: key ?? UniqueKey());

  final ProductModel? product;
  final String? productId;
  final String? slug;
  final String pageSource;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingVariation = false.obs;
  final RxInt _quantityInCart = 1.obs;

  final Rx<ProductModel> _product = ProductModel.empty().obs;
  final Rx<ProductModel> _parentProduct = ProductModel.empty().obs;
  final RxList<ProductModel> _productVariations = RxList<ProductModel>();
  late List<ProductAttributeModel?> filteredAttributes = [];
  RxMap<String, String> selectedOptions = <String, String>{}.obs;
  final cartController = Get.put(CartController(), permanent: true);
  final productController = Get.put(ProductController(), permanent: true);

  @override
  void initState() {
    super.initState();
    // Initialize product
    _fetchProduct(product: widget.product, slug: widget.slug, productId: widget.productId);
  }

  @override
  void dispose() {
    _clearSelectedOptions();
    super.dispose(); // Call super to ensure proper cleanup
  }

  String _getVariationImage(String attribute, String option) {
    for (var product in _productVariations.value) {
      if (product.attributes != null) {
        // Loop through the product's attributes to find a match
        for (var attributeMap in product.attributes!) {
          // Check if both attribute and option match (case-insensitive)
          if (attributeMap.name?.toLowerCase() == attribute.toLowerCase() &&
              attributeMap.option?.toLowerCase() == option.toLowerCase()) {
            return product.image ?? ''; // Return the image if a match is found
          }
        }
      }
    }
    return '';
  }


  void _filterAttributes() {
    filteredAttributes = _product.value.attributes!
        .where((attribute) => attribute.variation ?? false)
        .toList();
  }

  void _clearSelectedOptions() {
    if(!_isProductVariable(_product.value)){
      return;
    }
    selectedOptions.clear();
    _product.update((prod) {
      prod?.name = _parentProduct.value.name;
      prod?.mainImage = _parentProduct.value.mainImage;
      prod?.images = _parentProduct.value.images;
      prod?.regularPrice = _parentProduct.value.regularPrice;
      prod?.salePrice = _parentProduct.value.salePrice;
      prod?.description = _parentProduct.value.description;
      prod?.stockStatus = _parentProduct.value.stockStatus;
    });
  }

  void _setDefaultVariation() {
    if (_product.value.defaultAttributes != null) {
      for (var defaultAttr in _product.value.defaultAttributes!) {
        _updateVariation(defaultAttr.name ?? '', defaultAttr.option ?? '');
      }
    }
  }

  bool _isProductVariable(ProductModel product) {
    return product.type == ProductFieldName.typeVariable && product.variations != null && product.variations!.isNotEmpty;
  }

  // Function to update the variation
  void _updateVariation(String attribute, String value) {
    selectedOptions[attribute.toLowerCase()] = value.toLowerCase();
    _updateProductAfterVariationSelected();
  }

  // Function to get the variation
  String? _getVariation(String attribute) {
    return selectedOptions[attribute];
  }

  bool _hasKeyValue(String key, String value) {
    return selectedOptions.containsKey(key.toLowerCase()) && selectedOptions[key.toLowerCase()] == value.toLowerCase();
  }

  ProductModel _getSelectedVariation() {
    return _productVariations.firstWhere((variation) =>
      variation.attributes != null && variation.attributes!.every((attr) =>
            selectedOptions.containsKey(attr.name?.toLowerCase()) && selectedOptions[attr.name?.toLowerCase()] == attr.option?.toLowerCase(),
          ),
      orElse: () => ProductModel.empty(),
    );
  }

  void _updateProductAfterVariationSelected() {
    final selectedVariation = _getSelectedVariation();
    if(selectedVariation.productId != 0) {
      // Creating a string with selected options dynamically
      String formattedOptions = selectedOptions.entries
          .map((entry) => '${entry.key.capitalizeFirst}: ${entry.value.capitalizeFirst}')
          .join(' , '); // Join with a comma separator
      _product.update((prod) {
        prod?.name = '${_parentProduct.value.name} - ($formattedOptions)';
        prod?.mainImage = selectedVariation.image;
        prod?.images = [{'src': selectedVariation.image}];
        prod?.regularPrice = selectedVariation.regularPrice;
        prod?.salePrice = selectedVariation.salePrice;
        prod?.description = selectedVariation.description;
        prod?.stockStatus = selectedVariation.stockStatus;
      });
    }
  }

  Future<void> _fetchProductVariations({required String parentID}) async {
    try {
      _isLoadingVariation(true);
      final List<ProductModel> productVariations = await productController.getVariationByProductsIds(parentID: parentID);
      _productVariations.value = productVariations;
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      _isLoadingVariation(false);
      _updateProductAfterVariationSelected();
    }
  }

  Future<void> _fetchProduct({ProductModel? product, String? slug, String? productId}) async {
    final ProductModel fetchedProduct;
    try {
      _isLoading(true);
      if (product != null) {
        fetchedProduct = product;
      } else if (slug != null) {
        final product = await productController.getProductBySlug(slug);
        fetchedProduct = product;
      } else if (productId != null) {
        final product = await productController.getProductById(productId);
        fetchedProduct = product;
      } else {
        throw Exception('Either product or productId must be provided.');
      }
      _product.value = fetchedProduct;
      if (_isProductVariable(_product.value)) {
        _parentProduct.value = fetchedProduct.copyWith();
      }
    } catch (e) {
      rethrow;
    } finally {
      _quantityInCart.value = cartController.getCartQuantity(_product.value.productId);
      // Check is product variable or not
      if (_isProductVariable(_product.value)) {
        String parentID = _product.value.productId.toString();
        _setDefaultVariation();
        _filterAttributes();
        _fetchProductVariations(parentID: parentID);
      }
      _isLoading(false); // Set loading state to false
    }
  }

  //Get products by Refresh page
  Future<void> _refreshProduct() async {
    final productId = _product.value.productId;
    try {
      _product.value = ProductModel.empty();
      await _fetchProduct(productId: productId.toString());
      // Check is product variable or not
      if (_product.value.type == "variable" && _product.value.variations != null && _product.value.variations!.isNotEmpty) {
        _productVariations.value = [ProductModel.empty()];
        String parentID = _product.value.productId.toString();
        _fetchProductVariations(parentID: parentID);
      }
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('product_screen');
    // Adding the product to recently viewed outside Obx's reactive context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_product.value.productId != 0) {
        RecentlyViewedController.instance.addRecentProduct(_product.value.productId.toString());
      }
    });

    return Scaffold(
      appBar: AppAppBar2(titleText: widget.product?.name ?? 'Product Details', showSearchIcon: true, showCartIcon: true),
      bottomNavigationBar: Obx(() => TBottomAddToCart(product: _product.value, quantity: _quantityInCart.value, variationId: _getSelectedVariation().productId, pageSource: widget.pageSource)),
      body: RefreshIndicator(
        color: AppColors.refreshIndicator,
        onRefresh: () async => _refreshProduct(),
        child: ListView(
          padding: TSpacingStyle.defaultPagePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Obx(() {
              if (_isLoading.value) {
                return const SingleProductShimmer();
              }
              if(_product.value.productId == 0) {
                return const TAnimationLoaderWidgets(
                  text: 'Whoops! No Product Found...',
                  animation: Images.pencilAnimation,
                );
              }
              FBAnalytics.logViewItem(product: _product.value);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //search bar
                  // const TSearchBar(searchText: TTexts.search),
                  // const Divider(),

                  // Product images
                  TProductImageSlider(product: _product.value),
                  const SizedBox(height: AppSizes.sm),
                  const Divider(),

                  // Title
                  SelectableText(_product.value.name ?? '', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)),
                  // const SizedBox(height: TSizes.sm),

                  // Category
                  InkWell(
                      onTap: () => Get.to(() => TAllProducts(
                              title: _product.value.categories?[0].name ?? '',
                              categoryId: _product.value.categories?[0].id ?? '',
                              sharePageLink: '${AppSettings.appName} - ${_product.value.categories?[0].permalink}',
                              futureMethodTwoString: productController.getProductsByCategoryId)
                          ),
                      // onTap: () => Get.to(CategoryTapBarScreen(categoryId: _product.value.categories?[0].id ?? '')),
                      child: Row(
                        children: [
                          Text(_product.value.categories?[0].name ?? '',
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.linkColor)
                          ),
                          SizedBox(width: AppSizes.sm,),
                          GestureDetector(
                            onTap: () => AppShare.shareUrl(
                                url: '${_product.value.categories?[0].permalink}',
                                contentType: 'Category',
                                itemName: _product.value.categories?[0].name ?? '',
                                itemId: _product.value.categories?[0].id ?? ''
                            ),
                            child: Icon(
                              TIcons.share,
                              size: AppSizes.md,
                              color: AppColors.linkColor,
                            ),
                          )
                        ],
                      )
                  ),
                  const SizedBox(height: AppSizes.sm),

                  // Brands
                  _product.value.brands != null && _product.value.brands!.isNotEmpty
                      ? Column(
                          children: [
                            Text(
                              _product.value.brands?.map((brand) => brand.name).join(', ') ?? '', // Join brand names with commas
                              style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: AppColors.linkColor),
                            ),
                            const SizedBox(height: AppSizes.sm),
                          ],
                        )
                      : SizedBox.shrink(),

                  // Price
                  Row(
                    children: [
                      TSaleLabel(discount: _product.value.calculateSalePercentage(), size: 13,),
                      // TOfferWidget(label: '${_product.value.calculateSalePercentage()}% off'),
                      const SizedBox(width: AppSizes.spaceBtwItems),
                      ProductPrice(salePrice: _product.value.salePrice,
                          regularPrice: _product.value.regularPrice ?? 0.0,
                          orientation: OrientationType.horizontal
                      ),
                      // const SizedBox(width: TSizes.spaceBtwItems),
                      // TSaleLabel(discount: salePercentage),
                    ],
                  ),
                  const SizedBox(height: AppSizes.sm / 2 ),

                  // Free Delivery Label
                  _product.value.getPrice() >= AppSettings.freeShippingOver
                      ? TRoundedContainer(
                          radius: AppSizes.productImageRadius,
                          backgroundColor: Colors.blue.shade50,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Free Delivery', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.linkColor, fontSize: 10)),
                              const SizedBox(width: AppSizes.spaceBtwItems),
                              Icon(TIcons.truck, color: AppColors.linkColor, size: 10),
                              const SizedBox(width: 5),
                            ],
                          )
                        )
                      : TRoundedContainer(
                            radius: AppSizes.productImageRadius,
                            backgroundColor: Colors.blue.shade50,
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Free delivery over ₹999', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.linkColor, fontSize: 10)),
                                const SizedBox(width: AppSizes.spaceBtwItems),
                                Icon(TIcons.truck, color: AppColors.linkColor, size: 10),
                                const SizedBox(width: 5),
                              ],
                            )
                        ),
                  const SizedBox(height: AppSizes.spaceBtwItems),

                  // In Stock
                  InStock(isProductAvailable: _product.value.isProductAvailable()),
                  const SizedBox(height: AppSizes.sm),

                  // Variation
                  _product.value.type == "variable" && filteredAttributes.isNotEmpty
                      ? GridLayout(
                            mainAxisExtent: 80,
                            itemCount: filteredAttributes.length,
                            itemBuilder: (context, attrIndex) {
                              final attribute = filteredAttributes[attrIndex];
                              if(attribute?.variation ?? false) {
                                bool lastAttribute =  attrIndex == (filteredAttributes.length - 1);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Select ${attribute?.name}',
                                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)
                                    ),
                                    SizedBox(height: 10),
                                    GridLayout(
                                        mainAxisExtent: 40,
                                        crossAxisCount: 3,
                                        itemCount: lastAttribute ? (attribute?.options?.length ?? 0) + 1 : (attribute?.options?.length ?? 0),
                                        itemBuilder: (context, index) {
                                          // Check if this is the last item
                                          if (lastAttribute) {
                                            bool lastAttributeChild =  index == ((attribute?.options?.length ?? 0));
                                            if(lastAttributeChild) {
                                              return InkWell(
                                                onTap: () => _clearSelectedOptions(),
                                                child: Center(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.close, size: 19,),
                                                        Text('Clear', ),
                                                      ],
                                                )),
                                              );
                                            }
                                          }
                                          final option = attribute?.options?[index];
                                          return InkWell(
                                            onTap: () {
                                              _updateVariation(attribute?.name ?? '', option ?? '');
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: _hasKeyValue(attribute?.name ?? '', option ?? '') ? Colors.blue : Colors.grey, // Highlight selected item
                                                  width: _hasKeyValue(attribute?.name ?? '', option ?? '') ? 2 : 1,
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                                color: _hasKeyValue(attribute?.name ?? '', option ?? '') ? Colors.blue.withOpacity(0.2) : Colors.transparent, // Optional background color
                                              ),
                                              child: attribute?.name?.toLowerCase() == 'color' &&
                                                  AppColors.getColorFromString(option?.toLowerCase() ?? '') != Colors.transparent
                                                  ? Padding(
                                                    padding: EdgeInsets.all(AppSizes.sm),
                                                    child: TRoundedContainer(
                                                        height: 20,
                                                        width: 20,
                                                        radius: 100,
                                                        backgroundColor: AppColors.getColorFromString(option?.toLowerCase() ?? ''),
                                                      ),
                                                  )
                                                  : Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      filteredAttributes.length == 1
                                                          ? Row(
                                                            children: [
                                                              TRoundedImage(
                                                                    height: 30,
                                                                    width: 30,
                                                                    padding: 0,
                                                                    borderRadius: 3,
                                                                    isNetworkImage: true,
                                                                    image: _getVariationImage(attribute?.name ?? '', option ?? '')
                                                                    // image: _productVariations.first.image ?? '',
                                                                ),
                                                              SizedBox(width: AppSizes.sm),
                                                            ],
                                                          )
                                                          : SizedBox.shrink(),
                                                      Text(option ?? '',
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)
                                                      ),
                                                    ],
                                                  ),
                                            ),
                                          );
                                        }
                                    ),
                                  ],
                                );
                              }
                              return SizedBox.shrink();
                            }
                        )
                      : SizedBox.shrink(),
                  const SizedBox(height: AppSizes.spaceBtwItems),

                  // Product review
                  _product.value.averageRating != 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductReviewHorizontal(product: _product.value),
                            const SizedBox(height: AppSizes.sm),
                          ],
                        )
                      : const SizedBox.shrink(),

                  // Frequently Bought together
                  ProductsScrollingByItemID(
                      itemName: 'Frequently Bought together',
                      itemID: _product.value.productId.toString(),
                      futureMethod: productController.getFBTProducts
                  ),

                  const SizedBox(height: AppSizes.spaceBtwSection),
                  _product.value.description != ''
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TSectionHeading(title: 'Description'),
                            const SizedBox(height: AppSizes.sm),
                            // Text(product.description ?? ''),
                            Html(data: _product.value.description)
                          ],
                        )
                      : const SizedBox.shrink(),

                  // Shown products by category
                  ProductsScrollingByItemID(
                      itemName: _product.value.categories?[0].name ?? '',
                      itemID: _product.value.categories?[0].id ?? '',
                      futureMethod: productController.getProductsByCategoryId
                  ),
                  const SizedBox(height: AppSizes.sm),

                  // Shown products by related products, up sale,cross sale
                  ProductsScrollingByItemID(
                      itemName: 'Related Products',
                      itemID: _product.value.getAllRelatedProductsIdsAsString(),
                      futureMethod: productController.getProductsByIds
                  ),
                  const SizedBox(height: AppSizes.sm),
                  const Divider(),

                  // Review
                  const SizedBox(height: AppSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 250,
                          child: TSectionHeading(title: 'Reviews(${_product.value.ratingCount})')),
                      IconButton(
                          onPressed: () => Get.to(() => ProductReviewScreen(product: _product.value)),
                          icon: const Icon(Iconsax.arrow_right_3, size: 18)
                      )
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class TOfferWidget extends StatelessWidget {
  const TOfferWidget({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.offerColor, fontWeight: FontWeight.w600));
  }
}