import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../common/widgets/product/product_cards/product_card_cart_items.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/order_helper.dart';
import '../../../settings/app_settings.dart';
import '../../models/order_model.dart';
import 'widgets/cancel_order.dart';
import 'widgets/repeat_order.dart';
import 'widgets/track_now.dart';

class SingleOrderScreen extends StatelessWidget {
  const SingleOrderScreen({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('order_single_screen');
    return Scaffold(
      appBar: TAppBar2(titleText: "Order #${order.id}", showBackArrow: true),
      body: SingleChildScrollView(
        padding: TSpacingStyle.defaultPagePadding,
        child: Column(
          children: [
            TRoundedContainer(
              showBorder: true,
              padding: TSpacingStyle.defaultPagePadding,
              borderColor: TColors.borderPrimary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TOrderHelper.mapOrderStatus(order.status ?? ''),
                      Text('Order #${order.id}', style: Theme.of(context).textTheme.bodyLarge)
                    ],
                  ),
                  dividerIWithPadding(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date ', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black54)),
                      Text(order.formattedOrderDate, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black87)),
                    ],
                  ),
                  dividerIWithPadding(),
                  GridLayout(
                    crossAxisCount: 1,
                    mainAxisExtent: 90,
                    itemCount: order.lineItems!.length,
                    itemBuilder: (_, index) => Stack(
                        children:[
                          ProductCardForCart(cartItem: order.lineItems![index]),
                        ]
                    ),
                  ),
                  dividerIWithPadding(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium),
                      Text('${AppSettings.appCurrencySymbol}${order.calculateTotalSum()}', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  if(order.discountTotal != '0' && order.discountTotal!.isNotEmpty)
                    Column(
                      children: [
                        dividerIWithPadding(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount', style: Theme.of(context).textTheme.bodyMedium),
                            Text('- ${AppSettings.appCurrencySymbol}${order.discountTotal!}', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                  if(order.shippingTotal != '0' && order.shippingTotal!.isNotEmpty)
                    Column(
                      children: [
                        dividerIWithPadding(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Shipping', style: Theme.of(context).textTheme.bodyMedium),
                            Text(AppSettings.appCurrencySymbol + order.shippingTotal!, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                  dividerIWithPadding(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Method  ', style: Theme.of(context).textTheme.bodyMedium),
                      // Text(order.paymentMethodTitle ?? '', style: Theme.of(context).textTheme.bodyMedium),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(order.paymentMethodTitle ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ),
                    ],
                  ),
                  dividerIWithPadding(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)),
                      Text(AppSettings.appCurrencySymbol + order.total!, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  dividerIWithPadding(),
                  Text('Address:', style: Theme.of(context).textTheme.bodyLarge),
                  Text(order.billing!.completeAddress(), style: Theme.of(context).textTheme.bodyMedium),
                  // const Divider(color: TColors.borderSecondary,),
                  // const SizedBox(height: TSizes.defaultSpace,),
                  // Text('Shipping Address:', style: Theme.of(context).textTheme.bodyLarge),
                  // Text(order.shipping.toString(), style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwSection),

            // Track order
            TRoundedContainer(
              showBorder: true,
              padding: TSpacingStyle.defaultPagePadding,
              borderColor: TColors.borderPrimary,
              child: TrackOrderWidget(orderId: order.id.toString())
            ),
            const SizedBox(height: Sizes.spaceBtwItems),

            // Repeat Order
            TRoundedContainer(
                showBorder: true,
                padding: TSpacingStyle.defaultPagePadding,
                borderColor: TColors.borderPrimary,
                child: RepeatOrderWidget(cartItems: order.lineItems ?? []),
            ),
            const SizedBox(height: Sizes.spaceBtwItems),

            // Cancel order
            TOrderHelper.checkOrderStatusForReturn(order.status ?? '')
              ? TRoundedContainer(
                showBorder: true,
                padding: TSpacingStyle.defaultPagePadding,
                borderColor: TColors.borderPrimary,
                child: CancelOrderWidget(orderId: order.id.toString()),
              )
              : const SizedBox.shrink(),
            const SizedBox(height: Sizes.spaceBtwItems),

            // Return order
            // TRoundedContainer(
            //   showBorder: true,
            //   padding: TSpacingStyle.defaultPagePadding,
            //   borderColor: TColors.borderPrimary,
            //   child: ReturnOrderWidget(cartItems: order.lineItems ?? []),
            // ),
            // const SizedBox(height: TSizes.spaceBtwItems),
          ],
        )
      )
    );
  }

  Padding dividerIWithPadding() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: Sizes.xs),
      child: Divider(color: TColors.borderSecondary),
    );
  }
}
