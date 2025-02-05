import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/styles/shadows.dart';
import '../../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';



class SingleBrandTile extends StatelessWidget {
  const SingleBrandTile({
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
    final double brandImageHeight = Sizes.brandImageHeight;
    final double brandImageWidth = Sizes.brandImageWidth;
    final double brandTileHeight = Sizes.brandTileHeight;
    final double brandTileWidth = Sizes.brandTileWidth;
    final double brandTileRadius = Sizes.brandTileRadius;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: title.isNotEmpty ? brandTileHeight : brandImageHeight,
        child: Column(
          children: [
            // image
            Container(
              height: brandImageHeight,
              width: brandImageWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(brandTileRadius),
                boxShadow: const [TShadowStyle.horizontalProductShadow],
              ),
              child: TRoundedImage(
                height: brandImageHeight,
                width: brandImageWidth,
                borderRadius: brandTileRadius,
                padding: 5,
                image: image.isNotEmpty ? image : Images.defaultCategoryIcon,
                isNetworkImage: true,
              ),
            ),

            // Name
            title.isNotEmpty
                ? Column(
                  children: [
                    const SizedBox(height: Sizes.spaceBtwItems),
                    SizedBox(
                        width: brandTileWidth,
                        child: Text(
                          title ?? '',
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 12),
                          maxLines: 1,
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
