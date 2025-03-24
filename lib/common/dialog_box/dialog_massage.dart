import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/loaders/loader.dart';

class DialogHelper {

  static void showDialog({
    required BuildContext context,
    required String title,
    String? message,
    String? toastMessage,
    String? actionButtonText,
    required Future<void> Function() function,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              if (message != null)
                Text(
                  message,
                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              Divider(color: Theme.of(context).colorScheme.outline, thickness: 1),
              InkWell(
                onTap: () async {
                  Get.back();
                  await function();
                  if (toastMessage != null) {
                    TLoaders.customToast(message: toastMessage);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    actionButtonText ?? "Delete",
                    style: const TextStyle(fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.outline, thickness: 1),
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}