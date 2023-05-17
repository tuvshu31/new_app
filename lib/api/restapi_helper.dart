import 'package:hive/hive.dart';

class RestApiHelper {
  static Box? authBox;

  static const String kUserId = "USER_ID";
  static const String kUserRole = "USER_ROLE";
  static const String kOrderId = "ORDER_ID";
  static const String kOrderStep = "ORDER_STEP";
  static const String kNotification = "NOTIFICATION";
  static const String kOrderInfo = "ORDER_INFO";

  // Login хийсэн хэрэглэгчийн ID-г хадлагах, авах
  static void saveUserId(int id) => authBox?.put(kUserId, id);
  static int getUserId() => authBox?.get(kUserId, defaultValue: 0);
  // Login хийсэн хэрэглэгчийн role-г хадлагах, авах
  static void saveUserRole(String type) => authBox?.put(kUserRole, type);
  static String getUserRole() => authBox?.get(kUserRole, defaultValue: '');
  // Login хийсэн хэрэглэгчийн захиалга хийсэн эсэсхийг-г хадлагах, авах
  static void saveOrderId(int orderId) => authBox?.put(kOrderId, orderId);
  static int getOrderId() => authBox?.get(kOrderId, defaultValue: 0);

  // Хүргэлтэнд явж буй жолоочийн захиалгын мэдээллииг хадгалж авах
  static void saveOrderInfo(Map orderInfo) =>
      authBox?.put(kOrderInfo, orderInfo);
  static Map getOrderInfo() => authBox?.get(kOrderInfo, defaultValue: {});

  /// Notification
  static void saveNotificationId(int value) =>
      authBox?.put(kNotification, value);
  static int getNotificationId() =>
      authBox?.get(kNotification, defaultValue: 0);
}
