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
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';

final _cartCtx = Get.put(CartController());
final _userCtx = Get.put(UserController());
final _storeCtx = Get.put(StoreController());
final _driverCtx = Get.put(DriverController());

void notificationHandler(data) {
  var role = jsonDecode(data["data"])["role"];
  var action = jsonDecode(data["data"])["action"];
  switch (role) {
    case "user":
      _userCtx.userNotificationHandler(action);
      break;
    case "store":
      _storeCtx.storeNotificationHandler(action);
      break;
    case "driver":
      _driverCtx.driverNotificationHandler(action);
      break;
    default:
      log(role.toString());
      break;
  }
}

void createCustomNotification({
  bool isVisible = false,
  String title = "Erdenet24",
  String body = "",
  bool customSound = false,
}) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      displayOnForeground: isVisible,
      displayOnBackground: isVisible,
      criticalAlert: true,
      progress: 32,
      category: NotificationCategory.Message,
      customSound: 'resource://raw/incoming',
      id: 1,
      channelKey: "basic_channel",
      title: title,
      body: body,
    ),
  );
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    var role = receivedNotification.payload!["data"]!;
    log(role.toString());
    // Your code goes here
    log("onNotificationCreatedMethod $receivedNotification");
    var payload = jsonDecode(receivedNotification.payload!["data"]!);
    if (payload["role"] == "user" && payload["action"] == "payment_paid") {
      log("my code goes here");
      successOrderModal(
        MyApp.navigatorKey.currentContext,
        () async {
          _cartCtx.cartList.clear();
          dynamic orderResponse =
              await RestApi().createOrder(_userCtx.orderTempData);
          dynamic orderData = Map<String, dynamic>.from(orderResponse);
          if (orderData["success"]) {
            _userCtx.orderTempData.clear();
            RestApiHelper.saveOrderId(payload["orderId"]);
            Get.off(() => const UserOrderActiveScreen());
          }
        },
      );
    }
    log(payload.toString());
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
