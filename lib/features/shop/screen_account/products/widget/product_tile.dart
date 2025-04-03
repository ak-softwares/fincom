import 'package:flutter/material.dart';

import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/product_model.dart';
import '../../../screens/products/product_detail.dart';
import '../../../screens/products/products_widgets/product_price.dart';
import '../../../screens/products/products_widgets/product_title_text.dart';
import '../single_product.dart';


class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    this.onTap,

  });

  final ProductModel product;
  final VoidCallback? onTap; // Make it nullable


  @override
  Widget build(BuildContext context) {
    const double productVoucherTileHeight = AppSizes.productVoucherTileHeight;
    const double productVoucherTileWidth = AppSizes.productVoucherTileWidth;
    const double productVoucherTileRadius = AppSizes.productVoucherTileRadius;
    const double productVoucherImageHeight = AppSizes.productVoucherImageHeight;
    const double productVoucherImageWidth = AppSizes.productVoucherImageWidth;

    return GestureDetector(
        onTap: onTap ?? () {
          // Default navigation when onTap is not provided
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SingleProduct(product: product)));
        },
        child: Container(
          width: productVoucherTileWidth,
          padding: const EdgeInsets.all(AppSizes.xs),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(productVoucherTileRadius),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            children: [
              // Main Image
              TRoundedImage(
                  image: product.mainImage ?? '',
                  height: productVoucherImageHeight,
                  width: productVoucherImageWidth,
                  borderRadius: productVoucherTileRadius,
                  isNetworkImage: true,
                  padding: 0
              ),

              // Title, Rating and price
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: AppSizes.sm),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductTitle(title: product.name ?? '', size: 13, maxLines: 2,),
                      // Price and Stock
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Stock - ${product.getTotalStock()}'),
                          // Price
                          Text('Price - ${product.getPrice()}'),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}










