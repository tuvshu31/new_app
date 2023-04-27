import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
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
      Get.offAndToNamed(route);
    } else {
      Get.offAndToNamed(splashProminentDisclosureScreenRoute, arguments: route);
    }
  }

  final _checker = AppVersionChecker();

  Future<void> checkVersion(context) async {
    _checker.checkUpdate().then((value) {
      log(value.toString());
    });
  }

  void getFirebaseMessagingToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      log(fcmToken);
      var body = {"mapToken": fcmToken};
      await RestApi().updateUser(RestApiHelper.getUserId(), body);
    }
    // if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
    //   try {
    //     firebaseAppToken =
    //         await AwesomeNotificationsFcm().requestFirebaseAppToken();
    //     var body = {"mapToken": firebaseAppToken};
    //     await RestApi().updateUser(RestApiHelper.getUserId(), body);
    //   } catch (exception) {
    //     debugPrint('$exception');
    //   }
    // } else {
    //   debugPrint('Firebase is not available on this project');
    // }
    // return firebaseAppToken;
  }
}
