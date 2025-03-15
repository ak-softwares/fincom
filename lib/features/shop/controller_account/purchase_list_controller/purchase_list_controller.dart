import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/mongodb/purchase_list/purchase_list_repo.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../controllers/order/order_controller.dart';
import '../../models/order_model.dart';
import '../../models/purchase_item_model.dart';

class PurchaseListController extends GetxController {

  // Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isFetching = false.obs;
  RxString lastSyncDate = ''.obs;
  RxList<OrderModel> orders = <OrderModel>[].obs;
  RxList<PurchaseItemModel> products = <PurchaseItemModel>[].obs;
  RxList<OrderStatus> selectedOrderStatus = <OrderStatus>[].obs;

  RxSet<int> purchasedProductIds = <int>{}.obs;
  RxSet<int> notAvailableProductIds = <int>{}.obs;

  final storage = GetStorage();

  final orderController = Get.put(OrderController());
  final mongoPurchaseListRepo = Get.put(MongoPurchaseListRepo());

  // Using a single map to track expansion states
  var expandedSections = <String, Map<PurchaseListType, bool>>{}.obs;

  var vendorKeywords = <String, List<String>>{
    'S3A': ['one-stop', 'tweezers', '9205', 'mechanic', 'handle', '4 wire', 'multitec 07', 'bit set', 'hot air gun', 'screen separator'],
    'Krolbhag': ['850'],
    'LalKila': ['hoki', 'cell', '18650'],
    'Ac Products': ['bender'],
    'Siron': ['siron'],
    'Other': [],
  }.obs;


  @override
  void onInit() {
    super.onInit();
    loadStoredProducts(); // Load data from storage when the controller initializes
    // loadExpandedSections();

    // Listen for changes and save to storage
    ever(purchasedProductIds, (_) => saveProductsToStorage());
    ever(notAvailableProductIds, (_) => saveProductsToStorage());
    ever(expandedSections, (_) => saveExpandedSections());
  }

  // Ensure keys exist before using them
  void initializeExpansionState(String companyName) async {
    // Try to read the expansion state from local storage
    final storedExpandedSections = await storage.read(PurchaseListConstants.expandedSections);

    if (storedExpandedSections != null && storedExpandedSections.containsKey(companyName)) {
      // If the company's expansion state exists in local storage, use it
      final storedMap = Map<PurchaseListType, bool>.from(storedExpandedSections[companyName]);

      // Ensure all PurchaseListType keys exist, defaulting to false if missing
      expandedSections[companyName] = {
        PurchaseListType.vendors: storedMap[PurchaseListType.vendors] ?? false,
        PurchaseListType.purchasable: storedMap[PurchaseListType.purchasable] ?? false,
        PurchaseListType.purchased: storedMap[PurchaseListType.purchased] ?? false,
        PurchaseListType.notAvailable: storedMap[PurchaseListType.notAvailable] ?? false,
      };
    } else {
      // If the company's expansion state does not exist in local storage, initialize it with default values
      expandedSections.putIfAbsent(companyName, () => {
        PurchaseListType.vendors: false,
        PurchaseListType.purchasable: false,
        PurchaseListType.purchased: false,
        PurchaseListType.notAvailable: false,
      });
    }
  }

  void saveExpandedSections(){
    storage.write(
        PurchaseListConstants.expandedSections,
        expandedSections.map((key, value) => MapEntry(key, value.cast<PurchaseListType, bool>()))
    );
  }

  Future<void> saveProductsToStorage() async {
    await mongoPurchaseListRepo.pushMetaData(metadataName: PurchaseListConstants.purchasedProductIds, value: purchasedProductIds.toList());
    await mongoPurchaseListRepo.pushMetaData(metadataName: PurchaseListConstants.notAvailableProductIds, value: notAvailableProductIds.toList());
  }

  Future<void> loadStoredProducts() async {
    await refreshOrders();
    final fetchedPurchasedProductIds = await mongoPurchaseListRepo.fetchMetaData(metadataName: PurchaseListConstants.purchasedProductIds);
    // Convert comma-separated string to a List<int>
    purchasedProductIds.assignAll(
        fetchedPurchasedProductIds.map<int>((e) => int.tryParse(e.toString()) ?? 0).toSet()
    );

    final fetchedNotAvailableProductIds = await mongoPurchaseListRepo.fetchMetaData(metadataName: PurchaseListConstants.notAvailableProductIds);
    // Convert comma-separated string to a List<int>
    notAvailableProductIds.assignAll(
        fetchedNotAvailableProductIds.map<int>((e) => int.tryParse(e.toString()) ?? 0).toSet()
    );

    final fetchedLastSyncDate = await mongoPurchaseListRepo.fetchMetaData(metadataName: PurchaseListConstants.lastSyncDate);
    lastSyncDate.value = fetchedLastSyncDate.toString();
  }

  Future<void> clearStoredProducts() async {
    await deleteAllOrders();
    await mongoPurchaseListRepo.deleteMetaData(metadataName: PurchaseListConstants.purchasedProductIds);
    await mongoPurchaseListRepo.deleteMetaData(metadataName: PurchaseListConstants.notAvailableProductIds);
    // Also clear in-memory data
    orders.clear();
    products.clear();
    purchasedProductIds.clear();
    notAvailableProductIds.clear();
  }

  List<PurchaseItemModel> filterProductsByVendor({required String vendorName}) {
    if (vendorName == 'Other') {
      // Return products that do NOT match any defined vendor keywords
      return products.where((product) {
        return vendorKeywords.entries.every((entry) {
          if (entry.key == 'Other') return true; // Skip "Other" in checking
          return !entry.value.any((keyword) => product.name.toLowerCase().contains(keyword.toLowerCase()));
        });
      }).toList();
    }

    // For other vendors, filter products based on their keywords
    List<String>? keywords = vendorKeywords[vendorName];
    if (keywords == null || keywords.isEmpty) return [];

    return products.where((product) {
      return keywords.any((keyword) =>
          product.name.toLowerCase().contains(keyword.toLowerCase()));
    }).toList();
  }

  void getAggregatedProducts() {
    Map<int, PurchaseItemModel> productMap = {}; // Store unique products
    DateTime twoDaysAgo = DateTime.now().subtract(Duration(days: 2));

    for (var order in orders) {
      bool isPrepaidOrder = order.paymentMethod != PaymentMethods.cod.name; // Prepaid if NOT COD
      bool isBulkOrder = (order.lineItems?.length ?? 0) > 1; // Bulk if more than one item
      DateTime? orderDate = order.dateCreated != null ? DateTime.tryParse(order.dateCreated!) : null;
      bool isOlderThanTwoDays = orderDate != null && orderDate.isBefore(twoDaysAgo); // Check if older than 2 days

      for (var lineItem in order.lineItems!) {
        int productId = lineItem.productId;

        if (productMap.containsKey(productId)) {
          // If product already exists, update its quantities
          productMap[productId]!.prepaidQuantity += isPrepaidOrder ? lineItem.quantity : 0;
          productMap[productId]!.bulkQuantity += isBulkOrder ? lineItem.quantity : 0;
          productMap[productId]!.totalQuantity += lineItem.quantity;
        } else {
          // Create a new product entry
          productMap[productId] = PurchaseItemModel(
            id: productId,
            image: lineItem.image ?? '',
            name: lineItem.name ?? '',
            prepaidQuantity: isPrepaidOrder ? lineItem.quantity : 0,
            bulkQuantity: isBulkOrder ? lineItem.quantity : 0,
            totalQuantity: lineItem.quantity,
            isOlderThanTwoDays: isOlderThanTwoDays,
          );
        }
      }
    }

    // Convert map values to list and sort
    List<PurchaseItemModel> sortedProducts = productMap.values.toList()
      ..sort((a, b) {
        // Sort by prepaid quantity (Descending)
        int cmp = b.prepaidQuantity.compareTo(a.prepaidQuantity);
        if (cmp != 0) return cmp;

        // Sort by bulk quantity (Descending)
        cmp = b.bulkQuantity.compareTo(a.bulkQuantity);
        if (cmp != 0) return cmp;

        // Sort older than 2 days first
        if (b.isOlderThanTwoDays && !a.isOlderThanTwoDays) return 1;
        if (a.isOlderThanTwoDays && !b.isOlderThanTwoDays) return -1;

        // Sort by total quantity (Descending)
        return b.totalQuantity.compareTo(a.totalQuantity);
      });

    // Convert map values to list and sort by totalQuantity in descending order
    // List<PurchaseItemModel> sortedProducts = productMap.values.toL ;

    products.assignAll(sortedProducts); // Update reactive list
    // products.assignAll(productMap.values.toList()); // Update reactive list
  }

  Future<void> getAllOrdersByStatus({required List<OrderStatus> orderStatus}) async {
    try {
      //start loader
      TFullScreenLoader.openLoadingDialog('Processing your order', Images.docerAnimation);

      clearStoredProducts();
      int currentPage = 1;
      List<OrderModel> newOrders = [];

      while (true) {
        // **Step 2: Fetch a batch of orders from API**
        List<OrderModel> fetchedOrders = await orderController.getOrdersByStatus(
          status: selectedOrderStatus.map((status) => status.name).toList(),
          page: currentPage.toString(),
        );
        if (fetchedOrders.isEmpty) break; // Stop if no more orders are available

        newOrders.addAll(fetchedOrders);
        currentPage++; // Move to the next page
      }
      orders.addAll(newOrders); // Add only new orders
      getAggregatedProducts();
      await pushAllOrders();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Orders Fetching', message: e.toString());
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }

  Future<void> syncOrders({required List<OrderStatus> orderStatus}) async {
    try {
      isFetching(true);
      currentPage.value = 1; // Reset page number
      orders.clear(); // Clear existing orders
      products.clear(); // Clear existing orders
      await getAllOrdersByStatus(orderStatus: orderStatus);
      await mongoPurchaseListRepo.pushMetaData(metadataName: PurchaseListConstants.lastSyncDate, value: DateTime.timestamp());
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isFetching(false);
    }
  }

  Future<void> showDialogForSelectOrderStatus() async {
    Get.defaultDialog(
      contentPadding: EdgeInsets.only(bottom: Sizes.xl),
      titlePadding: EdgeInsets.only(top: Sizes.xl),
      radius: 10,
      title: "Choose Status",
      content: Obx(() => Column(
        children: [
          for (OrderStatus orderStatus in [OrderStatus.processing, OrderStatus.readyToShip, OrderStatus.pendingPickup])
            CheckboxListTile(
              title: Text(orderStatus.prettyName),
              value: selectedOrderStatus.contains(orderStatus),
              onChanged: (value) => toggleSelection(orderStatus),
              controlAffinity: ListTileControlAffinity.leading, // Checkbox on left
            ),
        ],
      )),
      confirm: ElevatedButton(
        onPressed: confirmSelection,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
          child: Text("Fetch Orders"),
        ),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        style: TextButton.styleFrom(
          foregroundColor: Colors.red, // Change to TColors.buttonBackground if needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Button border radius
          ),
        ),
        child: Text("Cancel"),
      ),
    );
  }

  void toggleSelection(OrderStatus orderStatus) {
    if (selectedOrderStatus.contains(orderStatus)) {
      selectedOrderStatus.remove(orderStatus);
    } else {
      selectedOrderStatus.add(orderStatus);
    }
  }

  void confirmSelection() {
    if(selectedOrderStatus.isNotEmpty){
      Get.back(); // Close the popup
      syncOrders(orderStatus: selectedOrderStatus);
    } else {
      TLoaders.errorSnackBar(title: 'Select at least one status');
    }
  }

  // Get all orders (fetch all pages iteratively)
  Future<void> getAllOrders() async {
    try {
      int page = 1; // Start with the first page
      orders.clear();
      // Fetch orders iteratively until no more orders are returned
      while (true) {
        final fetchedOrders = await mongoPurchaseListRepo.fetchOrders(page: page);
        if (fetchedOrders.isEmpty) break; // Stop if no more orders are available

        // Add fetched orders to the list
        orders.addAll(fetchedOrders);
        page++; // Move to the next page
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Orders Fetching', message: e.toString());
    }
  }

  Future<void> pushAllOrders() async {
    try {
      await mongoPurchaseListRepo.pushOrders(orders: orders);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Orders Pushing', message: e.toString());
    }
  }

  Future<void> deleteAllOrders() async {
    try {
      await mongoPurchaseListRepo.deleteAllOrders();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Delete orders', message: e.toString());
    }
  }

  Future<void> refreshOrders() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      orders.clear(); // Clear existing orders
      products.clear(); // Clear existing orders
      await getAllOrders();
      getAggregatedProducts();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }


}
