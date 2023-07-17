import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

final _userCtx = Get.put(UserController());
final _storeCtx = Get.put(StoreController());
final _driverCtx = Get.put(DriverController());

class Noti {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    var data = jsonDecode(receivedNotification.payload!["data"]!);
    var role = data["role"];
    var action = data["orderStatus"];

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
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }
}

Future<void> handleNotifications(message, isBackground) async {
  log(message.toString());
  var info = message["data"];
  var data = jsonDecode(info);
  var role = data["role"];
  var action = data["orderStatus"];
  var storeName = data["products"][0]["storeName"];
  var bigPicture = data["bigPicture"];
  String messageBody = notificationData.firstWhere(
        (element) => element["action"] == action && element["role"] == role,
      )["body"] ??
      "";
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      payload: Map<String, String>.from(message),
      id: 10,
      channelKey: 'basic_channel',
      title: role == "user" ? storeName ?? "Байгууллага" : "Erdenet24",
      body: messageBody,
      notificationLayout: action == "promo"
          ? NotificationLayout.BigPicture
          : NotificationLayout.Default,
      displayOnBackground: true,
      displayOnForeground: true,
      locked: false,
      bigPicture: bigPicture ??
          "https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80",
      category: NotificationCategory.Message,
      color: MyColors.primary,
    ),
  );
}
