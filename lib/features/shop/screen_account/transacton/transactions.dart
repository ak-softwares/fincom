import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller_account/transaction/transaction_controller.dart';
import 'add_transaction.dart'; // Updated import
import 'widget/transaction_simmer.dart';
import 'widget/transaction_tile.dart'; // Updated import

class Transactions extends StatelessWidget {
  const Transactions({super.key});

  @override
  Widget build(BuildContext context) {
    final double transactionTileHeight = AppSizes.transactionTileHeight; // Updated constant

    final ScrollController scrollController = ScrollController();
    final transactionController = Get.put(TransactionController()); // Updated controller

    transactionController.refreshTransactions(); // Updated method

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if (!transactionController.isLoadingMore.value) {
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (transactionController.transactions.length % itemsPerPage != 0) {
            // If the length of transactions is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          transactionController.isLoadingMore(true);
          transactionController.currentPage++; // Increment current page
          await transactionController.getAllTransactions(); // Updated method
          transactionController.isLoadingMore(false);
        }
      }
    });

    final Widget emptyWidget = TAnimationLoaderWidgets(
      text: 'Whoops! No Transactions Found...', // Updated text
      animation: Images.pencilAnimation,
    );

    return Scaffold(
      appBar: const AppAppBar2(titleText: 'Transactions'), // Updated title
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        onPressed: () => Get.to(() => const AddTransaction()), // Updated navigation
        tooltip: 'Add Transaction', // Updated tooltip
        child: const Icon(LineIcons.plus, size: 30, color: Colors.white),
      ),
      body: RefreshIndicator(
        color: AppColors.refreshIndicator,
        onRefresh: () async => transactionController.refreshTransactions(), // Updated method
        child: ListView(
          controller: scrollController,
          padding: TSpacingStyle.defaultPagePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Obx(() {
              if (transactionController.isLoading.value) {
                return TransactionTileShimmer(itemCount: 2); // Updated shimmer
              } else if (transactionController.transactions.isEmpty) {
                return emptyWidget;
              } else {
                final transactions = transactionController.transactions; // Updated list
                return Column(
                  children: [
                    GridLayout(
                      itemCount: transactionController.isLoadingMore.value
                          ? transactions.length + 2
                          : transactions.length,
                      crossAxisCount: 1,
                      mainAxisExtent: transactionTileHeight, // Updated height
                      itemBuilder: (context, index) {
                        if (index < transactions.length) {
                          return TransactionTile(transaction: transactions[index]); // Updated tile
                        } else {
                          return TransactionTileShimmer(); // Updated shimmer
                        }
                      },
                    ),
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