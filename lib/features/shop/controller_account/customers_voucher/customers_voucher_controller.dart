import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box/dialog_massage.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/customers/customers_repositories.dart';
import '../../../../data/repositories/mongodb/products/product_repositories.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../personalization/controllers/customers_controller.dart';
import '../../../personalization/models/address_model.dart';
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

  RxInt customerId = 0.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final countryController = TextEditingController();
  GlobalKey<FormState> customerFormKey = GlobalKey<FormState>();

  @override
  Future<void> onInit() async {
    super.onInit();
    customerId.value = await mongoCustomersRepo.fetchCustomerGetNextId();
  }

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
          return !uploadedCustomerIds.contains(customer.customerId);
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
      // await getTotalCustomerCount();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  // Get Customer by ID
  Future<CustomerModel> getCustomerByID({required String id}) async {
    try {
      final fetchedCustomer = await mongoCustomersRepo.fetchCustomerById(id: id);
      return fetchedCustomer;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in getting customer', message: e.toString());
      return CustomerModel.empty(); // Return an empty customer model in case of failure
    }
  }

  Future<void> deleteCustomer({required String id, required BuildContext context}) async {
    try {
      DialogHelper.showDialog(
        context: context,
        title: 'Delete Customer',
        message: 'Are you sure you want to delete this customer?',
        function: () async { await mongoCustomersRepo.deleteCustomer(id: id); },
        toastMessage: 'Deleted successfully!',
      );
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  void saveCustomer() {
    AddressModel address = AddressModel(
      phone: phoneController.text,
      email: emailController.text,
      address1: address1Controller.text,
      address2: address2Controller.text,
      city: cityController.text,
      state: stateController.text,
      pincode: pincodeController.text,
      country: countryController.text,
    );

    CustomerModel customer = CustomerModel(
      customerId: customerId.value,
      firstName: nameController.text,
      email: emailController.text,
      billing: address,
      dateCreated: DateTime.now().toString(),
    );

    addCustomer(customer: customer);
  }

  Future<void> addCustomer({required CustomerModel customer}) async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('We are adding customer..', Images.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!customerFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      final fetchedCustomerId = await mongoCustomersRepo.fetchCustomerGetNextId();
      if (fetchedCustomerId != customerId.value) {
        throw 'Customer ID mismatch!';
      }

      await mongoCustomersRepo.pushCustomer(customer: customer);
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Customer added successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  void resetValue(CustomerModel customer) {
    customerId.value = customer.customerId ?? 0;
    nameController.text = customer.name ?? '';
    emailController.text = customer.email ?? '';
    phoneController.text = customer.phone ?? '';

    address1Controller.text = customer.billing?.address1 ?? '';
    address2Controller.text = customer.billing?.address2 ?? '';
    cityController.text = customer.billing?.city ?? '';
    stateController.text = customer.billing?.state ?? '';
    pincodeController.text = customer.billing?.pincode ?? '';
    countryController.text = customer.billing?.country ?? '';
  }

  void saveUpdatedCustomer({required CustomerModel previousCustomer}) {
    AddressModel address = AddressModel(
      phone: phoneController.text,
      email: emailController.text,
      address1: address1Controller.text,
      address2: address2Controller.text,
      city: cityController.text,
      state: stateController.text,
      pincode: pincodeController.text,
      country: countryController.text,
    );

    CustomerModel customer = CustomerModel(
      id: previousCustomer.id,
      customerId: previousCustomer.customerId,
      firstName: nameController.text,
      email: emailController.text,
      billing: address,
      dateCreated: previousCustomer.dateCreated,
    );

    updateCustomer(customer: customer);
  }

  Future<void> updateCustomer({required CustomerModel customer}) async {
    try {
      // Start Loading
      TFullScreenLoader.openLoadingDialog('We are updating customer..', Images.docerAnimation);

      // Check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!customerFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      await mongoCustomersRepo.updateCustomer(id: customer.id ?? '', customer: customer);
      TFullScreenLoader.stopLoading();
      TLoaders.customToast(message: 'Customer updated successfully!');
      Navigator.of(Get.context!).pop();
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}

