import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../routes/deeplink_get_router.dart';
import '../../routes/internal_routes.dart';
import 'local_notification.dart';

// Doc - https://firebase.google.com/docs/cloud-messaging/flutter/first-message?hl=en&authuser=0
class FirebaseNotification {
  //create a instance of firebase Messaging
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Static variable to hold the FCM token
  static String? fCMToken;

  //function to initialize notification
  static Future<void> initNotification() async {
    //Request permission form user
    await _firebaseMessaging.requestPermission();

    //Fetch the FCM token for this device
    fCMToken = await _firebaseMessaging.getToken();

    // FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    //   print("New token: $newToken");
    //   // Send the new token to your server.
    // });

    //Print Token
    if (kDebugMode) {
      print('Token ======= "$fCMToken"');
    }

    //initPushNotification
    initPushNotification();
  }

  //Handel Msg
  static void handleMassage(RemoteMessage? message){
    if(message == null) return;
    // print('Initial message received: ${message.notification?.title}');
    // print('Initial message received: ${message.notification}');
    // print('Initial message received: ${message.notification?.body}');
    // print('Initial message received: ${message.data['product']}');
    if(message.data['url'] != null) {
      InternalAppRoutes.internalRouteHandle(url: message.data['url']);
    }
  }

  static void showNotification(RemoteMessage? message) {
    if(message == null) return;
    LocalNotificationServices.localNotificationsPlugin.
    show(
        0, //notification id it may anything
        message.notification?.title,
        message.notification?.body,
        LocalNotificationServices.getPlatformChannelSpecifics(),
        payload: message.data['url']
    );
  }

  //function initiate background massage
  static Future initPushNotification() async {

    // To handle messages while your application is in the foreground, listen to the onMessage stream.
    // Message received in foreground
    FirebaseMessaging.onMessage.listen(showNotification);

    // To handle messages while your application is running in the background, listen to the onMessageOpenedApp stream.
    // Message opened from background
    FirebaseMessaging.onMessageOpenedApp.listen(handleMassage);

    // Used to handle the initial message payload when the app is opened from a terminated state due to a notification click.
    // Message opened from terminated state
    _firebaseMessaging.getInitialMessage().then(handleMassage);
  }

}