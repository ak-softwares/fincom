import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/text/section_heading.dart';
import '../../../../../common/web_view/my_web_view.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../settings/app_settings.dart';

class PolicyWidget extends StatelessWidget {
  const PolicyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.primaryBackground,
        width: double.infinity,
        padding: TSpacingStyle.defaultPagePadding,
        child: Column(
          children: [
            const TSectionHeading(title: 'Policies', verticalPadding: false),
            const Divider(color: AppColors.primaryColor, thickness: 2),
            ListTile(
              onTap: () => Get.to(() => const MyWebView(title: 'Privacy Policy', url: AppSettings.privacyPrivacy)),
              leading: Icon(TIcons.privacyPolicy, size: 18),
              title: Text('Privacy Policy', style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text('Your data, secured.', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const MyWebView(title: 'Shipping Policy', url: AppSettings.shippingPolicy)),
              leading: Icon(TIcons.shippingPolicy, size: 18),
              title: Text('Shipping Policy', style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text('Fast, reliable delivery.', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() => const MyWebView(title: 'Terms and Conditions', url: AppSettings.termsAndConditions)),
              leading: Icon(TIcons.termsAndConditions, size: 18),
              title: Text('Terms and Conditions', style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text('Your rights, clarified.', style: Theme.of(context).textTheme.bodySmall),
            ),
            ListTile(
              onTap: () => Get.to(() =>  const MyWebView(title: 'Return Policy', url: AppSettings.refundPolicy)),
              leading: Icon(TIcons.returnPolicy, size: 18),
              title: Text('Return Policy', style: Theme.of(context).textTheme.bodyLarge),
              subtitle: Text('Easy returns, guaranteed.', style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        )
    );
  }
}
