import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../data/repositories/mongodb/orders/orders_repositories.dart';
import '../../../../data/repositories/woocommerce/orders/woo_orders_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/cart_item_model.dart';
import '../../models/order_model.dart';
import '../product/product_controller.dart';
import 'sales_controller.dart';

class SaleReturnController extends GetxController {
  static SaleReturnController get instance => Get.find();

  RxBool isScanning = false.obs;
  RxList<OrderModel> returns = <OrderModel>[].obs;

  final returnOrderTextEditingController = TextEditingController();

  final productController = Get.put(ProductController());
  final mongoOrderRepo = Get.put(MongoOrderRepo());
  final saleController = Get.put(SaleController());

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  final MobileScannerController cameraController = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.all],
  );

  Future<void> handleDetection(BarcodeCapture capture) async {
    if (isScanning.value) return;
    try {
      FullScreenLoader.onlyCircularProgressDialog('Fetching Order...');
      isScanning.value = true;

      for (final barcode in capture.barcodes) {
        final value = int.tryParse(barcode.rawValue ?? '');
        bool exists = returns.any((order) => order.orderId == value);
        if (value != null && !exists) {
          HapticFeedback.mediumImpact();
          final OrderModel getReturn = await saleController.getSaleByOrderId(orderId: value);
          if(getReturn.id == null) {
            throw 'No sale found to add return';
          }
          returns.add(getReturn);
        }
      }

      Future.delayed(const Duration(seconds: 2), () {
        isScanning.value = false;
      });
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in Order Fetching', message: e.toString());
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  Future<void> addBarcodeReturn() async {
    try {
      FullScreenLoader.onlyCircularProgressDialog('Fetching Order...');

      // Flatten all line items from each return
      final List<CartModel> allLineItems = returns.expand<CartModel>((returned) => returned.lineItems ?? []).toList();

      // Define the async operations
      final updateProductQuantities = productController.updateProductQuantity(cartItems: allLineItems, isAddition: true);

      Future<void> uploadReturns = mongoOrderRepo.updateOrdersStatus(orders: returns, newStatus: OrderStatus.returned);

      await Future.wait([updateProductQuantities, uploadReturns]);

      returns.clear();
      Get.back();
      AppMassages.showToastMessage(message: 'Return updated successfully');
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error sale', message: e.toString());
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  Future<void> addManualReturn() async {
    try {
      isScanning(true);
      FullScreenLoader.onlyCircularProgressDialog('Fetching Order...');
      final int manualOrderNumber = int.tryParse(returnOrderTextEditingController.text) ?? 0;
      final bool exists = returns.any((order) => order.orderId == manualOrderNumber);

      if (exists) {
        // Order already exists
        AppMassages.errorSnackBar(title: 'Duplicate', message: 'This order number already exists.');
      } else {
        HapticFeedback.mediumImpact();
        // checkIsSaleExist
        final OrderModel checkIsSaleExist = await saleController.getSaleByOrderId(orderId: manualOrderNumber);
        if(checkIsSaleExist.id == null) {
          throw 'Sale does not exist';
        }
        returns.add(checkIsSaleExist);
      }
    } catch(e){
      AppMassages.errorSnackBar(title: 'Error', message: 'Add manual order failed: ${e.toString()}');
    } finally{
      FullScreenLoader.stopLoading();
      isScanning(false);
    }
  }
}