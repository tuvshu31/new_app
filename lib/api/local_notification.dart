import 'dart:convert';
import 'dart:developer';

import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

final _userCtx = Get.put(UserController());
final _storeCtx = Get.put(StoreController());
final _driverCtx = Get.put(DriverController());

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
    var payload = jsonDecode(message.data["data"]);
    var role = payload["role"];
    var action = payload["action"];
    var notifInfo = notificationData.firstWhere(
        (element) => element["role"] == role && element["action"] == action);

    switch (role) {
      case "user":
        _userCtx.userActionHandler(action, payload);
        break;
      case "store":
        _storeCtx.storeActionHandler(action, payload);
        break;
      case "driver":
        _driverCtx.driverActionHandler(action, payload);
        break;
      default:
        break;
    }

    showBigTextNotification(
        title: "Erdenet24",
        body: notifInfo["body"],
        fln: flutterLocalNotificationsPlugin);
  }
}
