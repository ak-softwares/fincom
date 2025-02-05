import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
class TLoaders  extends GetxController {

  static hideSnackBar() => ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static customToast({required message, String urlTitle = 'view page', VoidCallback? onTap,}) {
    // Remove any existing toast before showing a new one
    hideSnackBar();
    ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
            elevation: 0,
            duration: const Duration(milliseconds: 1500),
            backgroundColor: Colors.transparent,
            content: Container(
              padding: const EdgeInsets.all(12.0),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.shade400.withOpacity(0.9),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Center(
                      child: Text(message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  onTap != null
                      ? InkWell(
                    onTap: onTap,
                    child: Text(urlTitle, style: const TextStyle(color: TColors.linkColor, fontSize: 14, fontWeight: FontWeight.w500),),
                  )
                      : SizedBox.shrink()
                ],
              ),
            )
        )
    );
  }

  static successSnackBar({required String title, String message = ''}) {
    // Remove any existing snackbar before showing a new one
    hideSnackBar();
    // Show the new snackbar with custom design
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(milliseconds: 2000),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.md),
            color: Colors.green.shade600,
          ),
          child: Column(
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              Text(message, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400))
            ],
          ),

        ),
      ),
    );
  }

  static warningSnackBar({required String title, String message = ''}) {
    // Remove any existing snackbar before showing a new one
    hideSnackBar();
    // Show the new snackbar with custom design
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(milliseconds: 3000),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.md),
            color: Colors.orange.shade600,
          ),
          child: Column(
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              Text(message, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400))
            ],
          ),

        ),
      ),
    );
  }

  static errorSnackBar({required String title, String message = ''}) {
    // Remove any existing snackbar before showing a new one
    hideSnackBar();
    // Show the new snackbar with custom design
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(milliseconds: 5000),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.md),
            color: Colors.red.shade600,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              Text(message, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400))
            ],
          ),

        ),
      ),
    );
  }

  static errorSnackBar1({required String title, String message = ''}) {
    // Remove any existing snackbar before showing a new one
    hideSnackBar();

    // Show the new snackbar
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: Colors.white,),
    );
  }
}