import 'package:flutter/material.dart';

import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/navigation_helper.dart';


class CheckLoginScreen extends StatelessWidget {
  const CheckLoginScreen({
    super.key, this.text = 'Please Login! to access this page', this.animation = Images.pencilAnimation,
  });
  final String text;
  final String animation;

  @override
  Widget build(BuildContext context) {
    return TAnimationLoaderWidgets(
      text: text,
      animation: animation,
      showAction: true,
      actionText: 'Login',
      onActionPressed: () => NavigationHelper.navigateToLoginScreen(),
    );
  }
}