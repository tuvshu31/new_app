import 'dart:developer';

import 'package:Erdenet24/screens/driver/driver_bottom_views.dart';
import 'package:Erdenet24/screens/store/orders/store_orders_notification_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<Map<String, dynamic>> firebaseMessagingForegroundHandler() async {
  log("Foreground message irj bn :)");
  Map<String, dynamic> messageData = {};
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    messageData = message.data;
  });
  return messageData;
}

@pragma('vm:entry-point')
Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  playSound("incoming");
  var data = message.data;
  log(data.toString());
  // showOrdersNotificationView(context, data);
  log("Foreground message irj bn lastly");
}
