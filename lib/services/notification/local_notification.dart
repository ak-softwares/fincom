import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../routes/deeplink_get_router.dart';
import '../../routes/internal_routes.dart';


class LocalNotificationServices {
  // Initialize FlutterLocalNotificationsPlugin
  static FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //Initialize Settings for android and ios
  static var initializationSettingsAndroid = const AndroidInitializationSettings("@mipmap/ic_launcher");
  static var initializationSettingsIOS = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestCriticalPermission: true,
    requestSoundPermission: true,
  );

  //Initialize Settings for android and ios
  static final InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // Function to create notification details
  static NotificationDetails getPlatformChannelSpecifics() {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'default_notification_channel_id', // channel id
      'pushNotificationAppName',        // channel name
      enableLights: true,
      enableVibration: true,
      priority: Priority.max,
      importance: Importance.max,
      // largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
  }

  static void checkNotificationAppLunch() async {
    NotificationAppLaunchDetails? details = await localNotificationsPlugin.getNotificationAppLaunchDetails();

    if(details != null) {
      if(details.didNotificationLaunchApp){
        var response = details.notificationResponse;
        if(response != null){
          InternalAppRoutes.internalRouteHandle(url: response.payload.toString());
        }
      }
    }
  }
}
