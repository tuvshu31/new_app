import 'package:hive/hive.dart';

class RestApiHelper {
  static Box? authBox;

  static const String kToken = "TOKEN";
  static const String kUserRole = "USER_ROLE";
  // Login хийсэн хэрэглэгчийн role-г хадгалах
  static void saveUserRole(String type) => authBox?.put(kUserRole, type);
  static String getUserRole() => authBox?.get(kUserRole, defaultValue: '');
  // Login хийсэн хэрэглэгчийн token-г хадгалах
  static void saveToken(String type) => authBox?.put(kToken, type);
  static String getToken() => authBox?.get(kToken, defaultValue: '');
}
