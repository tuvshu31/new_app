import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../api/restapi_helper.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/screens/splash/splash_phone_register_screen.dart';

class LoginController extends GetxController {
  final _cartCtx = Get.put(CartController());
  RxInt verifyCode = 0.obs;
  TextEditingController phoneController = TextEditingController();
  final _navCtx = Get.put(NavigationController());
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  //Хэрэглэгч системээс гарах
  void logout() async {
    Get.back();
    CustomDialogs().showLoadingDialog();
    RestApiHelper.saveUserId(0);
    RestApiHelper.saveUserRole("");
    RestApiHelper.saveOrderId(0);
    _navCtx.onItemTapped(0);
    _cartCtx.savedList.clear();
    Get.back();
    Get.offAll(() => const SplashPhoneRegisterScreen());
  }

  Future<void> navigateToScreen(String route) async {
    var isEnabled = await Geolocator.checkPermission();
    if (isEnabled == LocationPermission.always ||
        isEnabled == LocationPermission.whileInUse) {
      Get.offAllNamed(route);
    } else {
      Get.offAllNamed(splashProminentDisclosureScreenRoute, arguments: route);
    }
  }

  void requestNotificationPermission(String role) async {
    NotificationSettings settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // _messaging.subscribeToTopic('mass-msg');
      bool isSubscribed = RestApiHelper.isSubscribedToFirebase();
      if (!isSubscribed) {
        _messaging.getToken().then((token) async {
          if (token != null) {
            var body = {"mapToken": token};
            await RestApi().updateUser(RestApiHelper.getUserId(), body);
            dynamic response = await RestApi().subscribeToFirebase(role, token);
            if (response != null) {
              dynamic d = Map<String, dynamic>.from(response);
              if (d["success"]) {
                RestApiHelper.subscribeToFirebase();
              }
            }
          }
        });
      }
    } else {
      _messaging.getToken().then((token) async {
        if (token != null) {
          var body = {"mapToken": token};
          await RestApi().updateUser(RestApiHelper.getUserId(), body);
        }
      });
    }
  }

  void listenToTokenChanges(String role) {
    _messaging.onTokenRefresh.listen((newToken) async {
      var body = {"mapToken": newToken};
      await RestApi().updateUser(RestApiHelper.getUserId(), body);
      dynamic response = await RestApi().subscribeToFirebase(role, newToken);
      if (response != null) {
        dynamic d = Map<String, dynamic>.from(response);
        if (d["success"]) {
          RestApiHelper.subscribeToFirebase();
        }
      }
    });
  }
}
