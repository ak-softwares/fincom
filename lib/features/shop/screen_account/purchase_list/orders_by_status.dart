import 'package:fincom/common/navigation_bar/appbar2.dart';
import 'package:flutter/material.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../models/order_model.dart';
import '../../screens/orders/widgets/order_list_items.dart';

class OrdersByStatus extends StatelessWidget {
  const OrdersByStatus({super.key, required this.orders, required this.orderStatus});

  final List<OrderStatus> orderStatus;
  final List<OrderModel> orders;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar2(titleText: 'Purchase List Orders'),
      body: SingleChildScrollView(
        padding: TSpacingStyle.defaultPagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSizes.sm,
          children: [
            Text(orderStatus.map((e) => e.prettyName).join(', ') ?? '',),
            GridLayout(
              itemCount: orders.length,
              crossAxisCount: 1,
              mainAxisExtent: AppSizes.orderTileHeight,
              itemBuilder: (context, index) {
                return SingleOrderTile(order: orders[index]);
              },
            ),
          ],
        ),
      )
    );
  }
}
