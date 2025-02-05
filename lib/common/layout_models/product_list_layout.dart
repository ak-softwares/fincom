import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';

import '../../features/shop/models/product_model.dart';
import '../../features/shop/screens/all_products/all_products.dart';
import '../../features/shop/screens/products/scrolling_products.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../text/section_heading.dart';
import '../widgets/loaders/animation_loader.dart';
import '../widgets/product/product_cards/product_card.dart';
import '../widgets/shimmers/product_shimmer.dart';

class ListLayout extends StatelessWidget {
  const ListLayout({super.key, this.height, required this.itemCount, required this.itemBuilder, this.controller,});

  final double? height;
  final int itemCount;
  final ScrollController? controller;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          SizedBox(
            height: height,
            // width: double.infinity,
            child: ListView.separated(
              controller: controller,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: itemCount,
              separatorBuilder: (BuildContext context, int index) => SizedBox(width: 0),
              itemBuilder: itemBuilder
            ),
          ),
          // Positioned(
          //     left: 7,
          //     height: height,
          //     child: Icon(Iconsax.arrow_left_2, color: Colors.grey[400], size: 22)
          // ),
          // Positioned(
          //     right: 7,
          //     height: height,
          //     child: Icon(Iconsax.arrow_right_34, color: Colors.grey[400], size: 22)
          // )
        ],
    );
  }
}

