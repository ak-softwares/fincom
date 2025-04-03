import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../features/shop/controllers/favorite/favorite_controller.dart';
import '../../../../features/shop/models/product_model.dart';
import '../../../../features/shop/screens/favourite/favourite.dart';
import '../../../../utils/constants/colors.dart';

class TFavouriteIcon extends StatelessWidget {
  const TFavouriteIcon({
    super.key,
    this.iconSize, required this.product,
  });

  final double? iconSize;
  final ProductModel product;
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoriteController());
    final String productId = product.productId.toString();

    return Obx(
        () => GestureDetector(
          onLongPress: () => Get.to(const FavouriteScreen()),
          child: IconButton(
            onPressed: () => controller.toggleFavoriteProduct(product: product),
            iconSize: iconSize,
            // splashRadius: 50,
            icon: controller.isFavorite(productId) ? const Icon(Iconsax.heart5) : const Icon(Iconsax.heart),
            color: controller.isFavorite(productId) ? AppColors.error : null,
                ),
        ),
    );
  }
}
