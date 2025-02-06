import 'package:flutter/material.dart';

import '../../../../common/navigation_bar/appbar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(),
      body: SingleChildScrollView(
        child: Text('Home'),
      ),
    );
  }
}