import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import 'search.dart';

class TSearchBar extends StatelessWidget {
  const TSearchBar({super.key, this.searchText = "Search", this.padding = false});

  final String? searchText;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ? const EdgeInsets.all(Sizes.spaceBtwItems) : const EdgeInsets.all(0),
      child: InkWell(
        onTap: () {
        showSearch(
            context: context,
            delegate: TSearchDelegate()
        );},
        child: Container(
          color: Colors.transparent,
          child: Container(
            width: TDeviceUtils.getScreenWidth(context),
            padding: const EdgeInsets.all(Sizes.sm),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Sizes.productImageRadius),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: TColors.secondaryColor),
                const SizedBox(width: 20),
                Text(searchText!)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
