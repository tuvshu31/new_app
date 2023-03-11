import 'dart:convert';
import 'dart:developer';

import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/screens/user/user_orders_active_screen.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';

final _cartCtx = Get.put(CartController());

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    var payload = jsonDecode(receivedNotification.payload!["data"]!);
    if (payload["role"] == "user") {
      if (payload["action"] == "payment_paid") {
        successOrderModal(
          MyApp.navigatorKey.currentContext,
          () {
            _cartCtx.cartList.clear();
            RestApiHelper.saveOrderId(payload["orderId"]);
            Get.back();
            Get.back();
            Get.back();
            Get.to(() => const UserOrderActiveScreen());
          },
        );
      }
    }
    log("onNotificationCreatedMethod $receivedNotification");
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
