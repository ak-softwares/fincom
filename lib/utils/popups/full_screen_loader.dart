import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/animation_loader.dart';


/// a utility class for managing a full screen loading dialog
class TFullScreenLoader {
  /// open a full screen loading dialog with a given text and animation
  /// this method doesnt return anything.
  ///
  /// parameters:
  /// - Text: the text to be displayed in the laoding dialog
  /// - animation: the lottie animation to be shown.
  static void openLoadingDialog(String text, String animation) {
    showDialog(
        context: Get.overlayContext!,  //use get.overlayContext for overlay dialog
        barrierDismissible: false,
        builder: (_) => PopScope(
          canPop: false, //disable popping with the back buttion
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 250),
                TAnimationLoaderWidgets(text: text, animation: animation,),
              ],
            ),
          )
        )
    );
  }
  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop(); // close the dialog using the navigator
  }
}
