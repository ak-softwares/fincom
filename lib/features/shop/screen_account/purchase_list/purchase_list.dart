import 'package:fincom/common/layout_models/product_grid_layout.dart';
import 'package:fincom/features/shop/models/purchase_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/styles/shadows.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/shimmers/order_shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller_account/purchase_list_controller/purchase_list_controller.dart';
import '../../screens/orders/widgets/order_list_items.dart';
import 'widget/purchase_list_item.dart';

class PurchaseList extends StatelessWidget {
  const PurchaseList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PurchaseListController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Purchase Product List', style: TextStyle(fontSize: 18)),
        actions: [
          Obx(() => Padding(
            padding: const EdgeInsets.only(right: Sizes.xl),
            child: !controller.isFetching.value
                ? InkWell(
                    onTap: () => controller.showDialogForSelectOrderStatus(),
                    child: Row(
                      spacing: Sizes.xs,
                      children: [
                        Icon(Icons.refresh, color: Colors.blue, size: 17),
                        Text('Sync', style: TextStyle(color: Colors.blue)),
                      ],
                    ),
                  )
                : Center(
                    child: SizedBox(
                      height: 15,
                      width: 15,
                      // child: Text('Fetching Orders...,', style: TextStyle(fontSize: 12)),
                      child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 2),
                    ),
                  ),
          )),
        ],
      ),
      bottomSheet: Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Total - ${controller.products.length}', style: TextStyle(fontSize: 13, color: Colors.grey),),
            Text('Purchased - ${controller.purchasedProductIds.length}', style: TextStyle(fontSize: 13, color: Colors.grey)),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: TColors.refreshIndicator,
        onRefresh: () async {
          controller.refreshOrders();
        },
        child: ListView(
          padding: TSpacingStyle.defaultPagePadding,
          children: [
            Obx(() {
              if (controller.isLoading.value) {
                return OrderShimmer(itemCount: 2);
              } else if (controller.products.isEmpty) {
                return TAnimationLoaderWidgets(
                  text: 'Whoops! No Orders Found...',
                  animation: Images.pencilAnimation,
                  showAction: true,
                  actionText: 'Sync Products',
                  onActionPress: () => controller.showDialogForSelectOrderStatus(),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.vendorKeywords.keys.length,
                  itemBuilder: (context, index) {
                    final companyName = controller.vendorKeywords.keys.elementAt(index);
                    final allVendorProducts = controller.filterProductsByVendor(vendorName: companyName);
                    final availableVendorProducts = allVendorProducts
                        .where((product) =>
                    !controller.purchasedProductIds.contains(product.id) &&
                        !controller.notAvailableProductIds.contains(product.id))
                        .toList();

                    // Initialize expanded states if not already present
                    controller.initializeExpansionState(companyName); // Ensure companyName exists

                    return availableVendorProducts.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: Sizes.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Vendor Header
                                InkWell(
                                  onTap: () {
                                    // Toggle the expansion state for a specific section
                                    controller.expandedSections[companyName]![PurchaseListType.vendors] =
                                          !controller.expandedSections[companyName]![PurchaseListType.vendors]!;

                                    // Refresh the UI
                                    controller.expandedSections.refresh();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(Sizes.defaultSpace),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface, // Use surface for a neutral background
                                      borderRadius: BorderRadius.circular(Sizes.purchaseItemTileRadius),
                                      border: Border.all(
                                        width: 1,
                                        color: Theme.of(context).colorScheme.outline, // `outline` works well for borders in flex_color_scheme
                                      ),                                    ),
                                    child: Obx(() => Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('$companyName ${allVendorProducts.length}'),
                                        Icon((controller.expandedSections[companyName]?[PurchaseListType.vendors] ?? false) ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                                      ],
                                    )),
                                  ),
                                ),

                                // Vendor Products List
                                Obx(() {
                                  if (controller.expandedSections[companyName]?[PurchaseListType.vendors] ?? false) {
                                    return Column(
                                      children: [
                                        _buildProductListSection(
                                          context: context,
                                          companyName: companyName,
                                          title: 'Purchasable',
                                          purchaseListType: PurchaseListType.purchasable,
                                          backgroundColor: Colors.green,
                                          filterCondition: (product) =>
                                              !controller.purchasedProductIds.contains(product.id) &&
                                              !controller.notAvailableProductIds.contains(product.id),
                                        ),
                                        _buildProductListSection(
                                          context: context,
                                          companyName: companyName,
                                          title: 'Purchased',
                                          purchaseListType: PurchaseListType.purchased,
                                          backgroundColor: Colors.blue,
                                          filterCondition: (product) => controller.purchasedProductIds.contains(product.id),
                                        ),
                                        _buildProductListSection(
                                          context: context,
                                          companyName: companyName,
                                          title: 'Not Available',
                                          purchaseListType: PurchaseListType.notAvailable,
                                          backgroundColor: Colors.red,
                                          filterCondition: (product) => controller.notAvailableProductIds.contains(product.id),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                }),
                              ],
                            ),
                          )
                        : SizedBox.shrink();
                  },
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListSection({
    required BuildContext context, // Added BuildContext
    required String companyName,
    required String title,
    required PurchaseListType purchaseListType,
    required Color backgroundColor,
    required bool Function(PurchaseItemModel) filterCondition,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(PurchaseListController());
    final double purchaseItemTileRadius = Sizes.purchaseItemTileRadius;

    final allVendorProducts = controller.filterProductsByVendor(vendorName: companyName);
    final filteredProducts = allVendorProducts.where(filterCondition).toList();

    final RxBool isExpanded = (controller.expandedSections[companyName]?[purchaseListType] ?? false).obs;

    if (filteredProducts.isEmpty) return SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: Sizes.spaceBtwItems),
          child: InkWell(
            onTap: () {
              controller.expandedSections[companyName]?[purchaseListType] = !isExpanded.value;
              isExpanded.value = !isExpanded.value; // Ensure UI updates
            },
            child: Container(
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              decoration: BoxDecoration(
                color: isDark ? Theme.of(context).colorScheme.surface : backgroundColor is MaterialColor ? backgroundColor.shade50 : backgroundColor.withOpacity(0.3), // Use surface for a neutral background
                borderRadius: BorderRadius.circular(Sizes.purchaseItemTileRadius),
                border: Border.all(
                  width: 1,
                  color: backgroundColor is MaterialColor ? backgroundColor.shade200 : backgroundColor.withOpacity(0.5), // Border color
                ),
              ),
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$title ${filteredProducts.length}'),
                  Icon(isExpanded.value
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                ],
              )),
            ),
          ),
        ),
        if (isExpanded.value) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return Dismissible(
                key: Key(product.id.toString()),
                direction: purchaseListType == PurchaseListType.purchasable
                  ? DismissDirection.horizontal
                  : DismissDirection.endToStart,
                onDismissed: (direction) {
                  if (purchaseListType == PurchaseListType.purchasable) {
                    if (direction == DismissDirection.endToStart) {
                      controller.purchasedProductIds.add(product.id);
                    } else if (direction == DismissDirection.startToEnd) {
                      controller.notAvailableProductIds.add(product.id);
                    }
                  }
                  if(purchaseListType == PurchaseListType.purchased) {
                    if (direction == DismissDirection.endToStart) {
                      controller.purchasedProductIds.remove(product.id);
                    }
                  }
                  if(purchaseListType == PurchaseListType.notAvailable) {
                    if (direction == DismissDirection.endToStart) {
                      controller.notAvailableProductIds.remove(product.id);
                    }
                  }
                },
                background: Padding(
                  padding: const EdgeInsets.only(top: Sizes.sm),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade900  // Dark grey for night mode
                            : Colors.grey.shade300, // Light grey for day mode
                      borderRadius: BorderRadius.circular(purchaseItemTileRadius),
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.outline, // Border color
                      )
                    ),
                    child: purchaseListType == PurchaseListType.purchasable
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Not Available'),
                        Text('Purchased'),
                        // Icon(Icons.delete, color: Colors.white),
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SizedBox.shrink(),
                        Text('Restore'),
                        Icon(Icons.restore, color: Colors.white),
                      ],
                    )
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: Sizes.sm),
                  child: InkWell(
                    onTap: () => _showRelatedOrders(context: context, productId: product.id),
                    child: PurchaseListItem(product: product, isDeleted: purchaseListType != PurchaseListType.purchasable),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  void _showRelatedOrders({required BuildContext context,  required int productId}) {
    final controller = Get.find<PurchaseListController>();

    // Filter orders that contain the selected product
    final relatedOrders = controller.orders.where((order) {
      return order.lineItems!.any((item) => item.productId == productId);
    }).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade900  // Dark mode background
          : Colors.white,          // Light mode background
      builder: (context) {
        return relatedOrders.isNotEmpty
            ? SingleChildScrollView(
                padding: TSpacingStyle.defaultPagePadding,
                child: GridLayout(
                  itemCount: relatedOrders.length,
                  crossAxisCount: 1,
                  mainAxisExtent: Sizes.orderTileHeight,
                  itemBuilder: (context, index) {
                    return SingleOrderTile(order: relatedOrders[index]);
                  },
                ),
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("No related orders found"),
                ),
              );
      },
    );
  }

}
