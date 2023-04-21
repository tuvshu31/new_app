import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _userCtx = Get.put(UserController());
final _storeCtx = Get.put(StoreController());
final _driverCtx = Get.put(DriverController());

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
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      log("payload: $payload");
      // switch (role) {
      //   case "user":
      //     _userCtx.userActionHandler(action, payload);
      //     break;
      //   case "store":
      //     _storeCtx.storeActionHandler(action, payload);
      //     break;
      //   case "driver":
      //     _driverCtx.driverActionHandler(action, payload);
      //     break;
      //   default:
      //     break;
      // }
    });
  }

  Future<void> showNotification(Map payload, bool isBackground) async {
    log(payload.toString());
    log(isBackground.toString());
    // var data = jsonDecode(payload["data"]);
    // var role = payload["role"];
    // var action = payload["action"];
    // var description = notificationData
    //     .firstWhere((e) => e["role"] == role && e["action"] == action);
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'erdenet24_channel',
      'Erdenet24 Channel',
      "Erdenet24 custom notification",
      playSound: true,
      priority: Priority.high,
      importance: Importance.high,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      "Erdenet24",
      // description["description"],
      "Hello",
      platformChannelSpecifics,
      payload: payload.toString(),
    );
  }
}
