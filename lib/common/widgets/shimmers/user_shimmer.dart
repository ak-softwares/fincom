
import '/common/widgets/shimmers/shimmer_effect.dart';
import 'package:flutter/material.dart';


class UserTileShimmer extends StatelessWidget {
  const UserTileShimmer({super.key, this.itemCount = 4, this.title = ''});

  final String title;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: ClipRRect(borderRadius: BorderRadius.circular(200), child: const ShimmerEffect(width: 50, height: 50)),
      title: const ShimmerEffect(width: 200, height: 20),
      subtitle: const ShimmerEffect(width: 100, height: 15),
    );
  }
}
