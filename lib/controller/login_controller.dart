import 'dart:developer';
import 'dart:io';

import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import '../api/restapi_helper.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/screens/splash/splash_phone_register_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginController extends GetxController {
  final _navCtx = Get.put(NavigationController());
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  //Хэрэглэгч системээс гарах
  void logout() async {
    Get.back();
    CustomDialogs().showLoadingDialog();
    deleteToken();
    RestApiHelper.saveUserRole("");
    RestApiHelper.saveToken("");
    _navCtx.onItemTapped(0);
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

  void saveUserToken() {
    _messaging.getToken().then((token) async {
      if (token != null) {
        var body = {
          "role": RestApiHelper.getUserRole(),
          "token": token,
        };
        await UserApi().saveUserTokenNew(body);
      }
    });
  }

  // void listenToTokenChanges(String role) {
  //   _messaging.onTokenRefresh.listen((newToken) async {
  //     var body = {"mapToken": newToken};
  //     await RestApi().updateUser(RestApiHelper.getUserId(), body);
  //     dynamic response = await RestApi().subscribeToFirebase(role, newToken);
  //     if (response != null) {
  //       dynamic d = Map<String, dynamic>.from(response);
  //       if (d["success"]) {
  //         RestApiHelper.subscribeToFirebase();
  //       }
  //     }
  //   });
  // }

  void deleteToken() {
    _messaging.deleteToken();
  }

  Future<void> checkUserDeviceInfo() async {
    String role = RestApiHelper.getUserRole();
    String device = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model!;
    }
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.utsname.machine!;
    }
    dynamic checkUserDeviceInfo =
        await UserApi().checkUserDeviceInfo(role, device);
    if (checkUserDeviceInfo != null) {
      dynamic response = Map<String, dynamic>.from(checkUserDeviceInfo);
      log(response.toString());
      if (response["success"]) {
        if (response["status"] == "different") {
          showGeneralDialog(
            context: Get.context!,
            barrierLabel: "",
            barrierDismissible: false,
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (ctx, a1, a2) {
              return Container();
            },
            transitionBuilder: (ctx, a1, a2, child) {
              var curve = Curves.bounceInOut.transform(a1.value);
              return WillPopScope(
                onWillPop: () async => false,
                child: Transform.scale(
                  scale: curve,
                  child: Center(
                    child: Container(
                      width: Get.width,
                      margin: EdgeInsets.all(Get.width * .09),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.only(
                        right: Get.width * .09,
                        left: Get.width * .09,
                        top: Get.height * .04,
                        bottom: Get.height * .03,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              IconlyBold.info_circle,
                              size: Get.width * .15,
                              color: Colors.amber,
                            ),
                            SizedBox(height: Get.height * .02),
                            const Text(
                              "Анхааруулга",
                              style: TextStyle(
                                color: MyColors.gray,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: Get.height * .02),
                            Column(
                              children: [
                                const Text(
                                  "Та өөр төхөөрөмжөөс хандаж байгаа тул таны өмнө хандсан төхөөрөмж холболтоос салахыг анхаарна уу",
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: Get.height * .04),
                                CustomButton(
                                  isFullWidth: false,
                                  onPressed: Get.back,
                                  bgColor: Colors.amber,
                                  text: "Ok",
                                  elevation: 0,
                                  textColor: Colors.white,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      }
    }
  }
}
