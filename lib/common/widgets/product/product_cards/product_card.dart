import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../features/shop/models/product_model.dart';
import '../../../../features/shop/screens/products/scrolling_products.dart';
import '../../../../features/shop/screens/products/product_detail.dart';
import '../../../../features/shop/screens/products/products_widgets/product_price.dart';
import '../../../../features/shop/screens/products/products_widgets/product_star_rating.dart';
import '../../../../features/shop/screens/products/products_widgets/product_title_text.dart';
import '../../../../features/shop/screens/products/products_widgets/sale_label.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../styles/shadows.dart';
import '../../custom_shape/image/circular_image.dart';
import '../cart/cart_card_icon.dart';
import '../favourite_icon/favourite_icon.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.pageSource = 'pc', this.orientation = OrientationType.vertical});

  final ProductModel product;
  final String pageSource;
  final OrientationType orientation;


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductScreen(product: product, pageSource: pageSource,))),
      // onTap: () => Get.to(ProductDetailScreen(product: product)),
      child: orientation == OrientationType.vertical
        ? productCardVertical()
        : productCardHorizontal()
    );
  }

  Container productCardVertical() {
    const double productImageSizeVertical = AppSizes.productImageSizeVertical;
    const double productCardVerticalHeight = AppSizes.productCardVerticalHeight;
    const double productCardVerticalWidth = AppSizes.productCardVerticalWidth;
    const double productImageRadius = AppSizes.productImageRadius;
    final salePercentage = product.calculateSalePercentage();
    return Container(
      width: productCardVerticalWidth,
      padding: const EdgeInsets.all(AppSizes.xs),
      decoration: BoxDecoration(
        boxShadow: [TShadowStyle.verticalProductShadow],
        borderRadius: BorderRadius.circular(productImageRadius),
        color: Colors.white,
        // border: Border.all(color: TColors.borderSecondary.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Main Image
          Column(
            children: [
              Stack(
                children: [

                  // Carousel for images
                  CarouselSlider(
                    options: CarouselOptions(
                      height: productImageSizeVertical,
                      aspectRatio: 1.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: Random().nextInt(6) + 3),
                      // enableInfiniteScroll: false, // Disable infinite scrolling
                      viewportFraction: 1.0,
                      scrollPhysics: const NeverScrollableScrollPhysics(), // Disable touch scroll
                    ),
                    items: product.imageUrlList.map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return TRoundedImage(
                            image: imageUrl,
                            height: productImageSizeVertical,
                            width: productImageSizeVertical,
                            borderRadius: productImageRadius,
                            isNetworkImage: true,
                            padding: 3,
                            backgroundColor: Colors.white,
                          );
                        },
                      );
                    }).toList(),
                  ),

                  //sale tag
                  Positioned(
                    top: 10,
                    left: 3,
                    child: TSaleLabel(discount: salePercentage),
                  ),

                  // favourite icons
                  Positioned(
                    top: 0,
                    right: 0,
                    child: TFavouriteIcon(product: product, iconSize: 20)
                  ),

                  // Out of stock
                  Positioned(
                      bottom: 5,
                      right: 5,
                      child: product.isProductAvailable()
                          ? const SizedBox.shrink()
                          : Container(
                                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: AppSizes.sm),
                                // color: Colors.grey.withOpacity(0.6),
                                color: Colors.transparent,
                                child: const Text('Out of Stock',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 0),
                                          blurRadius: 5,
                                          color: Color.fromARGB(255, 255, 255, 255), // White color shadow
                                        ),
                                      ],
                                  ),),
                            ),
                  )
                ],
              ),
              // Title and Star rating
              const SizedBox(height: AppSizes.xs),
              Padding(
                  padding: const EdgeInsets.only(left: AppSizes.sm),
                  child: Column(
                    children: [
                      ProductTitle(title: product.name ?? ''),
                      ProductStarRating(
                        averageRating: product.averageRating ?? 0.0,
                        ratingCount: product.ratingCount ?? 0,
                        size: 12,
                      ),
                    ],
                  )
              ),
            ],
          ),

          // Price and Add to cart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Price
              Container(
                padding: const EdgeInsets.only(left: AppSizes.sm, bottom: 5),
                child: ProductPrice(
                  salePrice: product.salePrice,
                  regularPrice: product.regularPrice ?? 0.0,
                  orientation: OrientationType.horizontal,
                  size: 16,
                ),
              ),

              // Add to cart
              Container(
                  width: 45,
                  height: 35,
                  decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        // topLeft: Radius.circular(TSizes.cardRadiusMd),
                        bottomRight: Radius.circular(productImageRadius),
                      )
                  ),
                  child: SizedBox(
                      width: AppSizes.iconLg * 1.2,
                      height: AppSizes.iconLg * 1.2,
                      child: Center(child: CartIcon(product: product, sourcePage: pageSource))
                  ),
              )
            ],
          )
        ],
      ),
    );
  }

  Container productCardHorizontal() {
    const double productImageSizeHorizontal = AppSizes.productImageSizeHorizontal;
    const double productCardHorizontalHeight = AppSizes.productCardHorizontalHeight;
    const double productCardHorizontalWidth = AppSizes.productCardHorizontalWidth;
    const double productImageRadius = AppSizes.productImageRadius;
    final salePercentage = product.calculateSalePercentage();
    return Container(
      width: productCardHorizontalWidth,
      padding: const EdgeInsets.all(AppSizes.xs),
      decoration: BoxDecoration(
        boxShadow: [TShadowStyle.verticalProductShadow],
        borderRadius: BorderRadius.circular(productImageRadius),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Main Image
          Stack(
            children: [
              // Thumbnail Image
              TRoundedImage(
                  image: product.mainImage ?? '',
                  height: productImageSizeHorizontal,
                  width: productImageSizeHorizontal,
                  borderRadius: productImageRadius,
                  isNetworkImage: true,
                  padding: 0
              ),

              //Sale Percentage
              // Positioned(
              //   top: 5,
              //   left: 3,
              //   child: TSaleLabel(discount: salePercentage, size: 10,)
              // ),

              // favourite icons
              Positioned(
                  top: -5,
                  right: -5,
                  child: TFavouriteIcon(product: product, iconSize: 20)
              )
            ],
          ),

          // Title, Rating and price
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSizes.sm),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      ProductTitle(title: product.name ?? '', size: 14, maxLines: 2,),
                      // Star rating
                      ProductStarRating(averageRating: product.averageRating ?? 0.0, ratingCount: product.ratingCount ?? 0, size: 12,),
                    ],
                  ),
                  // Price and Add to cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //Price
                      ProductPrice(
                          salePrice: product.salePrice!,
                          regularPrice: product.regularPrice ?? 0.0,
                          orientation: OrientationType.horizontal,
                          size: 17
                      ),

                      // Add to cart
                      Container(
                        width: 45,
                        height: 33,
                        decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.only(
                              // topLeft: Radius.circular(TSizes.cardRadiusMd),
                              bottomRight: Radius.circular(productImageRadius),
                            )
                        ),
                        child: SizedBox(
                            width: AppSizes.iconLg,
                            height: AppSizes.iconLg,
                            child: Center(child: CartIcon(product: product, sourcePage: pageSource,))
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}










