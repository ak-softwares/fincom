import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../controller_account/home/home_voucher_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVoucherController = Get.put(HomeVoucherController());

    return Scaffold(
      appBar: TAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Analytics", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            SizedBox(height: 16),

            Obx(() => GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                AnalyticsCard(title: "Total Orders", value: homeVoucherController.totalOrders.value.toString()),
                AnalyticsCard(title: "Total Revenue", value: "₹${homeVoucherController.totalRevenue.value.toStringAsFixed(2)}"),
                AnalyticsCard(title: "Pending Orders", value: homeVoucherController.pendingOrders.value.toString()),
                AnalyticsCard(title: "Completed Orders", value: homeVoucherController.completedOrders.value.toString()),
                AnalyticsCard(title: "Total Discount", value: "₹${homeVoucherController.totalDiscount.value.toStringAsFixed(2)}"),
              ],
            )),

            SizedBox(height: 20),

            Text("Recent Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            Expanded(
              child: Obx(() => homeVoucherController.orders.isEmpty
                  ? Center(child: Text("No orders found"))
                  : ListView.builder(
                itemCount: homeVoucherController.orders.length,
                itemBuilder: (context, index) {
                  final order = homeVoucherController.orders[index];
                  return ListTile(
                    title: Text("Order #${order.id} - ₹${order.total}"),
                    subtitle: Text("Status: ${order.status}"),
                    trailing: Text("Discount: ₹${order.discountTotal}"),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;

  AnalyticsCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 5),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
