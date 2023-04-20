import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final _userCtx = Get.put(UserController());
final _storeCtx = Get.put(StoreController());
final _driverCtx = Get.put(DriverController());

void notificationHandler(payload, isBackground) {
  NotificationService().showNotification(
    3,
    "Hello",
    payload,
  );
}

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

  Future<void> showNotification(int id, String body, Map payload) async {
    var data = jsonDecode(payload["data"]);
    var role = data["role"];
    var action = data["action"];
    var description = notificationData
        .firstWhere((e) => e["role"] == role && e["action"] == action);
    switch (role) {
      case "user":
        _userCtx.userActionHandler(action, data);
        break;
      case "store":
        _storeCtx.storeActionHandler(action, data);
        break;
      case "driver":
        _driverCtx.driverActionHandler(action, data);
        break;
      default:
        break;
    }
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
      "Erdenet24",
      body,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }
}
