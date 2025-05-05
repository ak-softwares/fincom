import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/device/device_utility.dart';

class AppTabBar extends StatelessWidget implements PreferredSizeWidget{
  //if you want to to add the background color to tabs you have to wrap them in material widget.
  // to do that we need [PreferredSizeWidget] and thats why created custom class
  const AppTabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TabBar(
        tabs: tabs,
        isScrollable: true,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
