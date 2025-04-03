import 'package:cached_network_image/cached_network_image.dart';
import 'package:fincom/common/widgets/custom_shape/image/circular_image.dart';
import 'package:fincom/features/settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../common/widgets/shimmers/user_shimmer.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../../authentication/screens/create_account/signup.dart';
import '../../controllers/customers_controller.dart';
import '../user_profile/user_profile.dart';
import 'widgets/contact_widget.dart';
import 'widgets/follow_us.dart';
import 'widgets/menu.dart';
import 'widgets/policy_widget.dart';
import 'widgets/favourite_with_cart.dart';

class UserMenuScreen extends StatelessWidget {
  const UserMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('user_menu_screen');

    final userController = Get.put(CustomersController());
    userController.refreshCustomer();

    return  Obx(() => Scaffold(
        appBar: const AppAppBar2(titleText: 'Profile Setting', seeLogoutButton: true,),
        body: !AuthenticationRepository.instance.isUserLogin.value
            ? const CheckLoginScreen()
            : RefreshIndicator(
                color: AppColors.refreshIndicator,
                onRefresh: () async => userController.refreshCustomer(),
                child: SingleChildScrollView(
                  padding: TSpacingStyle.defaultPageVertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //User profile
                      Heading(title: 'Your profile', paddingLeft: AppSizes.defaultSpace),
                      CustomerProfileCard(userController: userController, showHeading: true),

                      //Menu
                      Heading(title: 'Menu', paddingLeft: AppSizes.defaultSpace),
                      const Menu(),

                      // Not a Member? register
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Not a member?'),
                            TextButton(
                                onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));},
                                child: Text(TTexts.createAccount, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.linkColor )))
                          ]
                      ),

                      // Version
                      Center(
                        child: Column(
                          children: [
                            Text('Accounts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                            // TRoundedImage(
                            //   backgroundColor: Colors.transparent,
                            //     width: 130,
                            //     padding: 0,
                            //     image: AppSettings.lightAppLogo
                            // ),
                            Obx(() => Text('v${userController.appVersion.value}', style: TextStyle(fontSize: 12),))
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSizes.md),
                    ],
                  ),
                ),
            ),
      ),
    );
  }
}

class CustomerProfileCard extends StatelessWidget {
  const CustomerProfileCard({
    super.key,
    required this.userController, this.showHeading = false,
  });

  final bool showHeading;
  final CustomersController userController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          if(userController.isLoading.value) {
            return const UserTileShimmer();
          } else {
             return ListTile(
               onTap: () => Get.to(() => const UserProfileScreen()),
                leading: TRoundedImage(
                  padding: 0,
                  height: 40,
                  width: 40,
                  borderRadius: 100,
                  isNetworkImage: userController.user.value.avatarUrl != null ? true : false,
                  image: userController.user.value.avatarUrl ?? Images.tProfileImage
                ),
                title: Text((userController.user.value.name?.isNotEmpty ?? false) ? userController.user.value.name! : "User",),
                subtitle: Text(userController.user.value.email?.isNotEmpty ?? false ? userController.user.value.email! : 'Email',),
                trailing: Icon(Icons.arrow_forward_ios, size: 20,),
             );
          }
        }),
      ],
    );
  }

}






