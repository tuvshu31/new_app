import 'package:hive/hive.dart';

class RestApiHelper {
  static Box? authBox;
  // Login хийсэн хэрэглэгчийн ID-г хадлагах, авах
  static void saveUserId(int id) => authBox?.put("id", id);
  static int getUserId() => authBox?.get("id", defaultValue: 0);
  // Login хийсэн хэрэглэгчийн role-г хадлагах, авах
  static void saveUserRole(String type) => authBox?.put("role", type);
  static String getUserRole() => authBox?.get('role', defaultValue: '');
  // Login хийсэн хэрэглэгчийн захиалга хийсэн эсэсхийг-г хадлагах, авах
  static void saveUserOrder(bool isWithOrder) =>
      authBox?.put("isWithOrder", isWithOrder);
  static bool getUserOrder() =>
      authBox?.get('isWithOrder', defaultValue: false);
}
