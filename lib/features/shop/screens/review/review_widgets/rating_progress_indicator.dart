import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';

class TRatingProgressIndicator extends StatelessWidget {
  const TRatingProgressIndicator({
    super.key, required this.text, required this.value, this.color = TColors.ratingBar,
  });
  final String text;
  final double value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text(text, style: Theme.of(context).textTheme.labelMedium,)),
        const SizedBox(height: Sizes.md),
        Expanded(flex: 7,
            child: SizedBox(
              width: TDeviceUtils.getScreenWidth(context) * 0.8,
              child: LinearProgressIndicator(
                value: value,
                minHeight: 7,
                backgroundColor: Colors.grey[300],
                borderRadius: BorderRadius.circular(7),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            )
        )
      ],
    );
  }
}
