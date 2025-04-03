import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/constants/icons.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/navigation_helper.dart';
import '../../styles/spacing_style.dart';

class TSuccessScreen extends StatelessWidget {
  const TSuccessScreen({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.onPressed
  });
  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWidthAppbarHeight *2,
          child: Column(
            children: [
              //Image
              Lottie.asset(image, width: MediaQuery.of(context).size.width * 0.6),
              const SizedBox(height: 60),

              //Title and SubTitle
              Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.spaceBtwItems),

              Text(subTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.spaceBtwSection),

              //Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(TIcons.bottomNavigationCart),
                      const SizedBox(width: AppSizes.spaceBtwInputFields),
                      const Text('Go to My Orders'),
                    ],
                  )
                ),
              ),
              const SizedBox(height: AppSizes.spaceBtwInputFields),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => NavigationHelper.navigateToBottomNavigation(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(TIcons.home),
                      const SizedBox(width: AppSizes.spaceBtwInputFields),
                      const Text('Go to Home'),
                    ],
                  )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
