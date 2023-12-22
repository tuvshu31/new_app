import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  static Future init() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  static Future _notificationDetails(
    String largeIcon,
    String bigPicture,
  ) async {
    Future<String> downloadAndSaveFile(String url, String fileName) async {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/$fileName';
      final http.Response response = await http.get(Uri.parse(url));
      final File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    }

    final String largeIconPath =
        await downloadAndSaveFile(largeIcon, 'largeIcon');
    final String bigPicturePath =
        await downloadAndSaveFile(bigPicture, 'bigPicture');
    final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
    );
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        enableVibration: true,
        fullScreenIntent: true,
        colorized: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('incoming'),
        actions: [
          AndroidNotificationAction(
            'action_2',
            'Accept',
            showsUserInterface: true,
            titleColor: Colors.green,
          ),
        ],
        styleInformation: BigTextStyleInformation(
          "",
          contentTitle: "Шинэ захиалга ирлээ",
        ),
        // styleInformation: styleInformation,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future showNotificationWithPicture({
    required String title,
    required String body,
    required String payload,
    String largeIcon = "",
    required String bigPicture,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(1000),
      title,
      body,
      await _notificationDetails(largeIcon, bigPicture),
      payload: payload,
    );
  }

  static Future _showIncomingSoundNotificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('incoming'),
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future _simpleNotificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future showSimpleNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await _simpleNotificationDetails(),
    );
  }

  static Future showIncomingSoundNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await _showIncomingSoundNotificationDetails(),
    );
  }
}
