import 'dart:io';

import 'package:fincom/common/layout_models/product_list_layout.dart';
import 'package:fincom/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:fincom/common/widgets/custom_shape/image/circular_image.dart';
import 'package:fincom/features/shop/screen_account/purchase/purchase_entry/widget/search_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../data/repositories/image/image_kit_repo.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/formatters/formatters.dart';
import '../../../settings/app_settings.dart';
import '../../controller_account/purchase/purchase_controller.dart';
import '../../models/payment_method.dart';
import '../../models/product_model.dart';
import '../../models/vendor_model.dart';
import '../payments/widget/payment_tile.dart';
import '../search/search.dart';
import '../vendor/widget/vendor_tile.dart';
import 'widget/product_tile.dart';

class AddNewPurchase extends StatelessWidget {
  const AddNewPurchase({super.key});

  @override
  Widget build(BuildContext context) {
    const double purchaseProductTileHeight = Sizes.purchaseProductTileHeight;
    final purchaseController = Get.put(PurchaseController());

    return Scaffold(
      appBar: TAppBar2(titleText: 'Add new purchase'),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.md),
        child: ElevatedButton(
          onPressed: () => purchaseController.savePurchase(),
          child: Text('Add Purchase')
        ),
      ),
      body: SingleChildScrollView(
        padding: TSpacingStyle.defaultPagePadding,
        child: Column(
          spacing: Sizes.spaceBtwSection,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date and Voucher number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Voucher Number - '),
                    Obx(() => Text(purchaseController.purchaseNumber.value.toString())),
                  ],
                ),
                ValueListenableBuilder(
                  valueListenable: purchaseController.dateController,
                  builder: (context, value, child) {
                    return InkWell(
                      onTap: () => purchaseController.selectDate(context),
                      child: Row(
                        children: [
                          Text('Date - '),
                          Text(TFormatter.formatStringDate(purchaseController.dateController.text),
                            style: TextStyle(color: TColors.linkColor),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),

            // Vendor
            Column(
              spacing: Sizes.spaceBtwItems,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Vendor'),
                    InkWell(
                      onTap: () async {
                        // Navigate to the search screen and wait for the result
                        final VendorModel getSelectedVendor = await showSearch(context: context,
                          delegate: SearchVoucher1(
                              searchType: SearchType.vendor,
                              selectedItems: purchaseController.selectedVendor.value
                          ),
                        );
                        // If products are selected, update the state
                        if (getSelectedVendor.company != null) {
                          purchaseController.addVendor(getSelectedVendor);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add, color: TColors.linkColor),
                          Text('Add', style:  TextStyle(color: TColors.linkColor),)
                        ],
                      ),
                    ),
                  ],
                ),
                Obx(() => purchaseController.selectedVendor.value.company != '' && purchaseController.selectedVendor.value.company != null
                    ? Dismissible(
                          key: Key(purchaseController.selectedVendor.value.company ?? ''), // Unique key for each item
                          direction: DismissDirection.endToStart, // Swipe left to remove
                          onDismissed: (direction) {
                            purchaseController.selectedVendor.value = VendorModel();
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vendor removed")),);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: SizedBox(width: double.infinity, child: VendorTile(vendor: purchaseController.selectedVendor.value))
                      )
                    : SizedBox.shrink(),
                ),
              ],
            ),

            // Invoice Number
            Row(
              spacing: 50,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Invoice Number'),
                Expanded(
                  child: TextFormField(
                    controller: purchaseController.invoiceNumberController,
                    // validator: (value) => TValidator.validateEmptyText(value),
                      decoration: const InputDecoration(
                          labelText: 'Invoice Number'
                      )
                  ),
                ),
              ],
            ),

            // Products
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: Sizes.spaceBtwItems,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Products'),
                    InkWell(
                      onTap: () async {
                        // Navigate to the search screen and wait for the result
                        final List<ProductModel> getSelectedProducts = await showSearch(context: context,
                          delegate: SearchVoucher1(searchType: SearchType.products),
                        );
                        // If products are selected, update the state
                        if (getSelectedProducts.isNotEmpty) {
                          purchaseController.addProducts(getSelectedProducts);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add, color: TColors.linkColor),
                          Text('Add', style:  TextStyle(color: TColors.linkColor),)
                        ],
                      ),
                    ),
                  ],
                ),
                Obx(() => GridLayout(
                    itemCount: purchaseController.selectedProducts.length,
                    crossAxisCount: 1,
                    mainAxisExtent: purchaseProductTileHeight,
                    itemBuilder: (context, index) {
                      return Dismissible(
                          key: Key(purchaseController.selectedProducts[index].id.toString()), // Unique key for each item
                          direction: DismissDirection.endToStart, // Swipe left to remove
                          onDismissed: (direction) {
                            purchaseController.removeProducts(purchaseController.selectedProducts[index]);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item removed")),);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: SizedBox(
                              width: double.infinity,
                              child: PurchaseProductCard(
                                  cartItem: purchaseController.selectedProducts[index],
                                  controller: purchaseController,
                              )
                          )
                      );
                    }
                )),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Product Count - ${(purchaseController.selectedProducts.length).toStringAsFixed(0)}'),
                    Text('Total - ${AppSettings.appCurrencySymbol + (purchaseController.purchaseTotal.value).toStringAsFixed(0)}'),
                  ],
                ))
              ],
            ),

            // Payment
            Column(
              spacing: Sizes.spaceBtwItems,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Payment Method'),
                    InkWell(
                      onTap: () async {
                        // Navigate to the search screen and wait for the result
                        final PaymentMethodModel getSelectedPayment = await showSearch(context: context,
                          delegate: SearchVoucher1(searchType: SearchType.paymentMethod),
                        );
                        // If products are selected, update the state
                        if (getSelectedPayment.paymentMethodName != null) {
                          purchaseController.selectedPaymentMethod(getSelectedPayment);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add, color: TColors.linkColor),
                          Text('Add', style:  TextStyle(color: TColors.linkColor),)
                        ],
                      ),
                    ),
                  ],
                ),
                Obx(() => purchaseController.selectedPaymentMethod.value.paymentMethodName != '' && purchaseController.selectedPaymentMethod.value.paymentMethodName != null
                    ? Dismissible(
                          key: Key(purchaseController.selectedPaymentMethod.value.paymentMethodName ?? ''), // Unique key for each item
                          direction: DismissDirection.endToStart, // Swipe left to remove
                          onDismissed: (direction) {
                            purchaseController.selectedPaymentMethod.value = PaymentMethodModel();
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Method removed")),);
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: SizedBox(width: double.infinity, child: PaymentMethodTile(paymentMethod: purchaseController.selectedPaymentMethod.value))
                      )
                    : SizedBox.shrink(),
                ),
              ],
            ),
            // Payment mad
            Row(
              spacing: 50,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Payment Amount'),
                Expanded(
                  child: TextFormField(
                      controller: purchaseController.paymentAmountController,
                      // validator: (value) => TValidator.validateEmptyText(value),
                      decoration: const InputDecoration(
                          labelText: 'Enter Amount'
                      )
                  ),
                ),
              ],
            ),

            // Image of Invoice
            Column(
              spacing: Sizes.spaceBtwItems,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Upload Invoice Image'),
                Obx(() => ListLayout(
                    height: 150,
                    itemCount: purchaseController.purchaseInvoiceImages.length + 1,
                    itemBuilder: (context, index) {
                      if(index == purchaseController.purchaseInvoiceImages.length) { //if index is last index
                        return InkWell(
                          onTap: purchaseController.pickImage,
                          child: TRoundedContainer(
                              backgroundColor: Theme.of(context).colorScheme.surface,
                              radius: 15,
                              height: 150,
                              width: 100,
                              child: Icon(Iconsax.image, color: Theme.of(context).colorScheme.onSurfaceVariant)
                          ),
                        );
                      } else {
                        return Obx(() => Padding(
                              padding: EdgeInsets.only(right: Sizes.sm),
                              child: Stack(
                                children: [
                                  TRoundedImage(
                                    height: 150,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    backgroundColor: Theme.of(context).colorScheme.surface,
                                    borderRadius: 15,
                                    isFileImage: true,
                                    image: purchaseController.purchaseInvoiceImages[index].image?.path ?? '',
                                    isTapToEnlarge: true,
                                  ),
                                  Positioned(
                                      top: -5,
                                      right: -5,
                                      child: IconButton(onPressed: () => purchaseController.deleteImage(purchaseController.purchaseInvoiceImages[index]), icon: Icon(Icons.cancel), color: Colors.grey.shade200.withOpacity(0.8))
                                  ),
                                  Positioned(
                                      bottom: 10,
                                      left: 5,
                                      right: 5, // This ensures it's centered horizontally
                                      child: SizedBox(
                                          height: 30,
                                          child: purchaseController.purchaseInvoiceImages[index].imageUrl == null || purchaseController.purchaseInvoiceImages[index].imageUrl!.isEmpty
                                              ? ElevatedButton(
                                                    onPressed: () => purchaseController.uploadImage(purchaseController.purchaseInvoiceImages[index]),
                                                    style: ButtonStyle(
                                                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 5, vertical: 0)), // Padding
                                                      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12, fontWeight: FontWeight.w500)), // Text Style
                                                      fixedSize: MaterialStateProperty.all(Size(80, 25)), // Set width & height Set width & height
                                                    ),
                                                    child: !purchaseController.isUploadingImage.value
                                                        ? Row(
                                                            mainAxisSize: MainAxisSize.min, // Ensures row takes only required space
                                                            spacing: Sizes.xs,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text('Upload'),
                                                              Icon(Icons.upload, color: Colors.white, ),
                                                            ],
                                                          )
                                                        : SizedBox(height: 10, width: 10, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,))
                                                )
                                              : TextButton(
                                                    onPressed: () => purchaseController.deleteImage(purchaseController.purchaseInvoiceImages[index]),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors.red,
                                                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                                      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
                                                      fixedSize: Size(80, 25),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))), // Remove rounded corners
                                                    ),
                                                    child: !purchaseController.isDeletingImage.value
                                                        ? Row(
                                                      mainAxisSize: MainAxisSize.min, // Ensures row takes only required space
                                                      spacing: Sizes.xs,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text('Delete', style: TextStyle(color: Colors.white),),
                                                        Icon(Icons.delete, color: Colors.white),
                                                      ],
                                                    )
                                                  : SizedBox(height: 10, width: 10, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,))
                                          )
                                      )
                                  )
                                ],
                              )
                          ),
                        );
                      }
                    }
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

