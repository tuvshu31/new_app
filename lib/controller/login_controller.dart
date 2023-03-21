import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:get/get.dart';
import '../api/restapi_helper.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/screens/splash/splash_phone_register_screen.dart';

class LoginController extends GetxController {
  final _cartCtrl = Get.put(CartController());
  RxString initialRoute = splashMainScreenRoute.obs;
  RxInt verifyCode = 0.obs;
  TextEditingController phoneController = TextEditingController();

  void handleInitialRoute() {
    if (RestApiHelper.getUserId() != 0) {
      if (RestApiHelper.getUserRole() == "store") {
        initialRoute.value = storeMainScreenRoute;
      } else if (RestApiHelper.getUserRole() == "driver") {
        initialRoute.value = driverMainScreenRoute;
      } else if (RestApiHelper.getUserRole() == "user") {
        if (RestApiHelper.getOrderId() != 0) {
          initialRoute.value = userOrdersActiveScreenRoute;
        } else {
          initialRoute.value = userHomeScreenRoute;
        }
      }
    } else {
      initialRoute.value = splashMainScreenRoute;
    }
  }

  //Хэрэглэгч системээс гарах
  void logout() async {
    var body = {"mapToken": ""};
    await RestApi().updateUser(RestApiHelper.getUserId(), body);

    RestApiHelper.saveUserId(0);
    RestApiHelper.saveUserRole("");
    RestApiHelper.saveOrderId(0);

    _cartCtrl.savedList.clear();
    Get.offAll(() => const SplashPhoneRegisterScreen());
  }
}
