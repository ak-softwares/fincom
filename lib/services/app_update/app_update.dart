import 'package:in_app_update/in_app_update.dart';

class AppUpdate {
  Future<void> checkForUpdate() async {
    // print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) async {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        // print('update available');
        // Start the update process
        // print('Updating');
        await InAppUpdate.startFlexibleUpdate();
        InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
          // print(e.toString());
        });
        // Future<AppUpdateInfo> checkForUpdate(): Checks if there's an update available
        // Future<void> performImmediateUpdate(): Performs an immediate update (full-screen)
        // Future<void> startFlexibleUpdate(): Starts a flexible update (background download)
        // Future<void> completeFlexibleUpdate(): Actually installs an available flexible update
      }
    }).catchError((e) {
      // print(e.toString());
    });
  }
}