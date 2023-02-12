import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<Map<String, dynamic>> firebaseMessagingForegroundHandler() async {
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
  return message.data;
}

Future<String?> getToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  return fcmToken;
}
