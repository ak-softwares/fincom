import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/mongodb/customers/customers_repositories.dart';
import '../../../../data/repositories/mongodb/products/product_repositories.dart';
import '../../../personalization/controllers/customers_controller.dart';
import '../../../personalization/models/user_model.dart';
import '../../controllers/product/product_controller.dart';
import '../../models/product_model.dart';

class CustomersVoucherController extends GetxController{
  static CustomersVoucherController get instance => Get.find();

  // Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isStopped = false.obs; // New: Track if the user wants to stop syncing
  RxBool isSyncing = false.obs;
  RxBool isGettingCount = false.obs;
  RxInt processedCustomers = 0.obs;
  RxInt totalProcessedCustomers = 0.obs;
  RxInt fincomCustomersCount = 0.obs;
  RxInt wooCustomersCount = 0.obs;
  RxList<CustomerModel> customers = <CustomerModel>[].obs;
  final mongoCustomersRepo = Get.put(MongoCustomersRepo());
  final customersController = Get.put(CustomersController());

  Future<void> syncCustomers() async {
    try {
      isSyncing(true);
      isStopped(false); // Reset stop flag
      processedCustomers.value = 0; // Reset progress
      totalProcessedCustomers.value = 0; // Reset total compared customers count

      int batchSize = 500; // Adjust based on API limits and DB capacity

      // **Step 1: Fetch Existing Customer IDs Efficiently**
      Set<int> uploadedCustomerIds = await mongoCustomersRepo.fetchCustomersIds(); // Consider paginating this

      int currentPage = 1;
      while (!isStopped.value) {
        // **Step 2: Fetch a batch of customers from API**
        List<CustomerModel> customers = await customersController.getAllCustomers(currentPage.toString());

        if (customers.isEmpty) break; // Stop if no more customers are available

        totalProcessedCustomers.value += customers.length; // Track total compared customers

        // **Step 3: Filter only new customers**
        List<CustomerModel> newCustomers = customers.where((customer) {
          return !uploadedCustomerIds.contains(customer.id);
        }).toList();

        // **Step 4: Bulk Insert**
        if (newCustomers.isNotEmpty) {
          for (int i = 0; i < newCustomers.length; i += batchSize) {
            if (isStopped.value) {
              TLoaders.warningSnackBar(title: 'Sync Stopped', message: 'Syncing stopped by user.');
              return;
            }

            int end = (i + batchSize < newCustomers.length) ? i + batchSize : newCustomers.length;
            List<CustomerModel> chunk = newCustomers.sublist(i, end);

            await mongoCustomersRepo.pushCustomers(customers: chunk); // Upload chunk

            processedCustomers.value += chunk.length; // Update progress
          }
        }

        currentPage++; // Move to the next page
      }

      if (!isStopped.value) {
        TLoaders.successSnackBar(title: 'Sync Complete', message: 'All new customers uploaded.');
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
  Future<void> getTotalCustomerCount() async {
    try {
      isGettingCount(true);
      int fincomCustomersCounts = await mongoCustomersRepo.fetchCustomerCount();
      fincomCustomersCount.value = fincomCustomersCounts;
      int wooCustomersCounts = await customersController.getTotalCustomerCount();
      wooCustomersCount.value = wooCustomersCounts;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Customer Count Fetching', message: e.toString());
    } finally {
      isGettingCount(false);
    }
  }

  // Get All products
  Future<void> getAllCustomers() async {
    try {
      final fetchedCustomers = await mongoCustomersRepo.fetchAllCustomers(page: currentPage.value);
      customers.addAll(fetchedCustomers);
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
    }
  }

  Future<void> refreshCustomers() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      customers.clear(); // Clear existing orders
      await getAllCustomers();
      await getTotalCustomerCount();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

}