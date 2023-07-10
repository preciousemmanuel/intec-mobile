import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intechpro/main.dart';

import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;

// import '../common/components/notification_badge.dart';


class LocalPushNotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init({bool schedule = false}) async {
    var initAndroidSettings =
        const AndroidInitializationSettings("splash");
    // var initIOSSettings = IOSInitializationSettings(
    //     onDidReceiveLocalNotification: (i, title, subtitle, s) {});
    // final settings = InitializationSettings(
    //     android: initAndroidSettings, iOS: initIOSSettings);
    // await _notifications.initialize(settings,
    //     onSelectNotification: (payload) async {
    //   try {
    //     debugPrint("onTapPushNotification:============");
    //     debugPrint(payload.runtimeType.toString());
    //     print(payload.toString());

    //     _handleOnclickNotification(payload!);
    //   } catch (e) {
    //     print(e.toString());
    //     // showToastAlert(
    //     //     appContext!, "Something went wrong. Action couldn't be completed.");
    //   }
    // });
  }

  static Future showNotification(
      {var id = 0,
      required String title,
      required String body,
      dynamic payload}) async {
    String? attachmentPath;
    try {
      attachmentPath = await downloadFilez(
          payload["imageUrl"] ??
              "https://is3-ssl.mzstatic.com/image/thumb/Purple126/v4/fb/8f/76/fb8f76fb-bbfc-2040-ba08-645c92c086f8/AppIcon-0-0-1x_U007emarketing-0-0-0-10-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/1200x630wa.png",
          "attachment_img.png");
    } catch (e) {}

   
    return _notifications.show(
        id, title, body, await notificationDetails(attachmentPath),
        payload: payload);
  }

  static notificationDetails(String? attachmentPath) async {
    String channelId = DateTime.now().toIso8601String();
    return NotificationDetails(
        android: AndroidNotificationDetails(
          channelId, channelId,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,

          largeIcon: attachmentPath != null
              ? FilePathAndroidBitmap(attachmentPath)
              : null,
          //icon: "launcher_icon",
          // styleInformation: attachmentPath == null
          //     ? null
          //     : BigPictureStyleInformation(
          //         FilePathAndroidBitmap(attachmentPath),
          //         contentTitle: "test attachment",
          //         htmlFormatContentTitle: true,
          //         largeIcon: FilePathAndroidBitmap(attachmentPath),
          //         summaryText: "test attachment1",
          //         htmlFormatContent: true,
          //         hideExpandedLargeIcon: true)
        ),
        // iOS: IOSNotificationDetails(
        //   presentSound: true,
        //   // attachments: attachmentPath == null
        //   //     ? null
        //   //     : [IOSNotificationAttachment(attachmentPath)]
        // ));

    );
  }

  static Future downloadFilez(String url, String name) async {
    var dir = await getApplicationDocumentsDirectory();
    var imageDownloadPath = '${dir.path}/$name';
    var res = await http.get(Uri.parse(url));
    File file = File(imageDownloadPath);
    await file.writeAsBytes(res.bodyBytes);
    return imageDownloadPath;
  }

  static _handleOnclickNotification(String payload) {
    print(payload.toString());
    try {
      // if (payload == "newGroupMessage") {
      //   navigatorKey.currentState?.push(CustomPageRoute(GroupsScreen()));
      //   return;
      // }
      // if (payload == "newPrivateMessage") {
      //   navigatorKey.currentState?.push(CustomPageRoute(MessageScreen()));
      //   return;
      // }
      // Map<String, dynamic> parsedPayload = json.decode(payload);
      // NotificationItem item = NotificationItem.fromJson(parsedPayload);
      // NotificationRouterService.router(item, navigatorKey.currentContext!);
    } catch (e) {
      debugPrint("OnClickNotificationError: ${e.toString()}");
      // showToastAlert(
      //     appContext!, "Something went wrong. Action couldn't be completed.");
    }
  }
}
