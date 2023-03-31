import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/screens/splash/splash_prominent_disclosure_screen.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:geolocator/geolocator.dart';
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

    RestApiHelper.saveUserId(0);
    RestApiHelper.saveUserRole("");
    RestApiHelper.saveOrderId(0);

    _cartCtrl.savedList.clear();
    Get.offAll(() => const SplashPhoneRegisterScreen());
  }

  Future<void> navigateToScreen(String route, context) async {
    var isEnabled = await Geolocator.checkPermission();
    if (isEnabled == LocationPermission.always ||
        isEnabled == LocationPermission.whileInUse) {
      showLocationDisclosureScreen(context);
    } else {
      Get.offAndToNamed(splashProminentDisclosureScreenRoute, arguments: route);
    }
  }
}
