import 'package:flutter/material.dart';

import '../../../../../common/layout_models/product_grid_layout.dart';
import '../../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../../utils/constants/sizes.dart';

class TransactionTileShimmer extends StatelessWidget {
  const TransactionTileShimmer({
    super.key,
    this.itemCount = 1,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    const double transactionTileHeight = AppSizes.transactionTileHeight; // Updated constant
    const double transactionTileWidth = AppSizes.transactionTileWidth; // Updated constant
    const double transactionTileRadius = AppSizes.transactionTileRadius; // Updated constant

    return GridLayout(
      itemCount: itemCount,
      crossAxisCount: 1,
      mainAxisExtent: transactionTileHeight,
      itemBuilder: (context, index) {
        return Container(
          width: transactionTileWidth,
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(transactionTileRadius),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            children: [
              // Transaction ID Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Transaction ID', style: TextStyle(fontSize: 14)),
                  ShimmerEffect(width: 100, height: 10), // Shimmer for transaction ID
                ],
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),

              // Amount Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Amount', style: TextStyle(fontSize: 14)),
                  ShimmerEffect(width: 80, height: 10), // Shimmer for amount
                ],
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),

              // Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Date', style: TextStyle(fontSize: 14)),
                  ShimmerEffect(width: 120, height: 10), // Shimmer for date
                ],
              ),
              const SizedBox(height: AppSizes.spaceBtwItems),

              // Payment Method Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Payment Method', style: TextStyle(fontSize: 14)),
                  ShimmerEffect(width: 150, height: 10), // Shimmer for payment method
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}