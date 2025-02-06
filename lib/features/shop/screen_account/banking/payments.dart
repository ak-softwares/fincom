import 'package:flutter/material.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/navigation_bar/appbar2.dart';

class Payments extends StatelessWidget {
  const Payments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar2(titleText: 'Purchase',),
      body: SingleChildScrollView(
        child: Text('Payments'),
      ),
    );
  }
}