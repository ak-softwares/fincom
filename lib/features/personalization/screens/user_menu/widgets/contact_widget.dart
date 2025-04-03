import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/text/section_heading.dart';
import '../../../../../common/widgets/send_whatsapp_msg/send_whatsapp_msg.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../settings/app_settings.dart';
class SupportWidget extends StatelessWidget {
  const SupportWidget({
    super.key, this.showHeading = false,
  });

  final bool showHeading;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.primaryBackground,
        width: double.infinity,
        padding: TSpacingStyle.defaultPagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            showHeading
              ? const Column(
                  children: [
                    TSectionHeading(title: 'Support', verticalPadding: false),
                    Divider(color: AppColors.primaryColor, thickness: 2,),
                  ],
                )
              : const SizedBox.shrink(),
            ListTile(
              onTap: SendMSG.sendWhatsAppMessage,
              leading: Icon(TIcons.whatsapp, size: 20, color: const Color(0xFF25D366)),
              title: Text('Whatsapp us', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text(AppSettings.supportWhatsApp),
            ),
            ListTile(
              onTap: SendMSG.sendEmail,
              leading: Icon(TIcons.email, size: 20, color: Colors.pinkAccent),
              title: Text('Email us', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text(AppSettings.supportEmail),
            ),
            ListTile(
              onTap: SendMSG.call,
              leading: Icon(TIcons.phone, size: 20, color: Colors.cyan),
              title: Text('Call us', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
              subtitle: Text(AppSettings.supportMobile),
            ),
          ],
        )
    );
  }
}
