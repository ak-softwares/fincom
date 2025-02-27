import 'package:fincom/features/shop/models/order_model.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/mongodb/orders/orders_repositories.dart';
import '../../../../utils/constants/enums.dart';
import '../../controllers/order/order_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../../models/product_model.dart';

class SalesVoucherController extends GetxController{
  static SalesVoucherController get instance => Get.find();

  // Variable
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
  RxList<OrderModel> orders = <OrderModel>[].obs;
  final mongoOrdersRepo = Get.put(MongoOrdersRepo());
  final orderController = Get.put(OrderController());

  Future<void> syncOrders() async {
    try {
      isSyncing(true);
      isStopped(false); // Reset stop flag
      processedOrders.value = 0; // Reset progress
      totalProcessedOrders.value = 0; // Reset total compared product count

      int batchSize = 500; // Adjust based on API limits and DB capacity

      // **Step 1: Fetch Existing Product IDs Efficiently**
      Set<int> uploadedProductIds = await mongoOrdersRepo.fetchOrdersIds(); // Consider paginating this

      int currentPage = 1;
      while (!isStopped.value) {
        // **Step 2: Fetch a batch of orders from API**
        List<OrderModel> orders = await orderController.getOrdersByStatus(status: [OrderStatus.pendingPickup.name, OrderStatus.inTransit.name], page: currentPage.toString());

        if (orders.isEmpty) break; // Stop if no more orders are available

        totalProcessedOrders.value += orders.length; // Track total compared orders

        // **Step 3: Filter only new orders**
        List<OrderModel> newOrders = orders.where((product) {
          return !uploadedProductIds.contains(product.id);
        }).toList();

        // **Step 4: Bulk Insert**
        if (newOrders.isNotEmpty) {
          for (int i = 0; i < newOrders.length; i += batchSize) {
            if (isStopped.value) {
              TLoaders.warningSnackBar(title: 'Sync Stopped', message: 'Syncing stopped by user.');
              return;
            }

            int end = (i + batchSize < newOrders.length) ? i + batchSize : newOrders.length;
            List<OrderModel> chunk = newOrders.sublist(i, end);

            await mongoOrdersRepo.pushOrders(orders: chunk); // Upload chunk

            processedOrders.value += chunk.length; // Update progress
          }
        }

        currentPage++; // Move to the next page
      }

      if (!isStopped.value) {
        TLoaders.successSnackBar(title: 'Sync Complete', message: 'All new orders uploaded.');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Sync Error', message: e.toString());
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
      int fincomOrdersCounts = await mongoOrdersRepo.fetchOrdersCount();
      fincomOrdersCount.value = fincomOrdersCounts; // Assuming totalCustomers is an observable or state variable
      int wooOrdersCounts = await orderController.getTotalOrdersCount();
      wooOrdersCount.value = wooOrdersCounts; // Assuming totalCustomers is an observable or state variable
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in orders Count Fetching', message: e.toString());
    } finally {
      isGettingCount(false);
    }
  }

  // Get All orders
  Future<void> getAllOrders() async {
    try {
      final fetchedOrders = await mongoOrdersRepo.fetchOrders(page: currentPage.value);
      orders.addAll(fetchedOrders);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Orders Fetching', message: e.toString());
    }
  }

  Future<void> refreshOrders() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      orders.clear(); // Clear existing orders
      await getAllOrders();
      await getTotalOrdersCount();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

}