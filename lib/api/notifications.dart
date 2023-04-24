import 'dart:convert';
import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/screens/user/user_orders_active_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';

final _cartCtx = Get.put(CartController());
final _userCtx = Get.put(UserController());
final _storeCtx = Get.put(StoreController());
final _driverCtx = Get.put(DriverController());

// void saveUserToken() async {
//   await FirebaseMessaging.instance.deleteToken();
//   final fcmToken = await FirebaseMessaging.instance.getToken();
//   var body = {"mapToken": fcmToken};
//   await RestApi().updateUser(RestApiHelper.getUserId(), body);
//   FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
//     var body = {"mapToken": newToken};
//     await RestApi().updateUser(RestApiHelper.getUserId(), body);
//   });
// }

// void switchNotifications(payload, isBackground) {
//   var role = jsonDecode(payload["data"])["role"];
//   var action = jsonDecode(payload["data"])["action"];
//   switch (role) {
//     case "user":
//       _userCtx.userNotifications(action, payload, isBackground);
//       break;
//     case "store":
//       _storeCtx.storeNotifications(action, payload, isBackground);
//       break;
//     case "driver":
//       _driverCtx.driverNotifications(action, payload, isBackground);
//       break;
//     default:
//       break;
//   }
// }

// void handleNotifications(payload) {
//   var role = payload["role"];
//   var action = payload["action"];
//   switch (role) {
//     case "user":
//       _userCtx.userNotificationDataHandler(action, payload);
//       break;
//     case "store":
//       _storeCtx.storeNotificationDataHandler(action, payload);
//       break;
//     case "driver":
//       _driverCtx.driverNotificationDataHandler(action, payload);
//       break;
//     default:
//       break;
//   }
// }

void notificationHandler(silentData) {
  // log("silentData: $silentData");
  // var data = silentData.data["data"];
  // var payload = jsonDecode(data);
  // var role = payload["role"] ?? "";
  // var action = payload["action"] ?? "";
  // var orderId = payload["orderId"] ?? "";
  // var isBackground =
  //     silentData.createdLifeCycle == NotificationLifeCycle.Background;
  // var notifInfo = notificationData.firstWhere(
  //   (element) => element["role"] == role && element["action"] == action,
  // );
  // var body = notifInfo["body"];
  // var type = notifInfo["type"];
  // var visible = notifInfo["visible"];

  AwesomeNotifications().createNotification(
    content: NotificationContent(
        displayOnForeground: true,
        displayOnBackground: true,
        criticalAlert: true,
        category: NotificationCategory.Message,
        // category: type == "call"
        //     ? NotificationCategory.Call
        //     : NotificationCategory.Message,
        // customSound: type == "call" ? 'resource://raw/incoming' : "",
        id: 1,
        channelKey: "basic_channel",
        title: "Erdenet24",
        // body: body,
        body: "AMjilttai holbogdloo"
        // payload: silentData.data,
        ),
  );
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    log("onNotificationCreatedMethod");
    var data = receivedNotification.payload!["data"];
    var payload = jsonDecode(data!);
    var role = payload["role"];
    var action = payload["action"];
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

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here

    log("onNotificationDisplayedMethod");
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened

    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //   '/StoreScreenRoute',
    //   (route) => (route.settings.name != '/StoreScreenRoute') || route.isFirst,
    //   arguments: receivedAction.payload!["data"],
    // );

    log("onDismissActionReceivedMethod");
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    log("onActionReceivedMethod");
    // Navigate into pages, avoiding to open the notification details page over another details page already opened

    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //   '/StoreScreenRoute',
    //   (route) => (route.settings.name != '/StoreScreenRoute') || route.isFirst,
    //   arguments: receivedAction.payload!["data"],
    // );
  }
}
