import 'dart:convert';
import 'dart:typed_data';

import 'package:fincom/features/shop/models/order_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/mongodb/orders/orders_repositories.dart';
import '../../../../utils/constants/enums.dart';
import '../../controllers/order/order_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../../models/product_model.dart';

class NewOrderFoundController extends GetxController{
  static NewOrderFoundController get instance => Get.find();

  // Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isStopped = false.obs; // New: Track if the user wants to stop syncing
  RxBool isUploading = false.obs;
  RxBool isGettingCount = false.obs;
  RxInt processedOrders = 0.obs;
  RxInt totalProcessedOrders = 0.obs;
  RxInt fincomOrdersCount = 0.obs;
  RxInt wooOrdersCount = 0.obs;
  RxSet<int> selectedOrders = RxSet<int>(); // Track selected orders
  RxList<OrderModel> orders = <OrderModel>[].obs;
  RxList<OrderModel> parentOrders  = <OrderModel>[].obs;
  final mongoOrdersRepo = Get.put(MongoOrdersRepo());
  final orderController = Get.put(OrderController());

  // Function to select all orders
  void selectAll() {
    selectedOrders.addAll(parentOrders.map((order) => order.id ?? 0));
  }

  // Function to deselect all orders
  void deselectAll() {
    selectedOrders.clear();
  }

  // Function to toggle "Select All"
  void toggleSelectAll() {
    if (selectedOrders.length == parentOrders.length) {
      deselectAll();
    } else {
      selectAll();
    }
  }

  void toggleSelection(int id) {
    if (selectedOrders.contains(id)) {
      selectedOrders.remove(id);
    } else {
      selectedOrders.add(id);
    }
  }

  void deleteSelectedOrders() {
    parentOrders.removeWhere((order) => selectedOrders.contains(order.id));
    orders.assignAll(parentOrders);
    selectedOrders.clear();
  }

  void searchOrders(String query) {
    if (query.isEmpty) {
      orders.assignAll(parentOrders); // Restore all orders when query is empty
      return;
    }

    Future.delayed(Duration(milliseconds: 300), () {
      orders.assignAll(
        parentOrders.where((order) =>
        order.id.toString().contains(query) ||
            (order.billing?.firstName?.toLowerCase().contains(query) ?? false) ||
            (order.billing?.email?.toLowerCase().contains(query) ?? false) ||
            (order.billing?.phone?.contains(query) ?? false)
        ).toList(),
      );
    });
  }




  Future<void> uploadSelectedOrders() async {
    try {
      isUploading(true);
      // **Step 1: Filter only selected orders**
      List<OrderModel> selectedOrderList = parentOrders.where((order) {
        return selectedOrders.contains(order.id);
      }).toList();

      // **Step 2: Bulk Insert**
      if (selectedOrderList.isNotEmpty) {
        await mongoOrdersRepo.pushOrders(orders: selectedOrderList); // Upload selected orders
      }
      deleteSelectedOrders();
      getTotalOrdersCount();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in upload', message: e.toString());
    } finally {
      isUploading(false);
    }
  }

  Future<void> syncOrders() async {
    try {
      isUploading(true);
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
      isUploading(false);
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
      // int wooOrdersCounts = await orderController.getTotalOrdersCount();
      wooOrdersCount.value = parentOrders.length; // Assuming totalCustomers is an observable or state variable
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in orders Count Fetching', message: e.toString());
    } finally {
      isGettingCount(false);
    }
  }

  Future<void> getAllNewOrders() async {
    try {
      // **Step 1: Fetch Existing Order IDs Efficiently**
      Set<int> uploadedOrdersIds = await mongoOrdersRepo.fetchOrdersIds(); // Consider paginating this

      int currentPage = 1;
      List<OrderModel> newOrders = [];

      while (true) {
        // **Step 2: Fetch a batch of orders from API**
        List<OrderModel> fetchedOrders = await orderController.getOrdersByStatus(
          status: [OrderStatus.pendingPickup.name, OrderStatus.inTransit.name],
          page: currentPage.toString(),
        );

        if (fetchedOrders.isEmpty) break; // Stop if no more orders are available

        // **Step 3: Filter only new orders**
        List<OrderModel> filteredOrders = fetchedOrders.where((order) {
          return !uploadedOrdersIds.contains(order.id);
        }).toList();

        if (filteredOrders.isNotEmpty) {
          newOrders.addAll(filteredOrders);
        }

        currentPage++; // Move to the next page
      }

      orders.addAll(newOrders); // Add only new orders
      parentOrders.assignAll(newOrders);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Orders Fetching', message: e.toString());
    }
  }

  void printOrdersMemorySize(List<OrderModel> orders) {
    try {
      String jsonString = jsonEncode(orders); // Convert orders to JSON
      int sizeInBytes = Uint8List.fromList(utf8.encode(jsonString)).length; // Measure UTF-8 byte size

      print("Estimated memory size of orders: $sizeInBytes bytes");
      print("Memory Size: ${(sizeInBytes/1024).toStringAsFixed(4)} KB");
    } catch (e) {
      print("Error calculating memory size: $e");
    }
  }

  Future<void> refreshOrders() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      orders.clear(); // Clear existing orders
      await getAllNewOrders();
      await getTotalOrdersCount();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }
}