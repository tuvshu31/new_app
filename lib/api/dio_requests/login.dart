import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/api/dio_instance.dart';

class LoginAPi {
  static final LoginAPi _singleton = LoginAPi._internal();
  factory LoginAPi() => _singleton;
  LoginAPi._internal();

  //Аппликейшны хувилбар шалгах
  Future checkAppVersion(dynamic body) async {
    return DioClient().sendRequest('checkAppVersion', Method.post, body, {});
  }

  //Нэг удаагийн код үүсгэх
  Future sendAuthCode(String phone) async {
    return DioClient()
        .sendRequest('sendAuthCode?phone=$phone', Method.post, [], {});
  }

  //Хэрэглэгчийн role-г шалгах
  Future handleRole(var body) async {
    return DioClient().sendRequest('handleRole', Method.post, body, {});
  }

  //Бүх аймгуудын мэдээллийг дуудах
  Future getProvinceList() async {
    return DioClient().sendRequest('getProvinceList', Method.post, [], {});
  }
}
