import 'package:fincom/common/layout_models/product_list_layout.dart';
import 'package:fincom/features/settings/app_settings.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/animation_loader.dart';
import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../common/widgets/shimmers/order_shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller/analytics/analytics_controller.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    final analyticsController = Get.put(AnalyticsController());

    final Widget emptyWidget = AnimationLoaderWidgets(
      text: 'Whoops! No Orders Found...',
      animation: Images.pencilAnimation,
    );

    return Scaffold(
      appBar: AppAppBar(title: 'Analytics'),
      body: RefreshIndicator(
        color: AppColors.refreshIndicator,
        onRefresh: () async => analyticsController.refreshAnalytics(),
        child: ListView(
          padding: TSpacingStyle.defaultPagePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ListLayout(
              height: 50,
              itemCount: analyticsController.short.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSizes.sm, top: AppSizes.sm, bottom: AppSizes.sm),
                  child: RoundedContainer(
                    radius: AppSizes.defaultRadius,
                    borderColor: Colors.grey,
                    showBorder: true,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Center(child: Text(analyticsController.short[index]))
                  ),
                );
              },
            ),

            Obx(() {
              if (analyticsController.isLoading.value) {
                return OrderShimmer(itemCount: 2,);
              } else {
                return Column(
                    children: [
                      // Revenue
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Heading(title: "Revenue"),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Completed"),
                                  Text("${AppSettings.currencySymbol}${analyticsController.revenueCompleted} (${analyticsController.revenueCompletedPercent}%)"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Completed"),
                                  Text("${AppSettings.currencySymbol}${analyticsController.revenueInTransit} (${analyticsController.revenueInTransitPercent}%)"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Return"),
                                  Text("${AppSettings.currencySymbol}${analyticsController.revenueReturnRevenue} (${analyticsController.revenueReturnPercent}%)"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total"),
                                  Text(AppSettings.currencySymbol + analyticsController.revenueTotal.toString()),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.spaceBtwItems),

                      // Orders
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Heading(title: "Orders"),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Completed"),
                                  Text("${analyticsController.orderCompleted} (${analyticsController.orderCompletedPercent}%)"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("In-Transit"),
                                  Text("${analyticsController.orderInTransit} (${analyticsController.orderInTransitPercent}%)"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Return"),
                                  Text("${analyticsController.orderReturnCount} (${analyticsController.orderReturnPercent}%)"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total"),
                                  Text(analyticsController.orderTotal.toString()),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.spaceBtwItems),

                      // Expenses
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Heading(title: "Expenses"),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("COGS"),
                                  Text(AppSettings.currencySymbol + analyticsController.expensesCogs.toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Shipping"),
                                  Text(AppSettings.currencySymbol + analyticsController.expensesShipping.toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Ads"),
                                  Text(AppSettings.currencySymbol + analyticsController.expensesAds.toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Rent"),
                                  Text(AppSettings.currencySymbol + analyticsController.expensesRent.toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Salary"),
                                  Text(AppSettings.currencySymbol + analyticsController.expensesSalary.toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Transport"),
                                  Text(AppSettings.currencySymbol + analyticsController.expensesTransport.toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Others"),
                                  Text(AppSettings.currencySymbol + analyticsController.expensesOthers.toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total"),
                                  Text(AppSettings.currencySymbol + analyticsController.expensesTotal.toString()),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.spaceBtwItems),

                      // Profit
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Heading(title: "Profit"),
                            Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Gross Profit"),
                                      Text(AppSettings.currencySymbol + analyticsController.grossProfit.value.toString()),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Operating Profit(EBITA)"),
                                      Text(AppSettings.currencySymbol + analyticsController.operatingProfit.value.toString()),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Net Profit(PAT)"),
                                      Text(AppSettings.currencySymbol + analyticsController.netProfit.value.toString()),
                                    ],
                                  ),
                                ]
                            )
                          ]
                      ),
                      SizedBox(height: AppSizes.spaceBtwItems),

                      // Unit Matrix
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Heading(title: "Unit Matrix"),
                            Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Average order Value(AOV)"),
                                      Text("${AppSettings.currencySymbol}100"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("COGS"),
                                      Text("${AppSettings.currencySymbol}50"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Shipping"),
                                      Text("${AppSettings.currencySymbol}40"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Ads"),
                                      Text("${AppSettings.currencySymbol}40"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Profit"),
                                      Text("${AppSettings.currencySymbol}40"),
                                    ],
                                  ),
                                ]
                            )
                          ]
                      ),
                      SizedBox(height: AppSizes.spaceBtwItems),

                      // General Matrix
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Heading(title: "General Matrix"),
                            Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Returning Customers"),
                                      Text("${AppSettings.currencySymbol}525(33%)"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("RTO of Returning Customers"),
                                      Text("${AppSettings.currencySymbol}50"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Coupon used"),
                                      Text("${AppSettings.currencySymbol}40"),
                                    ],
                                  )
                                ]
                            )
                          ]
                      ),
                      SizedBox(height: AppSizes.spaceBtwItems),

                      // Organic Referral
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Heading(title: "Organic Referral"),
                            Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Android App"),
                                      Text("100"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Organic Google"),
                                      Text("50"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Direct"),
                                      Text("${AppSettings.currencySymbol}40"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Other"),
                                      Text("${AppSettings.currencySymbol}40"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total Organic"),
                                      Text("${AppSettings.currencySymbol}40"),
                                    ],
                                  ),
                                ]
                            )
                          ]
                      ),
                      SizedBox(height: AppSizes.spaceBtwItems),

                      // Ads Referral
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Heading(title: "Ads Referral"),
                            Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Facebook"),
                                      Text("100"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Instagram"),
                                      Text("50"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Ads Google"),
                                      Text("${AppSettings.currencySymbol}40"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total Ads"),
                                      Text("${AppSettings.currencySymbol}40"),
                                    ],
                                  ),
                                ]
                            )
                          ]
                      ),
                      SizedBox(height: AppSizes.spaceBtwItems),
                    ],
                  );
              }
            }),
          ],
        ),
      ),
    );
  }
}