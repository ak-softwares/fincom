import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../data/repositories/mongodb/accounts/mongo_account_repo.dart';
import '../../../../data/repositories/mongodb/orders/orders_repositories.dart';
import '../../../../data/repositories/mongodb/products/product_repositories.dart';
import '../../../../data/repositories/mongodb/user/user_repositories.dart';
import '../../../../utils/constants/enums.dart';
import '../../../personalization/models/user_model.dart';
import '../../models/order_model.dart';
import '../../models/payment_method.dart';
import '../../models/product_model.dart';
import '../vendor/vendor_controller.dart';

class SearchVoucherController extends GetxController {
  static SearchVoucherController get instance => Get.find();

  // Variable
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxInt currentPage = 1.obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<ProductModel> selectedProducts = <ProductModel>[].obs;

  RxList<UserModel> vendors = <UserModel>[].obs;
  Rx<UserModel> selectedVendor = UserModel().obs;

  RxList<UserModel> customers = <UserModel>[].obs;
  Rx<UserModel> selectedCustomer = UserModel().obs;

  RxList<AccountModel> payments = <AccountModel>[].obs;
  Rx<AccountModel> selectedPayment = AccountModel().obs;

  RxList<OrderModel> orders = <OrderModel>[].obs;



  final mongoProductRepo = Get.put(MongoProductRepo());
  final mongoUserRepository = Get.put(MongoUserRepository());
  final mongoOrdersRepo = Get.put(MongoOrderRepo());
  final vendorController = Get.put(VendorController());
  final mongoPaymentMethodsRepo = Get.put(MongoAccountsRepo());

  // Get all products with optional search query
  void confirmSelection({required BuildContext context, required SearchType searchType}) {
    switch (searchType) {
      case SearchType.products:
        Navigator.of(context).pop(selectedProducts.toList());
        selectedProducts.clear();
        break;
      case SearchType.customers:
        Navigator.of(context).pop(selectedCustomer.value);
        selectedCustomer.value = UserModel();
        break;
      case SearchType.orders:
        break;
      case SearchType.vendor:
        Navigator.of(context).pop(selectedVendor.value);
        selectedVendor.value = UserModel();
        break;
      case SearchType.paymentMethod:
        Navigator.of(context).pop(selectedPayment.value);
        selectedPayment.value = AccountModel();
        break;
    }
  }

  void togglePaymentSelection(AccountModel paymentMethod) {
    if (paymentMethod.accountName == selectedPayment.value.accountName) {
      selectedPayment.value = AccountModel();
    } else {
      selectedPayment.value = paymentMethod; // Select
    }
  }

  void toggleVendorSelection(UserModel vendor) {
    if (vendor.company == selectedVendor.value.company) {
      selectedVendor.value = UserModel();
    } else {
      selectedVendor.value = vendor; // Select
    }
  }

  void toggleCustomerSelection(UserModel customer) {
    if (customer.userId == selectedCustomer.value.userId) {
      selectedCustomer.value = UserModel();
    } else {
      selectedCustomer.value = customer; // Select
    }
  }

  // Toggle product selection
  void toggleProductSelection(ProductModel product) {
    if (selectedProducts.contains(product)) {
      selectedProducts.remove(product); // Deselect
    } else {
      selectedProducts.add(product); // Select
    }
  }

  // Get all products with optional search query
  int getItemsCount({required SearchType searchType}) {
      switch (searchType) {
        case SearchType.products:
          return selectedProducts.length;
        case SearchType.customers:
          return selectedCustomer.value.company != null ? 1 : 0;
        case SearchType.orders:
          return selectedProducts.length;
        case SearchType.vendor:
          return selectedVendor.value.company != null ? 1 : 0;
        case SearchType.paymentMethod:
          return selectedPayment.value.accountName != null ? 1 : 0;
      }
  }

  // Get all products with optional search query
  Future<void> getItemsBySearchQuery({required String query, required SearchType searchType, required int page}) async {
    try {
      if(query.isNotEmpty) {
        switch (searchType) {
          case SearchType.products:
            await getProductsBySearchQuery(query: query, page: page);
            break;
          case SearchType.customers:
            await getCustomersBySearchQuery(query: query, page: page);
            break;
          case SearchType.orders:
            await getOrdersBySearchQuery(query: query, page: page);
            break;
          case SearchType.vendor:
            await getVendorsBySearchQuery(query: query, page: page);
            break;
          case SearchType.paymentMethod:
            await getPaymentsBySearchQuery(query: query, page: page);
            break;
        }
      }
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Get all products with optional search query
  Future<void> getProductsBySearchQuery({required String query, required int page}) async {
    try {
      if(query.isNotEmpty) {
        final fetchedProducts = await mongoProductRepo.fetchProductsBySearchQuery(query: query, page: page);
        products.addAll(fetchedProducts);
      }
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Get all products with optional search query
  Future<void> getCustomersBySearchQuery({required String query, required int page}) async {
    try {
      if(query.isNotEmpty){
        final List<UserModel> fetchedCustomers = await mongoUserRepository.fetchUsersBySearchQuery(query: query, userType: UserType.customer, page: page);
        customers.addAll(fetchedCustomers);
      }
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Get all products with optional search query
  Future<void> getOrdersBySearchQuery({required String query, required int page}) async {
    try {
      if(query.isNotEmpty){
        final List<OrderModel> fetchedOrders = await mongoOrdersRepo.fetchOrdersBySearchQuery(query: query, page: page);
        orders.addAll(fetchedOrders);
      }
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Get all products with optional search query
  Future<void> getVendorsBySearchQuery({required String query, required int page}) async {
    try {
      if(query.isNotEmpty){
        final List<UserModel> fetchedVendors = await vendorController.getVendorsSearchQuery(query: query, page: page);
        vendors.addAll(fetchedVendors);
      }
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Get all products with optional search query
  Future<void> getPaymentsBySearchQuery({required String query, required int page}) async {
    try {
      if(query.isNotEmpty){
        final List<AccountModel> fetchedPayments = await mongoPaymentMethodsRepo.fetchAccountsBySearchQuery(query: query, page: page);
        payments.addAll(fetchedPayments);
      }
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> refreshSearch({required String query, required SearchType searchType}) async {
    try {
      isLoading(true);
      currentPage.value = 1;
      products.clear();
      customers.clear();
      orders.clear();
      vendors.clear();
      await getItemsBySearchQuery(query: query, searchType: searchType, page: 1);
    } catch (error) {
      AppMassages.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }
}