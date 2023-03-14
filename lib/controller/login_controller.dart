import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:get/get.dart';
import '../api/restapi_helper.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/screens/splash/splash_phone_register_screen.dart';

class LoginController extends GetxController {
  final _cartCtrl = Get.put(CartController());
  RxInt verifyCode = 0.obs;
  TextEditingController phoneController = TextEditingController();
  //Хэрэглэгч системээс гарах
  void logout() async {
    var body = {"mapToken": ""};
    await RestApi().updateUser(RestApiHelper.getUserId(), body);
    RestApiHelper.deleteUserId(0);
    RestApiHelper.deleteUserRole("");
    RestApiHelper.saveOrderId(0);

    _cartCtrl.savedList.clear();
    Get.offAll(() => const SplashPhoneRegisterScreen());
  }
}
