import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/authentication/authentication_repository.dart';
import '../../features/personalization/controllers/user_controller.dart';
import '../../features/personalization/screens/user_menu/user_menu_screen.dart';
import '../../features/personalization/screens/user_menu/widgets/contact_widget.dart';
import '../../features/personalization/screens/user_menu/widgets/follow_us.dart';
import '../../features/personalization/screens/user_menu/widgets/menu.dart';
import '../../services/firebase_analytics/firebase_analytics.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../text/section_heading.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('drawer_menu_screen');
    final userController = Get.put(UserController());
    final authenticationRepository = Get.put(AuthenticationRepository());

    return Drawer(
      backgroundColor: TColors.secondaryBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 100,
              width: double.infinity,
              color: TColors.primaryBackground,
              padding: const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
              child: Align(alignment: Alignment.bottomRight,child: IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close),)),
            ),

            // User Profile Card
            Obx(() => authenticationRepository.isUserLogin.value
                ? Container(
                    width: double.infinity,
                    color: TColors.primaryBackground,
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
                    child: CustomerProfileCard(userController: userController),
                  )
                : const SizedBox.shrink(),
            ),
            //Menu
            // const SizedBox(height: TSizes.spaceBtwInputFields),
            const Menu(showHeading: true),

            //Support
            Container(
              color: TColors.primaryBackground,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
              child: Column(
                children: [
                  const TSectionHeading(title: 'Contact us', verticalPadding: false),
                  const Divider(color: TColors.primaryColor, thickness: 2),
                  ExpansionTile(
                    title: Text('Support', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)),
                    // initiallyExpanded: true,
                    leading: const Icon(Icons.support, size: 20),
                    subtitle: Text('Call, Email, Whatsapp us', style: Theme.of(context).textTheme.bodySmall,),
                    children: const [
                      SupportWidget(),
                    ],
                  ),
                ],
              ),
            ),

            //Follow us
            const SizedBox(height: Sizes.spaceBtwInputFields),
            const FollowUs(),
            const SizedBox(height: Sizes.spaceBtwInputFields),
          ],
        ),
      ),
    );
  }
}
