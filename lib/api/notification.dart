import 'dart:convert';
import 'dart:developer';

import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:get/get.dart';

final _userCtx = Get.put(UserController());
final _storeCtx = Get.put(StoreController());
final _driverCtx = Get.put(DriverController());

class NotificationController {
  static Future<void> initializeRemoteNotificationsFcm(
      {required bool debug}) async {
    await AwesomeNotificationsFcm().initialize(
      onFcmSilentDataHandle: mySilentDataHandle,
      onFcmTokenHandle: myFcmTokenHandle,
      onNativeTokenHandle: myNativeTokenHandle,
      licenseKeys: null,
      debug: debug,
    );
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  @pragma("vm:entry-point")
  static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
    log("silentData: $silentData");
    var data = silentData.data!["data"];
    var payload = jsonDecode(data!);
    var role = payload["role"] ?? "";
    var action = payload["action"] ?? "";
    var orderId = payload["orderId"] ?? "";
    var isBackground =
        silentData.createdLifeCycle == NotificationLifeCycle.Background;
    var notifInfo = notificationData.firstWhere(
      (element) => element["role"] == role && element["action"] == action,
    );
    var body = notifInfo["body"];
    var type = notifInfo["type"];
    var visible = notifInfo["visible"];
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        displayOnForeground: true,
        displayOnBackground: true,
        // criticalAlert: true,
        category: NotificationCategory.Message,
        // category: type == "call"
        //     ? NotificationCategory.Call
        //     : NotificationCategory.Message,
        // customSound: type == "call" ? 'resource://raw/incoming' : "",
        id: 1,
        channelKey: "basic_channel",
        title: "Erdenet24",
        body: body,
        // body: "AMjilttai holbogdloo",
        payload: silentData.data,
      ),
    );
  }

  /// Use this method to detect when a new fcm token is received
  @pragma("vm:entry-point")
  static Future<void> myFcmTokenHandle(String token) async {
    log('FCM Token:"$token"');
  }

  /// Use this method to detect when a new native token is received
  @pragma("vm:entry-point")
  static Future<void> myNativeTokenHandle(String token) async {
    log('Native Token:"$token"');
  }

  @pragma("vm:entry-point")
  static Future<void> askNotificationPermission() async {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @pragma("vm:entry-point")
  static Future<void> initializeRemoteNotifications(
      {required bool debug}) async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: "basic_channel",
          channelName: "Basic Notification",
          channelDescription: "Notification channel for basic test",
          importance: NotificationImportance.High,
          soundSource: 'resource://raw/incoming',
        ),
      ],
      debug: debug,
    );
  }

  @pragma("vm:entry-point")
  static Future<void> createNotification(silentData) async {
    log("Notification Irj bn");
    log(silentData.toString());
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        displayOnForeground: true,
        displayOnBackground: true,
        // criticalAlert: true,
        category: NotificationCategory.Message,
        // category: type == "call"
        //     ? NotificationCategory.Call
        //     : NotificationCategory.Message,
        // customSound: type == "call" ? 'resource://raw/incoming' : "",
        id: 1,
        channelKey: "basic_channel",
        title: "Erdenet24",
        // body: body,
        // body: "AMjilttai holbogdloo",
        payload: silentData.data,
      ),
    );
  }

  @pragma("vm:entry-point")
  static Future<void> setNotificationListeners() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
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
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    log("onActionReceivedMethod");
    // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
    //     '/notification-page',
    //     (route) =>
    //         (route.settings.name != '/notification-page') || route.isFirst,
    //     arguments: receivedAction);
  }
}
