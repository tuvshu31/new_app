import 'dart:convert';
import 'dart:developer';

import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

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
    var action = data["action"];

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
  var info = message["data"];
  var data = jsonDecode(info);
  var role = data["role"];
  var action = data["action"];
  var notif = notificationData.firstWhere(
    (element) => element["action"] == action && element["role"] == role,
  );

  AwesomeNotifications().createNotification(
      content: NotificationContent(
        payload: Map<String, String>.from(message),
        id: 10,
        channelKey: 'basic_channel',
        title: 'Erdenet24',
        body: notif["body"],
        actionType: ActionType.Default,
        category: NotificationCategory.Message,
        displayOnBackground: true,
        displayOnForeground: true,
        locked: false,
      ),
      actionButtons: [
        NotificationActionButton(
          label: 'TEST',
          enabled: true,
          key: 'test',
        )
      ]);
}
