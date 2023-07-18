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
    var payload = jsonDecode(receivedNotification.payload!["data"]!);
    var role = payload["role"];
    var action = payload["orderStatus"];
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

  if (action == "promo") {
    var bigPicture = data["bigPicture"] ??
        "https://images.unsplash.com/photo-1504674900247-0877df9cc836?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80";
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        payload: Map<String, String>.from(message),
        id: 10,
        channelKey: 'basic_channel',
        title: data["storeName"],
        body: data["message"],
        notificationLayout: NotificationLayout.BigPicture,
        displayOnBackground: true,
        displayOnForeground: true,
        locked: false,
        category: NotificationCategory.Message,
        color: MyColors.primary,
        bigPicture: bigPicture,
      ),
    );
  } else {
    var storeName = data["products"] != null
        ? data["products"][0]["storeName"]
        : "Erdenet24";
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
        notificationLayout: NotificationLayout.Default,
        displayOnBackground: true,
        displayOnForeground: true,
        locked: false,
        category: NotificationCategory.Message,
        color: MyColors.primary,
      ),
    );
  }
}
