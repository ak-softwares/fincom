import 'package:get/get.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/firebase/orders/order_repository.dart';
import '../../../../data/repositories/woocommerce_repositories/orders/woo_orders_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../../personalization/controllers/address_controller.dart';
import '../../../personalization/controllers/customers_controller.dart';
import '../../../settings/app_settings.dart';
import '../../models/order_model.dart';
import '../cart_controller/cart_controller.dart';
import '../checkout_controller/checkout_controller.dart';
import '../checkout_controller/payment_controller.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  //Variables
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;

  final cartController = Get.put(CartController());
  final addressController = Get.put(AddressController());
  final checkoutController = Get.put(CheckoutController());
  final wooOrdersRepository = Get.put(WooOrdersRepository());
  final orderRepository = Get.put(OrderRepository());
  final userController = Get.put(CustomersController());
  final paymentController = Get.put(PaymentController());

  // Get All Products count
  Future<int> getTotalOrdersCount() async {
    try {
      // Fetch the total product count
      final int totalProducts = await wooOrdersRepository.fetchOrdersCount();
      return totalProducts;
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Product Count Fetching', message: e.toString());
      return 0; // Return 0 in case of an error
    }
  }

  // Get All products
  Future<List<OrderModel>> getAllOrders(String page) async {
    try{
      //fetch products
      final orders = await wooOrdersRepository.fetchAllOrders(page: page);
      return orders;
    } catch (e){
      rethrow;
    }
  }

  // Get All products
  Future<List<OrderModel>> getOrdersByStatus({required List<String> status, required String page}) async {
    try {
      // fetch products
      final orders = await wooOrdersRepository.fetchOrdersByStatus(status: status, page: page);
      return orders;
    } catch (e){
      rethrow;
    }
  }

  //Fetch orders
  Future<void> fetchOrders() async {
    try {
      final customerId = userController.customer.value.customerId.toString();
      final customerEmail = userController.customer.value.email.toString();

      final List<OrderModel> ordersByCustomerId =
          await wooOrdersRepository.fetchOrdersByCustomerId(customerId: customerId, page: currentPage.toString());
      final List<OrderModel> ordersByCustomerEmail = await wooOrdersRepository
          .fetchOrdersByCustomerEmail(customerEmail: customerEmail,page: currentPage.toString());


      final List<OrderModel> mergedOrders = [...ordersByCustomerId, ...ordersByCustomerEmail];

      // Define a function to check if two orders are equal based on some unique identifier
      bool areOrdersEqual(OrderModel order1, OrderModel order2) {
        return order1.id == order2.id; // Assuming `id` is a unique identifier for orders
      }

      // Remove duplicates from the merged list
      final List<OrderModel> uniqueOrders = [];
      for (var order in mergedOrders) {
        // Check if the order already exists in the unique orders list
        bool alreadyExists = uniqueOrders.any((existingOrder) => areOrdersEqual(existingOrder, order));
        // If the order doesn't exist in the unique orders list, add it
        if (!alreadyExists) {
          uniqueOrders.add(order);
        }
      }

      // Sort the merged orders by date
      uniqueOrders.sort((a, b) => b.parsedCreatedDate.compareTo(a.parsedCreatedDate));

      orders.addAll(uniqueOrders);
    } catch (e) {
    TLoaders.warningSnackBar(title: 'Error', message: e.toString());
    }
  }

  //Get user order by customer id
  Future<void> getOrdersByCustomerId() async {
    try {
      var customerId = userController.customer.value.customerId;
      if(customerId == null){
        await userController.refreshCustomer();
        customerId = userController.customer.value.customerId;
      }
      final newOrders = await wooOrdersRepository.fetchOrdersByCustomerId(customerId: customerId.toString(), page: currentPage.toString());
      orders.addAll(newOrders);
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Error', message: e.toString());
    }
  }

  //Get user order by customer Email
  Future<void> getOrdersByCustomerEmail() async {
    try {
      String customerEmail = userController.customer.value.email.toString();
      if(customerEmail.isEmpty){
        await userController.refreshCustomer();
        customerEmail = userController.customer.value.email.toString();
      }
      final newOrders = await wooOrdersRepository.fetchOrdersByCustomerEmail(customerEmail: customerEmail, page: currentPage.toString());
      orders.addAll(newOrders);
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Function to refresh orders
  Future<void> refreshOrders() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      orders.clear(); // Clear existing orders
      await getOrdersByCustomerId();
      // await fetchOrders();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  // Add methods for order processing
  Future<OrderModel> saveOrderByCustomerId({String transactionId = ''}) async {
    try {
      //Add Details
      final appVersion = await AppSettings.getAppVersion();
      final order = OrderModel(
        customerId: userController.customer.value.customerId,
        paymentMethod: checkoutController.selectedPaymentMethod.value.id,
        paymentMethodTitle: checkoutController.selectedPaymentMethod.value.title,
        // paymentMethod: 'Paytm Payment Gateway', //Payment method ID. 'Paytm Payment Gateway'
        // paymentMethodTitle: 'razorpay', //Payment method title.  // 'UPI/QR/Card/NetBanking' 'Paytm Payment Gateway'
        transactionId: transactionId,
        setPaid: true,
        status: OrderStatus.processing,
        billing:   userController.customer.value.billing,
        shipping:   userController.customer.value.billing, //if shipping address is different then use shipping instead billing
        lineItems:  cartController.cartItems,
        couponLines: [checkoutController.coupon.value],
        metaData: [
          OrderMedaDataModel(key: "_wc_order_attribution_source_type", value: "organic"), //referral, organic, Unknown, utm, Web Admin, typein (Direct)
          OrderMedaDataModel(key: "_wc_order_attribution_utm_source", value: "Android App v$appVersion"),
          // OrderMedaDataModel(key: "_wc_order_attribution_referrer", value: "https://www.google.com/"), //this only use for referral
          OrderMedaDataModel(key: "_wc_order_attribution_utm_medium", value: cartController.cartItems.map((item) => item.pageSource ?? 'NA').join(', ')),
          // OrderMedaDataModel(key: "_wc_order_attribution_utm_medium", value: "organic"),
        ],
      );

      //save the order to Woocommerce
      final OrderModel createdOrder = await wooOrdersRepository.createOrderByCustomerId(order);
      return createdOrder;

    } catch(error) {
      rethrow;
    }
  }

  //Cancel order
  Future<void> cancelOrder(String orderId) async {
    try {
      CartController.instance.isCancelLoading(true);
      final updatedOrder  = await wooOrdersRepository.updateStatusByOrderId(orderId, 'cancelled');
      // Find the index of the order with the matching orderId in the orders list
      final int index = orders.indexWhere((order) => order.id == updatedOrder.id);

      if (index != -1) {
        // If the order is found, replace it with the updated order
        orders[index] = updatedOrder;
      } else {
        // If the order is not found, add the updated order to the list
        orders.add(updatedOrder);
      }
    } catch (error) {
      TLoaders.errorSnackBar(title: 'Error', message: error.toString());
    } finally {
      CartController.instance.isCancelLoading(false);
    }
  }
}