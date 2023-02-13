import 'dart:developer';

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
Future<Map<String, dynamic>> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Background message irj bn :)");
  return message.data;
}
