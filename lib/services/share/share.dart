import 'package:share_plus/share_plus.dart';

import '../../features/settings/app_settings.dart';
import '../firebase_analytics/firebase_analytics.dart';

class AppShare {

  static Future<void> share({required String text, required String contentType, required String itemName, required String itemId}) async {
    final ShareResult shareResult = await Share.share('${AppSettings.appName} - $text',subject: 'subject');
    if (shareResult.status == ShareResultStatus.success) {
      String appName = _extractAppName(shareResult.raw);
      FBAnalytics.logShare(contentType: contentType, method: appName, itemName: itemName, itemId: itemId);
    }
  }

  static Future<void> shareUrl({required String url, required String contentType, required String itemName, required String itemId}) async {
    final ShareResult shareResult = await Share.shareUri(Uri.parse(url));
    if (shareResult.status == ShareResultStatus.success) {
      String appName = _extractAppName(shareResult.raw);
      FBAnalytics.logShare(contentType: contentType, method: appName, itemName: itemName, itemId: itemId);
    }
  }

  // Helper function to extract app name from the raw string
  static String _extractAppName(String rawResult) {
    // Extended regular expression to match more app package names
    final regex = RegExp(r'com\.(whatsapp|instagram|facebook|twitter|gmail|telegram|messenger|messaging|linkedin|snapchat|tiktok|youtube|skype|pinterest)');
    final match = regex.firstMatch(rawResult);

    if (match != null) {
      // Extract the app name from the package name (e.g., com.whatsapp -> whatsapp)
      return match.group(1) ?? '';
    }
    return rawResult;  // Return empty string if no match is found
  }

}
