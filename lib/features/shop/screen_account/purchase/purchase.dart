import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../utils/constants/colors.dart';
import 'purchase_entry.dart';

class Purchase extends StatelessWidget {
  const Purchase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar2(titleText: 'Purchase',),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: TColors.primaryColor,
        onPressed: () => Get.to(PurchaseEntry()),
        tooltip: 'Send WhatsApp Message',
        child: Icon(LineIcons.plus, size: 30, color: Colors.white,),
      ),
      body: SingleChildScrollView(
        child: Text('purchase'),
      ),
    );
  }
}
