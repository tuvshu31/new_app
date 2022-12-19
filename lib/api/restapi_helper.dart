import 'package:hive/hive.dart';

class RestApiHelper {
  static Box? authBox;

  /// Auth-mай холбоотой мэдээллийг устгах
  static deleteAuthInfo() {
    saveAccessToken('');
  }

  /// Access Token хадгалах болон авах
  static void saveAccessToken(String token) => authBox?.put("token", token);
  static void saveUserId(int id) => authBox?.put("id", id);
  static void saveUserRole(String type) => authBox?.put("role", type);
  static String getAccessToken() => authBox?.get('token', defaultValue: '');
  static String getUserRole() => authBox?.get('role', defaultValue: '');
  static int getUserId() => authBox?.get("id", defaultValue: 0);
}
