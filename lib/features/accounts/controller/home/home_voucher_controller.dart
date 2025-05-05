import 'package:get/get.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../data/repositories/mongodb/orders/orders_repositories.dart';
import '../../models/order_model.dart';

class HomeController extends GetxController {
  RxList<OrderModel> orders = <OrderModel>[].obs; // Orders list
  RxInt pendingOrders = 0.obs;
  RxDouble totalDiscount = 0.0.obs;
  final mongoOrdersRepo = Get.put(MongoOrderRepo());

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      // final fetchedOrders = await mongoOrdersRepo.fetchOrders(page: 1);
      // orders.assignAll(fetchedOrders);
      calculateAnalytics();
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error in Orders Fetching', message: e.toString());
    }
  }

  void calculateAnalytics() {
    totalOrders.value = orders.length;
    pendingOrders.value = orders.where((order) => order.status == "pending").length;
    completedOrders.value = orders.where((order) => order.status == "completed").length;
    totalDiscount.value = orders.fold(0.0, (sum, order) => sum + double.tryParse(order.discountTotal ?? "0")!);
  }

  var totalRevenue = 762727.obs;
  var completedRevenue = 505071.obs;
  var rtoRevenue = 257656.obs;

  var totalOrders = 1040.obs;
  var completedOrders = 674.obs;
  var rtoOrders = 368.obs;

  var cogs = 231793.obs;
  var shipping = 113895.obs;
  var facebookAds = 41000.obs;
  var googleAds = 16400.obs;
  var rent = 3000.obs;
  var travel = 6000.obs;
  var profit = 92983.obs;

  var returningCustomers = 92.obs;
  var rtoReturningCustomers = 21.obs;
  var couponUsed = 40.obs;

  var referralSources = {
    "Referral": 770,
    "Android App": 146,
    "Organic Google": 69,
    "Direct": 79,
    "Other": 11,
    "Facebook": 275,
    "Instagram": 49,
    "Google Ads": 134
  }.obs;
}
