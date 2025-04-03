import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';


import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../common/widgets/product/favourite_icon/favourite_icon.dart';
import '../../../../../services/share/share.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../settings/app_settings.dart';
import '../../../controllers/product/image_controller.dart';
import '../../../models/product_model.dart';

class TProductImageSlider extends StatefulWidget {
  const TProductImageSlider({super.key, required this.product});

  final ProductModel product;

  @override
  State<TProductImageSlider> createState() => _TProductImageSliderState();
}

class _TProductImageSliderState extends State<TProductImageSlider> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  final RxString _selectedProductImage = ''.obs;
  final imagesController = Get.put(ImagesController());

  @override
  void initState() {
    super.initState();
  }

  List<String> _getAllProductImages(ProductModel product) {
    //use set to add unique image only
    Set<String> images = {};

    //Load Main Image
    images.add(product.mainImage ?? '');

    //Assign thumbnail as selected Image
    _selectedProductImage.value = product.mainImage ?? '';

    //Get all images from the product model if not null.
    if(product.images != null) {
      // images.addAll(product.images!);
    }

    return images.toList();
  }

  @override
  Widget build(BuildContext context) {
    // final images = controller.getAllProductImages(product);
    final images = widget.product.imageUrlList;
    _selectedProductImage.value = widget.product.mainImage ?? '';
    const double mainImageHeight = 340;
    const double galleryImageHeight = 80;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        //Main Big Image
        SizedBox(
          height: mainImageHeight, //Main image height
          width: double.infinity,
          child: Center(child: Obx(() {
            final image = _selectedProductImage.value;
            return Stack(
              children: [
                CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: mainImageHeight,
                    aspectRatio: 1.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 6),
                    enableInfiniteScroll: false, // Disable infinite scrolling
                    viewportFraction: 1.0,
                    onPageChanged: (index, _) => _selectedProductImage.value = images[index],
                    // scrollPhysics: const NeverScrollableScrollPhysics(), // Disable touch scroll

                  ),
                  items: widget.product.imageUrlList.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () => imagesController.showEnlargedImage(imageUrl),
                          child: InteractiveViewer(
                            maxScale: 3,
                            minScale: 1,
                            child: TRoundedImage(
                              image: imageUrl,
                              height: mainImageHeight,
                              width: mainImageHeight,
                              borderRadius: 0,
                              isNetworkImage: true,
                              padding: 3,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),

                // Favorite and share icon
                Positioned(
                    top: 5,
                    right: 5,
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: TFavouriteIcon(product: widget.product),
                        ),
                        const SizedBox(height: AppSizes.sm),
                        Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: IconButton(
                                onPressed: () => AppShare.shareUrl(
                                    url: widget.product.permalink ?? '',
                                    contentType: 'Product',
                                    itemName: widget.product.name ?? '',
                                    itemId: widget.product.productId.toString()
                                ),
                                icon: const Icon(Icons.share)
                            )
                        ),
                      ],
                    )
                ),

                // Main image enlarge
                Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: IconButton(
                            onPressed: () => imagesController.showEnlargedImage(image),
                            icon: const Icon(Iconsax.maximize_2, color: Colors.black,)
                        )
                    )
                )
              ],
            );
          })),
        ),

        //Image Gallery
        SizedBox(
          height: galleryImageHeight,
          child: Stack(
            children: [
              ListView.separated(
                  itemCount: images.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_,__) => const SizedBox(width: AppSizes.spaceBtwItems),
                  itemBuilder: (_, index) => Obx(() {
                    final imageSelected = _selectedProductImage.value == images[index];
                    return TRoundedImage(
                      width: galleryImageHeight,
                      border: Border.all(color: imageSelected ? AppColors.primaryColor : Colors.transparent),
                      borderRadius: AppSizes.sm,
                      backgroundColor: Colors.white,
                      padding: AppSizes.sm / 2,
                      isNetworkImage: true,
                      onTap: () => _carouselController.animateToPage(index),
                      image: images[index],
                    );
                  })
              ),
              images.length >= 5
                  ? Positioned(
                        left: 0,
                        height: galleryImageHeight,
                        child: Icon(Iconsax.arrow_left_2, color: Colors.grey[400], size: 20)
                    )
                  : const SizedBox.shrink(),
              images.length >= 5
                  ? Positioned(
                        right: 0,
                        height: galleryImageHeight,
                        child: Icon(Iconsax.arrow_right_34, color: Colors.grey[400], size: 20)
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
