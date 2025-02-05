import 'package:flutter/material.dart';

import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/cart_item_model.dart';
import '../../../models/order_model.dart';

class OrderImageGallery extends StatelessWidget {
  const OrderImageGallery({
    super.key,
    required this.galleryImageHeight,
    required this.order,
  });

  final double galleryImageHeight;
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final List<CartItemModel> cartItems = order.lineItems ?? [];
    return SizedBox(
      height: galleryImageHeight,
      child: Stack(
        children: [
          ListView.separated(
              itemCount: cartItems.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(width: Sizes.spaceBtwItems),
              itemBuilder: (_, index) => TRoundedImage(
                  width: galleryImageHeight,
                  borderRadius: Sizes.sm,
                  backgroundColor: Colors.white,
                  padding: Sizes.sm / 2,
                  isNetworkImage: true,
                  // onTap: () => Get.to(() => ProductDetailScreen(productId: cartItems[index].productId.toString())),
                  image: cartItems[index].image ?? '',
              )
          ),
          // cartItems.length >= 5
          //   ? Positioned(
          //       left: 0,
          //       height: galleryImageHeight,
          //       child: Icon(Iconsax.arrow_left_2, color: Colors.grey[400], size: 20)
          //     )
          //   : const SizedBox.shrink(),
          // cartItems.length >= 5
          //   ? Positioned(
          //       right: 0,
          //       height: galleryImageHeight,
          //       child: Icon(Iconsax.arrow_right_34, color: Colors.grey[400], size: 20)
          //     )
          //   : const SizedBox.shrink(),
        ],
      ),
    );
  }
}