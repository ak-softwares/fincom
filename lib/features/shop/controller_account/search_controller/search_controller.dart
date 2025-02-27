import 'package:fincom/data/repositories/mongodb/customers/customers_repositories.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/mongodb/orders/orders_repositories.dart';
import '../../../../data/repositories/mongodb/products/product_repositories.dart';
import '../../../personalization/models/user_model.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import '../../screen_account/search/search.dart';

class SearchVoucherController extends GetxController {
  static SearchVoucherController get instance => Get.find();

  // Variable
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxInt currentPage = 1.obs;
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxList<CustomerModel> customers = <CustomerModel>[].obs;
  RxList<OrderModel> orders = <OrderModel>[].obs;

  final mongoProductRepo = Get.put(MongoProductRepo());
  final mongoCustomersRepo = Get.put(MongoCustomersRepo());
  final mongoOrdersRepo = Get.put(MongoOrdersRepo());

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

  Future<void> refreshSearch({required String query, required SearchType searchType}) async {
    try {
      isLoading(true);
      currentPage.value = 1;
      products.clear();
      customers.clear();
      orders.clear();
      await getItemsBySearchQuery(query: query, searchType: searchType, page: 1);
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }
}