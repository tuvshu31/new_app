import 'package:get/get.dart';
import '../api/restapi_helper.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/screens/splash/phone_register.dart';

class LoginController extends GetxController {
  RxInt verifyCode = 0.obs;
  TextEditingController phoneController = TextEditingController();
  //Хэрэглэгч системээс гарах
  void logout() async {
    RestApiHelper.saveUserId(0);
    RestApiHelper.saveUserRole("");
    Get.offAll(() => const PhoneRegister());
  }
}
