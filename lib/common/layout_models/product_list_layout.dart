import 'package:flutter/material.dart';


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
        ],
    );
  }
}

