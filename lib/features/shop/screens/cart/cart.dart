import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/product/product_cards/product_card_cart_items.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/navigation_helper.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../../settings/app_settings.dart';
import '../../controllers/cart_controller/cart_controller.dart';
import '../../controllers/checkout_controller/checkout_controller.dart';
import '../../controllers/order/order_controller.dart';
import '../checkout/checkout.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    final checkoutController = Get.put(CheckoutController());
    FBAnalytics.logPageView('cart_screen');
    FBAnalytics.logViewCart(cartItems: cartController.cartItems);

    return Scaffold(
        appBar: const TAppBar2(titleText: "Cart"),
        bottomNavigationBar: Obx((){
          if (AuthenticationRepository.instance.isUserLogin.value && cartController.cartItems.isNotEmpty){
            return Padding(
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              child: ElevatedButton(
                  onPressed: () {
                    checkoutController.updateCheckout();
                    Get.to(const CheckoutScreen());
                  },
                  child: Obx(() => Text('Buy Now (${AppSettings.appCurrencySymbol + (cartController.totalCartPrice.value).toStringAsFixed(0)})'))
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
        body: Obx(() {
          //check user login_controller
          if(!AuthenticationRepository.instance.isUserLogin.value){
            return const CheckLoginScreen(text: 'Please Login! before Add to Cart!', animation: Images.addToCartAnimation);
          }

          //make empty cart animation
          final emptyWidget = TAnimationLoaderWidgets(
            text: 'Whoops! Cart is Empty...',
            animation: Images.addToCartAnimation,
            showAction: true,
            actionText: 'Let\'s add some',
            onActionPress: () => NavigationHelper.navigateToBottomNavigation(),
          );

          // check empty cart
          if(cartController.cartItems.isEmpty) {
            return emptyWidget;
          } else {
            return ListView(
              padding: TSpacingStyle.defaultPagePadding,
              children: [
                GridLayout(
                  crossAxisCount: 1,
                  mainAxisExtent: Sizes.cartCardHorizontalHeight,
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (_, index) => CartTile(cartItem: cartController.cartItems[index], showBottomBar: true),
                ),
                // Center(child: Text(cartController.cartItems.map((item) => item.pageSource ?? 'NA').join(', ')))
              ],
            );
          }
        }
      ),
    );
  }
}


