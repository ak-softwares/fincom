import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/accounts/controller/image/image_controller.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../shimmers/shimmer_effect.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({
    super.key,
    this.width = 35,
    this.height = 35,
    this.overlayColor,
    required this.image,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.padding = 0,
    this.isNetworkImage = false,
    this.isTapToEnlarge = false,
    this.isFileImage = false,
    this.borderRadius = 0,
    this.onTap,
    this.border,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final bool isTapToEnlarge;
  final bool isFileImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding, borderRadius;
  final BoxBorder? border;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final imagesController = Get.put(ImagesController());

    return InkWell(
      onTap: isTapToEnlarge ? () => imagesController.showEnlargedImage(image) : onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: isNetworkImage
              ? CachedNetworkImage(
                  fit: fit,
                  color: overlayColor,
                  imageUrl: image != '' ? image : Images.defaultWooPlaceholder,
                  progressIndicatorBuilder: (context, url, downloadProgress) => ShimmerEffect(width: width, height: height, radius: 0),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Image(
                  fit: fit,
                  color: overlayColor,
                  image: isFileImage
                      ? FileImage(File(image)) as ImageProvider // Local file path
                      : AssetImage(image) as ImageProvider, // Asset image
                ),
        ),
      ),
    );
  }
}
