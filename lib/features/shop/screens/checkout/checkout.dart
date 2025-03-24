import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../common/widgets/product/product_cards/product_card_cart_items.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../../settings/app_settings.dart';
import '../../controllers/cart_controller/cart_controller.dart';
import '../../controllers/checkout_controller/checkout_controller.dart';
import '../../controllers/order/order_controller.dart';
import 'widgets/billing_address_section.dart';
import 'widgets/billing_amount_section.dart';
import 'widgets/billing_payment_section.dart';
import 'widgets/coupon_section.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final cartController = Get.put(CartController());
    final checkoutController = Get.put(CheckoutController());
    final authenticationRepository = Get.put(AuthenticationRepository());
    FBAnalytics.logPageView('checkout_screen');
    FBAnalytics.logBeginCheckout(cartItems: cartController.cartItems);
    // Trigger updateCheckout on widget initialization
    Future.microtask(() => checkoutController.updateCheckout());

    return Scaffold(
      appBar: const AppAppBar2(titleText: "Order summery", showBackArrow: true),
      bottomNavigationBar: Obx((){
        if (authenticationRepository.isUserLogin.value && cartController.cartItems.isNotEmpty){
          return Padding(
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              child: ElevatedButton(
                  onPressed: () => checkoutController.initiateCheckout(),
                  // onPressed: () {},
                  child: Obx(() => Text('Place Order (${AppSettings.appCurrencySymbol +
                      checkoutController.total.value.toStringAsFixed(0)})'))
              ),
            );
        } else {
          return const SizedBox.shrink();
        }
      }),
      body: !authenticationRepository.isUserLogin.value
          ? const CheckLoginScreen(text: 'Please Login! before Checkout!')
          : SingleChildScrollView(
            padding: const EdgeInsets.all(Sizes.defaultSpace),
            child: Column(
              children: [
                Obx(
                  () => GridLayout(
                    crossAxisCount: 1,
                    mainAxisExtent: 90,
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (_, index) => Stack(
                        children:[
                          CartTile(cartItem: cartController.cartItems[index]),
                        ]
                    ),
                  ),
                ),
                const SizedBox(height: Sizes.spaceBtwSections,),

                /// -- coupon TextField
                const TCouponCode(),
                const SizedBox(height: Sizes.spaceBtwSections,),

                /// -- Billing Sections
                const TRoundedContainer(
                  showBorder: true,
                  padding: EdgeInsets.all(Sizes.md),
                  child: Column(
                    children: [
                      /// pricing
                      TBillingAmountSection(),
                      SizedBox(height: Sizes.spaceBtwItems,),

                      /// Divider
                      Divider(),
                      SizedBox(height: Sizes.spaceBtwItems),

                      /// payment method
                      TBillingPaymentSection(),
                      SizedBox(height: Sizes.spaceBtwItems),

                      /// Divider
                      Divider(),
                      SizedBox(height: Sizes.spaceBtwItems),

                      /// address
                      TBillingAddressSection(),
                      SizedBox(height: Sizes.spaceBtwItems),
                    ],
                  ),
                ),///
              ],
            ),
          ),
    );
  }
}
