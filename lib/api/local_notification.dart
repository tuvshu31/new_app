import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/screens/user/user_orders_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  static Future init() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  static Future _notificationDetails(
    String largeIcon,
    String bigPicture,
  ) async {
    dynamic styleInformation = const DefaultStyleInformation(false, false);
    if (largeIcon != "" && bigPicture != "") {
      Future<String> downloadAndSaveFile(String url, String fileName) async {
        final Directory directory = await getApplicationDocumentsDirectory();
        final String filePath = '${directory.path}/$fileName';
        final http.Response response = await http.get(Uri.parse(url));
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }

      final String largeIconPath =
          await downloadAndSaveFile(largeIcon, 'largeIcon');
      final String bigPicturePath =
          await downloadAndSaveFile(bigPicture, 'bigPicture');
      styleInformation = BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
      );
    }

    return NotificationDetails(
      android: AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        styleInformation: styleInformation,
      ),
      iOS: const DarwinNotificationDetails(),

      // var iOSPlatformChannelSpecifics = IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    );
  }

  static Future showNotification(
      {int id = 0,
      String title = "",
      String body = "",
      String role = "",
      String bigPicture = "",
      String largeIcon = ""}) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await _notificationDetails(largeIcon, bigPicture),
      payload: role,
    );
  }

  static Future cancelLocalNotification({required int id}) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}

void handleNotifications(data) {
  var payload = jsonDecode(data["data"]);
  LocalNotification.showNotification(
    id: payload["id"] ?? 0,
    title: payload["title"] ?? "",
    body: payload["body"] ?? "",
    role: payload["role"] ?? "",
    bigPicture: payload["bigPicture"] ?? "",
    largeIcon: payload["largeIcon"] ?? "",
  );
}

//Android
Future<void> onClickNotification(data) async {
  handleNotificationOnClick(data);
}

//IOS
void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  handleNotificationOnClick(payload!);
}

void handleNotificationOnClick(String role) {
  final navCtx = Get.put(NavigationController());
  final storeCtx = Get.put(StoreController());
  final driverCtx = Get.put(DriverController());
  final userCtx = Get.put(UserController());
  String userRole = RestApiHelper.getUserRole();
  if (role != "" && role == userRole) {
    if (role == "user") {
      Get.back();
      Get.back();
      navCtx.currentIndex.value = 3;
      Get.offNamed(userHomeScreenRoute);
    }
    if (role == "store") {
      storeCtx.tappingNotification.value = true;
      // storeCtx.checkStoreNewOrders();
      // storeCtx.refreshOrders();
    }
    if (role == "driver") {
      Get.back();
      Get.offNamed(driverMainScreenRoute);
      driverCtx.refreshOrders();
    }
  }
}
