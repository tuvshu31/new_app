import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (int id, String? title, String? body,
                String? payload) async {});

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(int id, String title, String body) async {
    const AndroidNotificationDetails _androidNotificationDetails =
        AndroidNotificationDetails(
      'erdenet24_channel',
      'Erdenet24 Channel',
      "Erdenet24 custom notification",
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
    );

    const IOSNotificationDetails _iosNotificationDetails =
        IOSNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: _androidNotificationDetails, iOS: _iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }
}
