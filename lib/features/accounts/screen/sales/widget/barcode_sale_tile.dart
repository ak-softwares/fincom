import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/formatters/formatters.dart';
import '../../../../../utils/helpers/order_helper.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../settings/app_settings.dart';
import '../../../models/order_model.dart';
import '../../../../../common/web_view/my_web_view.dart';
import '../../orders/widgets/order_image_gallery.dart';
import '../single_sale.dart';

class BarcodeSaleTile extends StatelessWidget {
  const BarcodeSaleTile({
    super.key,
    required this.orderId,
    this.amount,
    this.color,
    this.leadingIcon = Icons.qr_code,
    required this.onClose,
  });

  final int orderId;
  final int? amount;
  final IconData leadingIcon;
  final VoidCallback onClose;
  final Color? color;

  @override
  Widget build(BuildContext context) {

    return Container(
      color: color ?? Theme.of(context).colorScheme.surface,
      child: ListTile(
        leading: Icon(leadingIcon),
        title: Row(
          spacing: AppSizes.spaceBtwItems,
          children: [
            Text('#$orderId'),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: orderId.toString()));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order Id copied')),
                );
              },
              child: const Icon(Icons.copy, size: 17),
            )
          ],
        ),
        subtitle: Text(amount != null ? '${AppSettings.currencySymbol}$amount' : ''),
        trailing: IconButton(
          icon: const Icon(Icons.close, size: 20),
          onPressed: onClose,
        ),
      ),
    );
  }
}