import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../common/dialog_box_massages/dialog_massage.dart';
import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../data/repositories/woocommerce/orders/woo_orders_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/order_model.dart';
import 'add_sale_controller.dart';
import 'sales_controller.dart';

class AddBarcodeSaleController extends GetxController {
  static AddBarcodeSaleController get instance => Get.find();

  var isScanning = false.obs;
  final OrderType orderType = OrderType.sale;

  RxList<OrderModel> newSales = <OrderModel>[].obs;

  int get saleTotal => newSales.fold(0, (sum, order) => sum + (order.total ?? 0).toInt());

  final addOrderTextEditingController = TextEditingController();

  final saleController = Get.put(SaleController());
  final addSaleController = Get.put(AddSaleController());
  final wooOrdersRepository = Get.put(WooOrdersRepository());

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  final MobileScannerController cameraController = MobileScannerController(
    torchEnabled: false,
    formats: [BarcodeFormat.all],
  );

  Future<void> addManualOrder() async {
    try {
      isScanning(true);
      FullScreenLoader.onlyCircularProgressDialog('Fetching Order...');
      final int manualOrderNumber = int.tryParse(addOrderTextEditingController.text) ?? 0;
      final bool exists = newSales.any((order) => order.orderId == manualOrderNumber);

      if (exists) {
        // Order already exists
        AppMassages.errorSnackBar(title: 'Duplicate', message: 'This order number already exists.');
      } else {
        HapticFeedback.mediumImpact();
        final OrderModel sale = await wooOrdersRepository.fetchOrderById(orderId: manualOrderNumber.toString());

        // checkIsSaleExist
        final OrderModel checkIsSaleExist = await saleController.getSaleByOrderId(orderId: sale.orderId!);
        if(checkIsSaleExist.id != null) {
          throw 'Sale already exist';
        }
        newSales.add(sale);
      }
    } catch(e){
      AppMassages.errorSnackBar(title: 'Error', message: 'Add manual order failed: ${e.toString()}');
    } finally{
      FullScreenLoader.stopLoading();
      isScanning(false);
    }
  }


  Future<void> handleDetection(BarcodeCapture capture) async {
    if (isScanning.value) return;
    try {
      FullScreenLoader.onlyCircularProgressDialog('Fetching Order...');
      isScanning.value = true;

      for (final barcode in capture.barcodes) {
        final value = barcode.rawValue;
        bool exists = newSales.any((order) => order.orderId.toString() == value);
        if (value != null && !exists) {
          HapticFeedback.mediumImpact();
          final OrderModel sale = await wooOrdersRepository.fetchOrderById(orderId: value);
          // checkIsSaleExist
          final OrderModel checkIsSaleExist = await saleController.getSaleByOrderId(orderId: sale.orderId!);
          if(checkIsSaleExist.id != null) {
            throw 'Sale already exist';
          }
          newSales.add(sale);
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

  Future<void> getAllNewSalesWithDialog({required BuildContext context}) async {
    try {
      DialogHelper.showDialog(
          context: context,
          title: 'Fetch Orders',
          message: 'Do you want to fetch new sales from WooCommerce?',
          actionButtonText: 'Fetch',
          toastMessage: 'New orders fetched successfully!',
          isShowLoading: false,
          onSubmit: () async {
            await getWooAllNewSales();
          }
      );
    } catch(e){
      AppMassages.errorSnackBar(title: 'Error in Orders Fetching', message: e.toString());
    }
  }


  Future<void> getWooAllNewSales() async {
    try {
        FullScreenLoader.onlyCircularProgressDialog('Fetching WooCommerce Orders...');
        int currentPage = 1;
        List<OrderModel> allFetchedOrders = [];

        // Step 1: Fetch all orders page by page
        while (true) {
          List<OrderModel> pagedOrders = await wooOrdersRepository.fetchOrdersByStatus(
            status: [OrderStatus.pendingPickup.name, OrderStatus.inTransit.name],
            page: currentPage.toString(),
          );

          if (pagedOrders.isEmpty) {
            FullScreenLoader.stopLoading();
            break;
          }

          allFetchedOrders.addAll(pagedOrders);
          currentPage++;
        }

        // Step 2: Extract non-null order IDs from fetched orders
        final List<int> fetchedOrderIds = allFetchedOrders.map((order) => order.orderId).whereType<int>().toList();

        // Step 3: Fetch existing orders from the database
        final List<OrderModel> existingOrders = await saleController.getSaleByOrderIds(orderIds: fetchedOrderIds);
        final List<OrderModel> newUniqueOrders = allFetchedOrders.where((order) {
          return order.orderId != null &&
              !existingOrders.any((existing) => existing.orderId == order.orderId);
        }).toList();

        // Step 5: Add only new unique orders and avoid adding duplicates
        for (final order in newUniqueOrders) {
          if (!newSales.any((o) => o.orderId == order.orderId)) {
            newSales.add(order);
          }
        }
        // FullScreenLoader.stopLoading();
    } catch (e) {
        rethrow;
    }
  }


  Future<void> addBarcodeSale() async {
    try {
      FullScreenLoader.onlyCircularProgressDialog('Fetching Order...');
      for (var order in newSales) {
        order.status = OrderStatus.inTransit;
        order.orderType = orderType;
        order.dateCompleted = DateTime.now();
      }
      await addSaleController.pushSales(sales: newSales);
      newSales.clear();
      Get.back();
      AppMassages.showToastMessage(message: 'Sale Added Successfully');
    } catch(e) {
      AppMassages.errorSnackBar(title: 'Error sale Sale', message: e.toString());
    } finally {
      FullScreenLoader.stopLoading();
    }
  }
}