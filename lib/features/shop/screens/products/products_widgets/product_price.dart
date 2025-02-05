import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../settings/app_settings.dart';
import '../scrolling_products.dart';

class ProductPrice extends StatelessWidget {
  const ProductPrice({
    super.key,
    required this.regularPrice,
    this.salePrice = 0,
    this.size = 18,
    this.orientation = OrientationType.vertical,
  });

  final double regularPrice;
  final double? salePrice;
  final double size;
  final OrientationType orientation;

  @override
  Widget build(BuildContext context) {
    final currencySymbol = AppSettings.appCurrencySymbol;
    final regularPriceText = Flexible(
      child: Text(
        '$currencySymbol${regularPrice.toStringAsFixed(0)}',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          decoration: salePrice != 0 ? TextDecoration.lineThrough : null,
          fontSize: salePrice != 0 ? size * 0.7 : size,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );

    if (salePrice == 0) return regularPriceText;

    final salePriceText = Text(
      '$currencySymbol${salePrice!.toStringAsFixed(0)}',
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: size,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
    return orientation == OrientationType.horizontal
        ? ConstrainedBox(constraints: BoxConstraints(maxWidth: 100), child: Row(children: [regularPriceText, const SizedBox(width: 4), salePriceText]))
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [regularPriceText, salePriceText]);
  }
}


