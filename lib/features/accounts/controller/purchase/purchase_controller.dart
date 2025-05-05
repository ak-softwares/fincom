import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/dialog_massage.dart';
import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/image_kit/image_kit_repo.dart';
import '../../../../data/repositories/mongodb/products/product_repositories.dart';
import '../../../../data/repositories/mongodb/purchase/purchase_repositories.dart';
import '../../../../data/repositories/mongodb/transaction/transaction_repo.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../../../personalization/models/user_model.dart';
import '../../models/cart_item_model.dart';
import '../../models/image_model.dart';
import '../../models/product_model.dart';
import '../../models/purchase_model.dart';
import '../product/product_controller.dart';
import '../transaction/transaction_controller.dart';
import '../vendor/vendor_controller.dart';

import '../../../../data/repositories/mongodb/orders/orders_repositories.dart';
import '../../../../data/repositories/woocommerce/orders/woo_orders_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/order_model.dart';

class PurchaseController extends GetxController {
  static PurchaseController get instance => Get.find();

  // Variables
  final OrderType orderType = OrderType.purchase;
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  RxList<OrderModel> purchases = <OrderModel>[].obs;
  final ImageKitService imageKitService = ImageKitService();

  final mongoOrderRepo = Get.put(MongoOrderRepo());
  final wooOrdersRepository = Get.put(WooOrdersRepository());
  final productController = Get.put(ProductController());
  final userController = Get.put(UserController());

  Future<void> getPurchases() async {
    try {
      final fetchedOrders = await mongoOrderRepo.fetchOrders(orderType: orderType, page: currentPage.value);
      purchases.addAll(fetchedOrders);
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in Orders Fetching', message: e.toString());
    }
  }

  Future<void> refreshPurchases() async {
    try {
      isLoading(true);
      currentPage.value = 1;
      purchases.clear();
      await getPurchases();
    } catch (error) {
      AppMassages.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<OrderModel> getPurchaseById({required String purchaseId}) async {
    try {
      return await mongoOrderRepo.fetchOrderById(saleId: purchaseId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePurchase({required OrderModel purchase, required BuildContext context}) async {
    try {
      DialogHelper.showDialog(
        context: context,
        title: 'Delete Purchase',
        message: 'Are you sure to delete this purchase?',
        actionButtonText: 'Delete',
        toastMessage: 'Purchase deleted successfully!',
        onSubmit: () async {
          await Future.wait([
            deleteImages(purchase.purchaseInvoiceImages ?? []),
            productController.updateProductQuantity(cartItems: purchase.lineItems ?? []),
            userController.updateUserBalance(
              userID: purchase.userId ?? 0,
              balance: purchase.total ?? 0,
              isAddition: true
            ),
            mongoOrderRepo.deleteOrderById(id: purchase.id ?? ''),
            refreshPurchases(),
          ]);
          Get.back();
        },
      );
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> deleteImages(List<ImageModel> images) async {
    try {

      // Collect all valid imageIds
      List<String> imageIds = images
          .where((image) => image.imageId != null && image.imageId!.isNotEmpty)
          .map((image) => image.imageId!)
          .toList();

      if (imageIds.isNotEmpty) {
        // Bulk delete using the new deleteImages function
        await imageKitService.deleteImages(imageIds);

        AppMassages.showToastMessage(message: 'Images deleted successfully');
      }
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error Deleting Images', message: e.toString());
    }
  }

}
