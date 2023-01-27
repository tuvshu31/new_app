import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class UserOrderNotificationScreen extends StatefulWidget {
  const UserOrderNotificationScreen({super.key});

  @override
  State<UserOrderNotificationScreen> createState() =>
      _UserOrderNotificationScreenState();
}

class _UserOrderNotificationScreenState
    extends State<UserOrderNotificationScreen> {
  String messageTitle = "Empty";
  String notificationAlert = "alert";

  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              notificationAlert,
            ),
            Text(
              messageTitle,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
