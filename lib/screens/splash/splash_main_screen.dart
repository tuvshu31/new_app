import 'dart:async';
import "package:flutter/material.dart";

import 'package:get/get.dart';

import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/screens/splash/splash_phone_register_screen.dart';

class SplashMainScreen extends StatefulWidget {
  const SplashMainScreen({Key? key}) : super(key: key);

  @override
  State<SplashMainScreen> createState() => _SplashMainScreenState();
}

class _SplashMainScreenState extends State<SplashMainScreen> {
  bool stayOnScreen = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      handleInitialRoute();
    });
  }

  void handleInitialRoute() {
    if (RestApiHelper.getUserId() != 0) {
      if (RestApiHelper.getUserRole() == "store") {
        Get.offAllNamed(storeMainScreenRoute);
      } else if (RestApiHelper.getUserRole() == "driver") {
        Get.offAllNamed(driverMainScreenRoute);
      } else if (RestApiHelper.getUserRole() == "user") {
        if (RestApiHelper.getOrderId() != 0) {
          Get.offAllNamed(userOrdersActiveScreenRoute);
        } else {
          Get.offAllNamed(userHomeScreenRoute);
        }
      }
    } else {
      setState(() {
        stayOnScreen = true;
      });
      Timer(
        const Duration(seconds: 4),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const SplashPhoneRegisterScreen()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.white,
      body: stayOnScreen
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Column(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18)),
                        child: Image(
                          image:
                              const AssetImage("assets/images/png/android.png"),
                          width: _width * .22,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "ERDENET24",
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "Exo",
                          fontSize: 22,
                          color: MyColors.black,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: MyColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const CustomText(
                        text: "Шинэчлэл шалгаж байна...",
                        fontSize: 12,
                      ),
                      SizedBox(height: _height * .05)
                    ],
                  )
                ],
              ),
            )
          : Container(),
    );
  }
}
