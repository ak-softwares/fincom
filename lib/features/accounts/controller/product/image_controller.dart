import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/sizes.dart';
import '../../models/product_model.dart';

class ImagesController extends GetxController{
  static ImagesController get instance => Get.find();
  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    controller = TransformationController();
  }

  // show popup image
  void showEnlargedImage (String image) {
    Get.dialog(
        Dialog.fullscreen(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.defaultSpace * 2, horizontal: AppSizes.defaultSpace),
              child: GestureDetector(
                onDoubleTapDown: (details) => tapDownDetails = details,
                onDoubleTap: () {
                  final position = tapDownDetails!.localPosition;
                  const double scale = 3;
                  final x = -position.dx * (scale -1);
                  final y = -position.dy * (scale -1);
                  final zoomed = Matrix4.identity()
                    ..translate(x, y)
                    ..scale(scale);
                  final value = controller.value.isIdentity() ? zoomed : Matrix4.identity();
                  controller.value = value;
                },
                child: InteractiveViewer(
                  maxScale: 3,
                  minScale: 1,
                  transformationController: controller,
                  child: Center(
                    child: CachedNetworkImage(
                      height: 500,
                      imageUrl: image,
                      fit: BoxFit.contain, // Ensures the image fits within the screen
                      placeholder: (context, url) => CircularProgressIndicator(), // Optional placeholder
                      errorWidget: (context, url, error) => const Icon(Icons.error), // Optional error icon
                    ),
                  )
                ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceBtwSection),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 150,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Close'),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}