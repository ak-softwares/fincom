import 'package:flutter/material.dart';

import '../../features/settings/app_settings.dart';
import '../../features/shop/screens/search/search.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/device/device_utility.dart';
import '../widgets/product/cart/cart_counter_icon.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget{
  const TAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    return AppBar(
      centerTitle: true,
      title: Text('Accounts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      // title: const Image(image: AssetImage(AppSettings.lightAppLogo), height: 25),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
                context: context,
                delegate: TSearchDelegate()
            );
          },
        ),
      ],
      // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
    );
  }

  @override
  //implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}

class TAppBar1 extends StatelessWidget implements PreferredSizeWidget{
  const TAppBar1({super.key});

  @override
  Widget build(BuildContext context) {

    return AppBar(
      centerTitle: false,
      // backgroundColor: TColors.primaryColor,

      title: const Image(image: AssetImage(AppSettings.darkAppLogo), height: 40),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          color: AppColors.secondaryColor,
          onPressed: () {
            showSearch(
                context: context,
                delegate: TSearchDelegate()
            );
          },
        ),
        const TCartCounterIcon(iconColor: AppColors.secondaryColor),
      ],
      // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
    );
  }

  @override
  //implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}