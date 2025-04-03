import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/shop/controllers/cart_controller/cart_controller.dart';
import '../../../../features/shop/models/product_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/icons.dart';
class CartIcon extends StatelessWidget {
  const CartIcon({super.key, this.iconSize, required this.sourcePage, required this.product});

  final double? iconSize;
  final String sourcePage;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return product.type == ProductFieldName.typeVariable
        ? Icon(TIcons.cartVariation, size: 20,)
        : IconButton(
            onPressed: () => cartController.toggleCartProduct(product: product, sourcePage: sourcePage),
            iconSize: iconSize,
            color: AppColors.secondaryColor,
            icon: Obx(() {
                final productQuantityInCart = cartController.isInCart(product.productId);
                return Icon(productQuantityInCart ? TIcons.cartFull : TIcons.cartEmpty, size: 20,);
              }
            ),
        );
  }
}
