import 'package:flutter/material.dart';

import '../../../features/settings/app_settings.dart';
import '../../../utils/constants/text_strings.dart';

class TProductPriceText extends StatelessWidget {
  const TProductPriceText({
    super.key,
    this.currencySign = AppSettings.appCurrencySymbol,
    required this.price,
    this.maxLines = 1,
    this.isLarge = false,
    this.lineThrough = false
  });

  final String currencySign, price;
  final int maxLines;
  final bool isLarge;
  final bool lineThrough;


  @override
  Widget build(BuildContext context) {
    return Text(
      currencySign + price,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
          ? Theme.of(context).textTheme.headlineMedium!.apply(decoration: lineThrough ? TextDecoration.lineThrough : null)
          : Theme.of(context).textTheme.titleLarge!.apply(decoration: lineThrough ? TextDecoration.lineThrough : null),
    );
  }
}
