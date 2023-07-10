import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';


import 'local_push_notification_service.dart';

class FirebasePushNotificationService {
  static Future init() async {
    if (!kIsWeb) {
      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      // await FirebaseMessaging.instance
      //     .setForegroundNotificationPresentationOptions(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      _handleMessage(message);

      // LocalPushNotificationService.showNotification(
      //     title: message.notification!.title ?? "push ntofication",
      //     body: "lslsldslksd",
      //     payload: "payload");

      // if (message.notification != null) {
      //   print('Message also contained a notification: ${message.notification}');
      //   // print(message.notification!.title!);
      //   // print(message.notification!.body!);
      //   // LocalPushNotificationService.showNotification(
      //   //     title: message.notification!.title ?? "IOS TEST",
      //   //     body: message.notification!.body ?? "Testing IOS push notification",
      //   //     payload: "Payload");
      // }
    });

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // await initializeFireStore();
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
    _handleMessage(message);
    //print('Handling a background message ${message.messageId}');
  }

  static Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  static Future<String?> getAPNToken() async {
    return await FirebaseMessaging.instance.getAPNSToken();
  }

  static subscribeAndUnsubscribeToTopic(
      {required String topic, required bool subscribe}) async {
    subscribe
        ? await FirebaseMessaging.instance.subscribeToTopic(topic)
        : await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  static _handleMessage(RemoteMessage message) {
    print("eromt#${message}");
    late String desc;
    try {
      final map = json.decode(message.data["body"]);

      // print("message data------------");
      // print("handle Message data: " + message.data.toString());
      // print("data title: " + message.data["title"].toString());
      // print("data body: " + message.data["body"].toString());
      // print("data content: " + map["content"].toString());
      // print("handle Message datacccc(type): " + map.runtimeType.toString());
      // print("handle Message data(type): " + message.runtimeType.toString());

      desc = map["content"];
    } catch (e) {
      desc = "Something new from Trybe One";
    }

    //print("Message body: " + message.notification!.body.toString());

    LocalPushNotificationService.showNotification(
        title: message.data["title"],
        body: desc,
        payload: message.data["body"]);
  }

  // static initializeFireStore() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final int? uid = prefs.getInt('userId');

  //     final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //     FirebaseMessaging messaging = FirebaseMessaging.instance;

  //     messaging.getToken().then((token) async {
  //       print('this is $token');
  //       if (token != null) {
  //         Provider.of<UserProfileProvider>(navigatorKey.currentContext!,
  //                 listen: false)
  //             .updateFcmToken(fcmToken: token);
  //       } else {
  //         print('no token');
  //       }
  //     });

  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
