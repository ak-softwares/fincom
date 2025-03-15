import 'package:fincom/data/repositories/mongodb/customers/customers_repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/mongodb/orders/orders_repositories.dart';
import '../../../../data/repositories/mongodb/payment/mongo_payment_methods_repo.dart';
import '../../../../data/repositories/mongodb/products/product_repositories.dart';
import '../../../../data/repositories/mongodb/vendors/vendors_repositories.dart';
import '../../../personalization/models/user_model.dart';
import '../../models/order_model.dart';
import '../../models/payment_method.dart';
import '../../models/product_model.dart';
import '../../models/vendor_model.dart';
import '../../screen_account/search/search.dart';

class SearchVoucherController extends GetxController {
  static SearchVoucherController get instance => Get.find();

  // Variable
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxInt currentPage = 1.obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<ProductModel> selectedProducts = <ProductModel>[].obs;

  RxList<VendorModel> vendors = <VendorModel>[].obs;
  Rx<VendorModel> selectedVendor = VendorModel().obs;

  RxList<PaymentMethodModel> payments = <PaymentMethodModel>[].obs;
  Rx<PaymentMethodModel> selectedPayment = PaymentMethodModel().obs;

  RxList<CustomerModel> customers = <CustomerModel>[].obs;
  RxList<OrderModel> orders = <OrderModel>[].obs;



  final mongoProductRepo = Get.put(MongoProductRepo());
  final mongoCustomersRepo = Get.put(MongoCustomersRepo());
  final mongoOrdersRepo = Get.put(MongoOrdersRepo());
  final mongoVendorsRepo = Get.put(MongoVendorsRepo());
  final mongoPaymentMethodsRepo = Get.put(MongoPaymentMethodsRepo());

  // Get all products with optional search query
  void confirmSelection({required BuildContext context, required SearchType searchType}) {
    switch (searchType) {
      case SearchType.products:
        Navigator.of(context).pop(selectedProducts.toList());
        selectedProducts.clear();
        break;
      case SearchType.customers:
        break;
      case SearchType.orders:
        break;
      case SearchType.vendor:
        Navigator.of(context).pop(selectedVendor.value);
        selectedVendor.value = VendorModel();
        break;
      case SearchType.paymentMethod:
        Navigator.of(context).pop(selectedPayment.value);
        selectedPayment.value = PaymentMethodModel();
        break;
    }
  }

  void togglePaymentSelection(PaymentMethodModel paymentMethod) {
    if (paymentMethod.paymentMethodName == selectedPayment.value.paymentMethodName) {
      selectedPayment.value = PaymentMethodModel();
    } else {
      selectedPayment.value = paymentMethod; // Select
    }
  }

  void toggleVendorSelection(VendorModel vendor) {
    if (vendor.company == selectedVendor.value.company) {
      selectedVendor.value = VendorModel();
    } else {
      selectedVendor.value = vendor; // Select
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
          return selectedProducts.length;
        case SearchType.orders:
          return selectedProducts.length;
        case SearchType.vendor:
          return selectedVendor.value.company != null ? 1 : 0;
        case SearchType.paymentMethod:
          return selectedPayment.value.paymentMethodName != null ? 1 : 0;
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
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
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
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Get all products with optional search query
  Future<void> getCustomersBySearchQuery({required String query, required int page}) async {
    try {
      if(query.isNotEmpty){
        final List<CustomerModel> fetchedCustomers = await mongoCustomersRepo.fetchCustomersBySearchQuery(query: query, page: page);
        customers.addAll(fetchedCustomers);
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
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
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Get all products with optional search query
  Future<void> getVendorsBySearchQuery({required String query, required int page}) async {
    try {
      if(query.isNotEmpty){
        final List<VendorModel> fetchedVendors = await mongoVendorsRepo.fetchVendorsBySearchQuery(query: query, page: page);
        vendors.addAll(fetchedVendors);
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Get all products with optional search query
  Future<void> getPaymentsBySearchQuery({required String query, required int page}) async {
    try {
      if(query.isNotEmpty){
        final List<PaymentMethodModel> fetchedPayments = await mongoPaymentMethodsRepo.fetchPaymentsBySearchQuery(query: query, page: page);
        payments.addAll(fetchedPayments);
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error', message: e.toString());
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
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }
}