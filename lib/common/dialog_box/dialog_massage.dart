import 'package:get/get.dart';

import '../widgets/loaders/loader.dart';

class DialogMessage {

  //Show dialog box before removing product
  void showDialog({required String title, String? message, String? toastMassage, required Future<void> Function() function,}) {
    Get.defaultDialog(
        title: title,
        middleText: message ?? '',
        onConfirm: () async {
          Get.back();
          await function();
          TLoaders.customToast(message: toastMassage ?? 'Success');
        },
        onCancel: () => Get.back()
    );
  }
}