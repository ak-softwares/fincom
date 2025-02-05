import 'package:flutter/material.dart';

import '../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../constants/db_constants.dart';
import '../constants/sizes.dart';

class TOrderHelper {

  static bool checkOrderStatusForInTransit(String orderStatus) {
    return orderStatus == OrderStatusName.processing ||
        orderStatus == OrderStatusName.readyToShip ||
        orderStatus == OrderStatusName.inTransit ||
        orderStatus == OrderStatusName.pendingPickup ||
        orderStatus == OrderStatusName.returnInTransit ||
        orderStatus == OrderStatusName.returnPending ||
        orderStatus == OrderStatusName.returnInTransit;
  }

  static bool checkOrderStatusForReturn(String orderStatus) {
    return orderStatus == OrderStatusName.processing;
  }

  static bool giveOrderStatus(String orderStatus) {
    return orderStatus == OrderStatusName.processing;
  }

  static Widget mapOrderStatus(String orderStatus) {
    switch (orderStatus) {
      case OrderStatusName.cancelled:
        return statusWidget(status: OrderStatusPritiName.cancelled, color: Colors.red);
      case OrderStatusName.processing:
        return statusWidget(status: OrderStatusPritiName.processing, color: Colors.green);
      case OrderStatusName.readyToShip:
        return statusWidget(status: OrderStatusPritiName.readyToShip, color: Colors.orange);
      case OrderStatusName.pendingPickup:
        return statusWidget(status: OrderStatusPritiName.pendingPickup, color: Colors.orange);
      case OrderStatusName.inTransit:
        return statusWidget(status: OrderStatusPritiName.inTransit, color: Colors.orange);
      case OrderStatusName.completed:
        return statusWidget(status: OrderStatusPritiName.completed, color: Colors.blue);
      case OrderStatusName.returnInTransit:
        return statusWidget(status: OrderStatusPritiName.returnInTransit, color: Colors.grey);
      case OrderStatusName.returnPending:
        return statusWidget(status: OrderStatusPritiName.returnPending, color: Colors.grey);
      default:
        return statusWidget(status: orderStatus, color: Colors.grey);
    }
  }

  static TRoundedContainer statusWidget({required String status, required Color color}) {
    return TRoundedContainer(
          radius: 10,
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
          child: Text(status, style: const TextStyle(fontSize: 14, color: Colors.white))
      );
  }

}