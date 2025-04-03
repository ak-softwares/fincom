import 'package:fincom/features/shop/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../features/shop/screens/products/scrolling_products.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/navigation_helper.dart';
import '../widgets/loaders/animation_loader.dart';
import '../widgets/product/product_cards/product_card.dart';
import '../widgets/product/product_voucher/product_voucher_card.dart';
import '../widgets/shimmers/product_shimmer.dart';
import '../widgets/shimmers/product_voucher_shimmer.dart';

class ProductGridLayout extends StatelessWidget {
  const ProductGridLayout({
    super.key,
    required this.controller,
    this.sourcePage = '',
    this.orientation = OrientationType.vertical,
    this.emptyWidget = const TAnimationLoaderWidgets(text: 'Whoops! No products found...', animation: Images.pencilAnimation),
    this.onTap,
  });

  final dynamic controller;
  final String sourcePage;
  final OrientationType orientation;
  final Widget emptyWidget;
  final ValueChanged<ProductModel>? onTap;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return  ProductVoucherShimmer(itemCount: 2, orientation: orientation);
      } else if(controller.products.isEmpty) {
        return emptyWidget;
      } else {
        final products = controller.products;
        return GridLayout(
          itemCount: controller.isLoadingMore.value ? products.length + 2 : products.length,
          crossAxisCount: orientation == OrientationType.vertical ? 2 : 1,
          mainAxisExtent: orientation == OrientationType.vertical ? AppSizes.productCardVerticalHeight : AppSizes.productVoucherTileHeight,
          itemBuilder: (context, index) {
            if (index < products.length) {
              return ProductVoucherCard(
                  product: products[index],
                  orientation: orientation,
                  pageSource: sourcePage,
                  onTap: () => onTap?.call(products[index]), // Pass the product directly
              );
            } else {
              return ProductVoucherShimmer(orientation: orientation);
            }
          }
        );
      }
    });
  }
}

class GridLayout extends StatelessWidget {
  const GridLayout({
    super.key,
    required this.itemCount,
    this.crossAxisCount = 1,
    this.crossAxisSpacing = AppSizes.defaultSpaceBWTCard,
    this.mainAxisSpacing = AppSizes.defaultSpaceBWTCard,
    required this.mainAxisExtent,
    required this.itemBuilder,
    this.onDelete,
    this.onEdit,
  });

  final int itemCount, crossAxisCount;
  final double mainAxisExtent, crossAxisSpacing, mainAxisSpacing;
  final Widget Function(BuildContext, int) itemBuilder;
  final void Function(int)? onDelete;
  final void Function(int)? onEdit;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          mainAxisExtent: mainAxisExtent
      ),
      cacheExtent: 50, // Keeps items in memory
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return itemBuilder(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: Text("Edit"),
              onTap: () {
                Navigator.pop(context);
                if (onEdit != null) onEdit!(index);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text("Delete"),
              onTap: () {
                Navigator.pop(context);
                if (onDelete != null) onDelete!(index);
              },
            ),
          ],
        );
      },
    );
  }
}