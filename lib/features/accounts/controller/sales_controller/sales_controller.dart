import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/dialog_massage.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../data/repositories/mongodb/orders/orders_repositories.dart';
import '../../../../data/repositories/woocommerce/orders/woo_orders_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/order_model.dart';
import '../product/product_controller.dart';

class SaleController extends GetxController{
  static SaleController get instance => Get.find();

  // Variable
  final OrderType orderType = OrderType.sale;
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isStopped = false.obs; // New: Track if the user wants to stop syncing
  RxBool isSyncing = false.obs;
  RxBool isGettingCount = false.obs;
  RxInt processedOrders = 0.obs;
  RxInt totalProcessedOrders = 0.obs;
  RxInt fincomOrdersCount = 0.obs;
  RxInt wooOrdersCount = 0.obs;
  RxList<OrderModel> sales = <OrderModel>[].obs;
  final mongoOrderRepo = Get.put(MongoOrderRepo());
  final wooOrdersRepository = Get.put(WooOrdersRepository());
  final productsVoucherController = Get.put(ProductController());

  Future<void> syncOrders() async {
    try {
      isSyncing(true);
      isStopped(false); // Reset stop flag
      processedOrders.value = 0; // Reset progress
      totalProcessedOrders.value = 0; // Reset total compared product count

      int batchSize = 500; // Adjust based on API limits and DB capacity

      // **Step 1: Fetch Existing Product IDs Efficiently**
      Set<int> uploadedProductIds = await mongoOrderRepo.fetchOrdersIds(); // Consider paginating this

      int currentPage = 1;
      while (!isStopped.value) {
        // **Step 2: Fetch a batch of orders from API**
        List<OrderModel> orders = await wooOrdersRepository.fetchOrdersByStatus(status: [OrderStatus.pendingPickup.name, OrderStatus.inTransit.name], page: currentPage.toString());

        if (orders.isEmpty) break; // Stop if no more orders are available

        totalProcessedOrders.value += orders.length; // Track total compared orders

        // **Step 3: Filter only new orders**
        List<OrderModel> newOrders = orders.where((product) {
          return !uploadedProductIds.contains(product.orderId);
        }).toList();

        // **Step 4: Bulk Insert**
        if (newOrders.isNotEmpty) {
          for (int i = 0; i < newOrders.length; i += batchSize) {
            if (isStopped.value) {
              AppMassages.warningSnackBar(title: 'Sync Stopped', message: 'Syncing stopped by user.');
              return;
            }

            int end = (i + batchSize < newOrders.length) ? i + batchSize : newOrders.length;
            List<OrderModel> chunk = newOrders.sublist(i, end);

            await mongoOrderRepo.pushOrders(orders: chunk); // Upload chunk

            processedOrders.value += chunk.length; // Update progress
          }
        }

        currentPage++; // Move to the next page
      }

      if (!isStopped.value) {
        AppMassages.successSnackBar(title: 'Sync Complete', message: 'All new orders uploaded.');
      }
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Sync Error', message: e.toString());
    } finally {
      isSyncing(false);
    }
  }

  void stopSyncing() {
    isStopped(true);
  }

  // Get total customer count
  Future<void> getTotalOrdersCount() async {
    try {
      isGettingCount(true);
      int fincomOrdersCounts = await mongoOrderRepo.fetchOrdersCount();
      fincomOrdersCount.value = fincomOrdersCounts; // Assuming totalCustomers is an observable or state variable
      int wooOrdersCounts = await wooOrdersRepository.fetchOrdersCount();
      wooOrdersCount.value = wooOrdersCounts; // Assuming totalCustomers is an observable or state variable
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in orders Count Fetching', message: e.toString());
    } finally {
      isGettingCount(false);
    }
  }

  // Get All Sale
  Future<void> getSales() async {
    try {
      final fetchedOrders = await mongoOrderRepo.fetchOrders(orderType: orderType, page: currentPage.value);
      sales.addAll(fetchedOrders);
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in Orders Fetching', message: e.toString());
    }
  }

  Future<void> refreshSales() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      sales.clear(); // Clear existing orders
      await getSales();
    } catch (error) {
      AppMassages.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  // Get user order by id
  Future<OrderModel> getSaleById({required String saleId}) async {
    try {
      final newSale = await mongoOrderRepo.fetchOrderById(saleId: saleId);
      return newSale;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<OrderModel>> getSalesByDate({required DateTime startDate, required DateTime endDate, int page = 1}) async {
    try {
      final fetchedOrders = await mongoOrderRepo
          .fetchOrdersByDate(orderType: orderType, page: page, startDate: startDate, endDate: endDate);
      return fetchedOrders;
    } catch (e) {
      rethrow;
    }
  }

  // Get user order by id
  Future<OrderModel> getSaleByOrderId({required int orderId}) async {
    try {
      final newSale = await mongoOrderRepo.fetchOrderByOrderId(orderId: orderId, orderType: orderType);
      return newSale;
    } catch (e) {
      return OrderModel();
    }
  }

  Future<void> deleteSale({required OrderModel sale, required BuildContext context}) async {
    try {
      DialogHelper.showDialog(
          context: context,
          title: 'Delete Sale',
          message: 'Are you sure to delete this Sale?',
          actionButtonText: 'Delete',
          toastMessage: 'Sale deleted successfully!',
          onSubmit: () async {
            // Reverse product quantities before deleting the sale
            await productsVoucherController.updateProductQuantity(cartItems: sale.lineItems ?? [], isAddition: true);
            // Delete sale record
            await mongoOrderRepo.deleteOrderById(id: sale.id ?? '');
            // Refresh sale list
            await refreshSales();
            // Close the current screen after successful deletion
            Get.back();
          },
      );
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }


}