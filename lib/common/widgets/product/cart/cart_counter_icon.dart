import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/shop/controllers/cart_controller/cart_controller.dart';
import '../../../../features/shop/controllers/favorite/favorite_controller.dart';
import '../../../../features/shop/screens/cart/cart.dart';
import '../../../../features/shop/screens/favourite/favourite.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/icons.dart';

class TCartCounterIcon extends StatelessWidget {
  const TCartCounterIcon({
    super.key, this.iconColor = Colors.black, this.counterColorInvert = false,
  });

  final Color? iconColor;
  final bool counterColorInvert;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    return Stack(
      children: [
        IconButton(
            onPressed: () => Get.to(() => const CartScreen()),
            icon: Icon(TIcons.bottomNavigationCart, size: 25,),
            color: iconColor
        ),
        Positioned(
          top: 5,
          right: 5,
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                boxShadow: const [BoxShadow(
                  color: Color(0xFFAB7C00),
                  blurRadius: 1, // Adjust as needed
                  // spreadRadius: 5, // Adjust as needed
                  offset: Offset(0, 0), // Adjust as needed
                )],
                color: counterColorInvert ? AppColors.secondaryColor : AppColors.primaryColor,
                borderRadius: BorderRadius.circular(100)
              ),
              child: Center(
                child: Obx(
                  () => Text(
                      controller.noOfCartItems.value.toString(),
                      style: Theme.of(context).textTheme.labelSmall!.apply(
                          color: counterColorInvert ? Colors.white : AppColors.secondaryColor,
                          fontSizeFactor: 0.9,
                          fontWeightDelta: 2
                      )
                  )
                ),
              ),
            )
        )
      ],
    );
  }
}

class TWishlistCounterIcon extends StatelessWidget {
  const TWishlistCounterIcon({
    super.key, this.iconColor = Colors.black,
  });

  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoriteController());
    return Stack(
      children: [
        IconButton(
            onPressed: () => Get.to(const FavouriteScreen()),
            icon: Icon(TIcons.favorite, size: 20,),
            color: iconColor
        ),
        Positioned(
            top: 5,
            right: 5,
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(100)
              ),
              child: Center(
                child: Obx(() => Text(
                    controller.favorites.length.toString(),
                    style: Theme.of(context).textTheme.labelSmall!.apply(
                        color: Colors.black,
                        fontSizeFactor: 0.9,
                        fontWeightDelta: 2
                    )
              )),
              ),
            )
        )
      ],
    );
  }
}
