import 'dart:convert';
import 'dart:developer';

import 'package:Erdenet24/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('incoming'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());
    await fln.show(0, title, body, not);
  }

  static Future<void> handleNotifications(message, isBackground) async {
    log(message.data.toString());
    var payload = message.data;
    var info = jsonDecode(payload);
    var role = info["role"];
    var action = info["action"];

    showBigTextNotification(
        title: "Hello",
        body: "Background Notification",
        fln: flutterLocalNotificationsPlugin);
  }
}
