import 'package:get/get.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/mongodb/orders/orders_repositories.dart';
import '../../models/order_model.dart';

class HomeVoucherController extends GetxController {
  RxList<OrderModel> orders = <OrderModel>[].obs; // Orders list
  RxInt totalOrders = 0.obs;
  RxDouble totalRevenue = 0.0.obs;
  RxInt pendingOrders = 0.obs;
  RxInt completedOrders = 0.obs;
  RxDouble totalDiscount = 0.0.obs;
  final mongoOrdersRepo = Get.put(MongoOrdersRepo());

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final fetchedOrders = await mongoOrdersRepo.fetchOrders(page: 1);
      orders.assignAll(fetchedOrders);
      calculateAnalytics();
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Error in Orders Fetching', message: e.toString());
    }
  }

  void calculateAnalytics() {
    totalOrders.value = orders.length;
    totalRevenue.value = orders.fold(0.0, (sum, order) => sum + double.tryParse(order.total ?? "0")!);
    pendingOrders.value = orders.where((order) => order.status == "pending").length;
    completedOrders.value = orders.where((order) => order.status == "completed").length;
    totalDiscount.value = orders.fold(0.0, (sum, order) => sum + double.tryParse(order.discountTotal ?? "0")!);
  }
}
