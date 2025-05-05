import 'package:flutter/material.dart';

import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/cart_item_model.dart';
import '../../../models/order_model.dart';

class OrderImageGallery extends StatelessWidget {
  const OrderImageGallery({
    super.key,
    required this.galleryImageHeight,
    required this.cartItems,
  });

  final double galleryImageHeight;
  final List<CartModel> cartItems;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: galleryImageHeight,
      child: Stack(
        children: [
          ListView.separated(
              itemCount: cartItems.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spaceBtwItems),
              itemBuilder: (_, index) => RoundedImage(
                width: galleryImageHeight,
                borderRadius: AppSizes.sm,
                backgroundColor: Colors.white,
                padding: AppSizes.sm / 2,
                isNetworkImage: true,
                isTapToEnlarge: true,
                // onTap: () => Get.to(() => ProductDetailScreen(productId: cartItems[index].productId.toString())),
                image: cartItems[index].image ?? '',
              )
          ),
        ],
      ),
    );
  }
}