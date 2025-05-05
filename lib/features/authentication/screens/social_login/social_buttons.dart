import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/social_login_controller/social_login_controller.dart';
class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key, this.isCircular = false,
  });

  final bool isCircular;
  @override
  Widget build(BuildContext context) {
    final socialLoginController = Get.put(SocialLoginController());
    return isCircular
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Google Button
              Container(
                decoration : BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(100)
                ),
                child: IconButton(
                  onPressed: () => socialLoginController.signInWithGoogle(),
                  // onPressed: () => GoogleAuth.googleLogin(),
                  icon: const Image(
                      height: AppSizes.iconMd,
                      width: AppSizes.iconMd,
                      image: AssetImage(Images.google)
                  ),
                ),
              ),
              // const SizedBox(width: TSizes.spaceBtwSection),
              // //facebook Button
              // Container(
              //   decoration : BoxDecoration(
              //       border: Border.all(color: Colors.grey),
              //       borderRadius: BorderRadius.circular(100)
              //   ),
              //   child: IconButton(
              //     onPressed: () {},
              //     // onPressed: () => FacebookAuthLogin.facebookLogin(),
              //     icon: const Image(
              //         height: TSizes.iconMd,
              //         width: TSizes.iconMd,
              //         image: AssetImage(TImages.facebook)
              //     ),
              //   ),
              // ),
            ],
          )
        : Column(
            children: [
              //Google Button
              OutlinedButton(
                  onPressed: () => socialLoginController.signInWithGoogle(),
                  style: OutlinedButton.styleFrom(
                      alignment: Alignment.center,
                      side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          height: AppSizes.iconMd,
                          width: AppSizes.iconMd,
                          image: AssetImage(Images.google)
                      ),
                      SizedBox(width: AppSizes.inputFieldSpace),
                      Text('Login with Google')
                    ],
                  )
              ),
              // const SizedBox(height: TSizes.spaceBtwInputFields),
              // // facebook Button
              // OutlinedButton(
              //     onPressed: () {},
              //     // onPressed: () => FacebookAuthLogin.facebookLogin(),
              //     style: OutlinedButton.styleFrom(
              //       alignment: Alignment.center,
              //       side: const BorderSide(color: Colors.grey),
              //     ),
              //     child: const Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Image(
              //             height: TSizes.iconMd,
              //             width: TSizes.iconMd,
              //             image: AssetImage(TImages.facebook)
              //         ),
              //         SizedBox(width: TSizes.spaceBtwInputFields),
              //         Text('Singin with Facebook')
              //       ],
              //     )
              // ),
            ],
    );
  }
}