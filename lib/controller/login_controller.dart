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
import 'package:url_launcher/url_launcher.dart';
import '../api/restapi_helper.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/screens/splash/splash_phone_register_screen.dart';

class LoginController extends GetxController {
  final _cartCtx = Get.put(CartController());
  RxInt verifyCode = 0.obs;
  TextEditingController phoneController = TextEditingController();
  final _navCtx = Get.put(NavigationController());

  //Хэрэглэгч системээс гарах
  void logout() async {
    Get.back();
    CustomDialogs().showLoadingDialog();
    var body = {"mapToken": ""};
    await RestApi().updateUser(RestApiHelper.getUserId(), body);
    RestApiHelper.saveUserId(0);
    RestApiHelper.saveUserRole("");
    RestApiHelper.saveOrderId(0);
    _navCtx.onItemTapped(0);
    _cartCtx.savedList.clear();
    Get.back();
    Get.offAll(() => const SplashPhoneRegisterScreen());
  }

  Future<void> navigateToScreen(String route, context) async {
    var isEnabled = await Geolocator.checkPermission();
    if (isEnabled == LocationPermission.always ||
        isEnabled == LocationPermission.whileInUse) {
      Get.offAllNamed(route);
    } else {
      Get.offAllNamed(splashProminentDisclosureScreenRoute, arguments: route);
    }
  }

  final _checker = AppVersionChecker();

  void checkVersion(context) {
    _checker.checkUpdate().then((value) {
      log(value.toString());
      value.canUpdate
          ? showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async => false,
                  child: AlertDialog(
                    title:
                        IconButton(onPressed: () {}, icon: Icon(Icons.close)),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(text: "Анхааруулга"),
                          SizedBox(height: 24),
                          CustomText(
                              fontSize: 12,
                              textAlign: TextAlign.justify,
                              text:
                                  "Аппликейшнд нэмэлт өөрчлөлт орсон тул шинэчлэлт хийх шаардлагатай. Хэрэв шинэчлэлт хийгээгүй тохиолдолд аппликейшнийг бүрэн ашиглах боломжгүйг анхаарна уу.")
                        ],
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: <Widget>[
                      Container(
                        width: Get.width * .4,
                        margin: const EdgeInsets.only(bottom: 24),
                        child: CustomButton(
                          onPressed: () async {
                            final Uri url = Uri.parse(value.appURL!);
                            await launchUrl(url);
                          },
                          text: "Шинэчлэх",
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          : null;
    });
  }

  void getFirebaseMessagingToken(context) async {
    checkVersion(context);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    var body = {"mapToken": fcmToken};
    await RestApi().updateUser(RestApiHelper.getUserId(), body);
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      var body = {"mapToken": newToken};
      await RestApi().updateUser(RestApiHelper.getUserId(), body);
    });
  }
}
