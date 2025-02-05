import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/repositories/authentication/authentication_repository.dart';
import '../../features/settings/app_settings.dart';
import '../../features/shop/screens/search/search.dart';
import '../../services/share/share.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/icons.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/device/device_utility.dart';
import '../widgets/product/cart/cart_counter_icon.dart';

class TAppBar2 extends StatelessWidget implements PreferredSizeWidget{
  const TAppBar2({
    super.key,
    required this.titleText,
    this.showBackArrow = false,
    this.showCartIcon = false,
    this.showSearchIcon = false,
    this.seeLogoutButton = false,
    this.sharePageLink = "",
  });

  final String titleText;
  final bool showBackArrow;
  final bool showCartIcon;
  final bool showSearchIcon;
  final bool seeLogoutButton;
  final String sharePageLink;

  @override
  Widget build(BuildContext context) {
    const Color color = TColors.secondaryColor;
    const Color backgroundColor = TColors.primaryBackground;
    return AppBar(
      centerTitle: false,
      backgroundColor: backgroundColor,
      title: Text(titleText, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: color, fontWeight: FontWeight.w600)),
      actions: [
            showSearchIcon ? IconButton( icon: Icon(TIcons.search), color: color, onPressed: () => showSearch(context: context, delegate: TSearchDelegate())) : const SizedBox.shrink(),
            sharePageLink.isNotEmpty
                ? IconButton(
                    icon: Icon(TIcons.share),
                    color: color,
                    onPressed: () => AppShare.shareUrl(
                        url: sharePageLink,
                        contentType: 'Category',
                        itemName: titleText,
                        itemId:  ''
                    ),
                  )
                : const SizedBox.shrink(),
            showCartIcon ? const TCartCounterIcon(iconColor: color) : const SizedBox.shrink(),
            Obx(() => AuthenticationRepository.instance.isUserLogin.value && seeLogoutButton
                ? InkWell(
                    onTap: () => AuthenticationRepository.instance.logout(),
                    child: Row(
                      children: [
                        const Text('Logout'),
                        const SizedBox(width: Sizes.sm),
                        Icon(TIcons.logout, size: 20),
                        const SizedBox(width: Sizes.sm),
                      ],
                    )
                  )
                : const SizedBox.shrink(),
            ),
        ],
      leading: showBackArrow ? IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Iconsax.arrow_left, color: color)) :  null,
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}