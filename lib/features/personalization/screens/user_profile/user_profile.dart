import 'package:cached_network_image/cached_network_image.dart';
import 'package:fincom/common/widgets/custom_shape/image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/dialog_box/dialog_massage.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/customers_controller.dart';
import '../change_profile/change_user_profile.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('user_profile_screen');

    final controller = Get.put(CustomersController());

    return Scaffold(
      appBar: const TAppBar2(titleText: 'Profile Setting', showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          ///- user image
          child: Column(
            children: [
              const SizedBox(height: Sizes.spaceBtwSection),
              Stack(
                children: [
                  TRoundedImage(
                      height: 100,
                      width: 100,
                      isNetworkImage: controller.user.value.avatarUrl != null ? true : false,
                      image: controller.user.value.avatarUrl ?? Images.tProfileImage
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                          borderRadius : BorderRadius.circular(100),
                          color: Colors.yellow// tAccentColor.withOpacity(0.1)
                      ),
                      child: IconButton(
                        onPressed: () => controller.uploadProfilePicture(context),
                        icon: const Icon(Iconsax.edit_2, size: 16, color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwSection),
              const Divider(),
              const SizedBox(height: Sizes.spaceBtwItems),
              const TSectionHeading(title: 'Profile Information', seeActionButton: false),
              const SizedBox(height: Sizes.spaceBtwItems),
              Obx(() {
                if(controller.isLoading.value){
                  return const Center(child: CircularProgressIndicator(color: TColors.linkColor),);
                } else {
                  return Column(
                    children: [
                      TProfileMenu(
                          title: 'Name',
                          value: controller.user.value.name ?? 'Name',
                          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeUserProfile()));}
                      ),
                      Divider(color: Colors.grey[200]),
                      TProfileMenu(
                          title: 'Email',
                          value: controller.user.value.email ?? "Email",
                          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeUserProfile()));}),
                      Divider(color: Colors.grey[200]),
                      TProfileMenu(
                          title: 'Phone',
                          value: controller.user.value.phone ?? 'Phone',
                          onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeUserProfile()));}),
                      const Divider(),
                      Center(
                        child: TextButton(
                            child: const Text('Delete Account', style: TextStyle(color: Colors.red),),
                            onPressed: () => DialogHelper.showDialog(
                              context: context,
                              title: 'Delete Account',
                              message: 'Are you sure you want to delete your account permanently? This Action is not reversible and all of your data will be removed permanently',
                              toastMessage: 'Your Account Deleted successfully!',
                              function: () async {
                                await controller.wooDeleteAccount();
                              },
                            ),
                        )
                      )
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class TProfileMenu extends StatelessWidget {
  const TProfileMenu({
    super.key, required this.title, required this.value, required this.onTap, this.icon = Iconsax.arrow_right_34,
  });
  final String title, value;
  final void Function() onTap;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.spaceBtwItems),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(title, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis)),
            Expanded(flex: 5, child: Text(value, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis)),
            Expanded(child: Icon(icon, size: 18,)),
          ],
        ),
      ),
    );
  }
}
