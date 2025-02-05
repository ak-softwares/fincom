import 'package:flutter/material.dart';

import '../../../../../common/styles/shadows.dart';
import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';



class SingleCategoryTile extends StatelessWidget {
  const SingleCategoryTile({
    super.key,
    this.image = '',
    this.title = '',
    this.onTap,
  });

  final String title;
  final String image;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final double categoryImageHeight = Sizes.categoryImageHeight;
    final double categoryImageWidth  = Sizes.categoryImageWidth;
    final double categoryTileRadius  = Sizes.categoryTileRadius;
    final double categoryTileHeight  = Sizes.categoryTileHeight;
    final double categoryTileWidth  = Sizes.categoryTileWidth;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: title.isNotEmpty ? categoryTileHeight : categoryImageHeight,
        child: Column(
          children: [
            // Image
            Container(
              height: categoryImageHeight,
              width: categoryImageWidth,
              // padding: const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(categoryTileRadius),
                boxShadow: const [TShadowStyle.horizontalProductShadow],
              ),
              child: TRoundedImage(
                height: categoryImageHeight,
                width: categoryImageWidth,
                borderRadius: categoryTileRadius,
                padding: 5,
                image: image.isNotEmpty ? image : Images.defaultCategoryIcon,
                isNetworkImage: true,
                // onTap: () => Get.toNamed(banner.targetScreen),
              ),
            ),

            // Category Name
            title.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(height: Sizes.spaceBtwItems),
                      SizedBox(
                        width: categoryTileWidth,
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
