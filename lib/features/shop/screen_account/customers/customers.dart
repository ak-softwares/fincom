import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../utils/constants/colors.dart';
import '../purchase/purchase_entry.dart';

class Customers extends StatelessWidget {
  const Customers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar2(titleText: 'Customers',),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: TColors.primaryColor,
        onPressed: () => Get.to(PurchaseEntry()),
        tooltip: 'Send WhatsApp Message',
        child: Icon(LineIcons.plus, size: 30, color: Colors.white,),
      ),
      body: SingleChildScrollView(
        child: Text('Customers'),
      ),
    );
  }
}
