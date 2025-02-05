import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/widgets/product/cart/cart_counter_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../shop/screens/cart/cart.dart';
import '../../../../shop/screens/favourite/favourite.dart';
class FavouriteWithCart extends StatelessWidget {
  const FavouriteWithCart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () => Get.to(const FavouriteScreen()),
              child: Container(
                  color: TColors.primaryBackground,
                  padding: TSpacingStyle.defaultPagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TWishlistCounterIcon(),
                      Text('Favourites', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
                    ],
                  )
              ),
            ),
          ),
          const SizedBox(width: Sizes.spaceBtwInputFields),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () => Get.to(const CartScreen()),
              child: Container(
                  color: TColors.primaryBackground,
                  padding: TSpacingStyle.defaultPagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TCartCounterIcon(),
                      Text('Cart', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
                    ],
                  )
              ),
            ),
          ),
        ]
    );
  }
}
