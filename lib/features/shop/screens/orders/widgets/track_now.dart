import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/web_view/my_web_view.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class TrackOrderWidget extends StatelessWidget {
  const TrackOrderWidget({
    super.key, required this.orderId,
  });
  final String orderId;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Get.to(() => MyWebView(title: 'Track Order #$orderId', url: APIConstant.wooTrackingUrl + orderId)),
        // onTap: () => launchUrlString(APIConstant.wooTrackingUrl + orderId),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Track now', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(width: AppSizes.sm),
            const Icon(Icons.open_in_new, size: 18, color: AppColors.linkColor),
          ],
        )
    );
  }
}
