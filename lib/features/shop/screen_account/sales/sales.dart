import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../utils/constants/colors.dart';

class Sales extends StatelessWidget {
  const Sales({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar2(titleText: 'Sales',),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: TColors.primaryColor,
        onPressed: () {},
        tooltip: 'Send WhatsApp Message',
        child: Icon(LineIcons.plus, size: 30, color: Colors.white,),
      ),
      body: SingleChildScrollView(
        child: Text('sales'),
      ),
    );
  }
}