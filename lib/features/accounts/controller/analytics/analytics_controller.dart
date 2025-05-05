import 'package:fincom/utils/constants/enums.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../models/order_model.dart';
import '../sales_controller/sales_controller.dart';

class AnalyticsController extends GetxController {
  List<String> short = [
    'Today',
    'Yesterday',
    'Last 7 Days',
    'Last 30 Days',
    'Last 90 Days',
    'Last Month',
    'Last Year',
    'Custom',
  ];

  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  RxString selectedOption = 'Today'.obs;

  RxList<OrderModel> sales = <OrderModel>[].obs;
  Rx<DateTime?> customStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> customEndDate = Rx<DateTime?>(null);

  final saleController = Get.put(SaleController());

  @override
  void onInit() {
    super.onInit();
    // Auto-fetch when selection changes
    ever(selectedOption, (_) => getSalesByShortcut());
  }

  // Revenue stats
  double get revenueTotal => sales.fold(0, (sum, order) => sum + (order.total ?? 0));

  double get revenueCompleted => sales.where((o) => o.status == OrderStatus.completed).fold(0, (sum, o) => sum + (o.total ?? 0));
  int get revenueCompletedPercent => revenueTotal == 0 ? 0 : ((revenueCompleted / revenueTotal) * 100).round();

  double get revenueInTransit => sales.where((o) => o.status == OrderStatus.inTransit).fold(0, (sum, o) => sum + (o.total ?? 0));
  int get revenueInTransitPercent => revenueTotal == 0 ? 0 : ((revenueInTransit / revenueTotal) * 100).round();

  double get revenueReturnRevenue => sales.where((o) => o.status == OrderStatus.returnInTransit).fold(0, (sum, o) => sum + (o.total ?? 0));
  int get revenueReturnPercent => revenueTotal == 0 ? 0 : ((revenueReturnRevenue / revenueTotal) * 100).round();

  // Orders stats
  int get orderTotal => sales.length;

  int get orderCompleted => sales.where((o) => o.status == OrderStatus.completed).length;
  int get orderCompletedPercent => orderTotal == 0 ? 0 : ((orderCompleted / orderTotal) * 100).round();

  int get orderInTransit => sales.where((o) => o.status == OrderStatus.inTransit).length;
  int get orderInTransitPercent => orderTotal == 0 ? 0 : ((orderInTransit / orderTotal) * 100).round();

  int get orderReturnCount => sales.where((o) => o.status == OrderStatus.returnInTransit).length;
  int get orderReturnPercent => orderTotal == 0 ? 0 : ((orderReturnCount / orderTotal) * 100).round();

  // Expenses
  RxDouble expensesCogs = 200.0.obs;
  RxDouble expensesShipping = 100.0.obs;
  RxDouble expensesAds = 100.0.obs;
  RxDouble expensesRent = 20.0.obs;
  RxDouble expensesSalary = 50.0.obs;
  RxDouble expensesTransport = 50.0.obs;
  RxDouble expensesOthers = 30.0.obs;

  double get expensesTotal =>
      expensesCogs.value +
          expensesShipping.value +
          expensesAds.value +
          expensesRent.value +
          expensesSalary.value +
          expensesTransport.value +
          expensesOthers.value;

  // Profit
  // Example: dynamically calculated based on sales and expenses
  RxDouble grossProfit = 0.0.obs;
  RxDouble operatingProfit = 0.0.obs;
  RxDouble netProfit = 0.0.obs;

  // Call this method after sales and expenses are set/updated
  void calculateProfits({double operatingCost = 10, double tax = 5}) {
    grossProfit.value = totalRevenue - expensesCogs.value;
    operatingProfit.value = grossProfit.value - operatingCost; // e.g., marketing, admin
    netProfit.value = operatingProfit.value - tax;
  }

  double get totalRevenue {
    // Example: based on completed sales only
    final completedOrders = sales.where((o) => o.status == OrderStatus.completed);
    return completedOrders.fold(0.0, (sum, o) => sum + (o.total ?? 0));
  }


  void setCustomDateRange(DateTime start, DateTime end) {
    customStartDate.value = start;
    customEndDate.value = end;
    if (selectedOption.value == 'Custom') {
      getSalesByShortcut();
    }
  }

  Future<void> refreshAnalytics() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      sales.clear(); // Clear existing orders
      await getSalesByShortcut();
    } catch (error) {
      AppMassages.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> getSalesByShortcut() async {
    try {
      final now = DateTime.now();
      late DateTime startDate;
      late DateTime endDate;

      switch (selectedOption.value) {
        case 'Today':
          startDate = DateTime(now.year, now.month, now.day);
          endDate = now;
          break;
        case 'Yesterday':
          final yesterday = now.subtract(Duration(days: 1));
          startDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
          endDate = DateTime(now.year, now.month, now.day).subtract(Duration(seconds: 1));
          break;
        case 'Last 7 Days':
          startDate = now.subtract(Duration(days: 6));
          endDate = now;
          break;
        case 'Last 30 Days':
          startDate = now.subtract(Duration(days: 29));
          endDate = now;
          break;
        case 'Last 90 Days':
          startDate = now.subtract(Duration(days: 89));
          endDate = now;
          break;
        case 'Last Month':
          final firstDay = DateTime(now.year, now.month - 1, 1);
          final lastDay = DateTime(now.year, now.month, 1).subtract(Duration(seconds: 1));
          startDate = firstDay;
          endDate = lastDay;
          break;
        case 'Last Year':
          startDate = DateTime(now.year - 1, 1, 1);
          endDate = DateTime(now.year - 1, 12, 31, 23, 59, 59);
          break;
        case 'Custom':
          if (customStartDate.value == null || customEndDate.value == null) {
            AppMassages.errorSnackBar(
              title: 'Custom Dates Missing',
              message: 'Please select both start and end dates.',
            );
            return;
          }
          startDate = customStartDate.value!;
          endDate = customEndDate.value!;
          break;
        default:
          return;
      }

      final fetchedOrders = await saleController.getSalesByDate(
        startDate: startDate,
        endDate: endDate,
        page: 1,
      );
      sales.assignAll(fetchedOrders);
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}
