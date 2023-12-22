import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';

import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';

class SplashMainScreen extends StatefulWidget {
  const SplashMainScreen({Key? key}) : super(key: key);

  @override
  State<SplashMainScreen> createState() => _SplashMainScreenState();
}

class _SplashMainScreenState extends State<SplashMainScreen> {
  String currentVersion = "";
  final _checker = AppVersionChecker();

  @override
  void initState() {
    super.initState();
    handleInitialRoute();
  }

  Future<void> handleInitialRoute() async {
    AppCheckerResult appCheckerResult = await _checker.checkUpdate();
    currentVersion = appCheckerResult.currentVersion;
    setState(() {});
    if (appCheckerResult.canUpdate) {
      //Update хийгээгүй хэрэглэгч
      _showUpdateDialog();
      return;
    }
    if (RestApiHelper.getUserId() != 0) {
      //Login хийсэн хэрэглэгч
      String route = _initialRoute(RestApiHelper.getUserRole());
      Get.offAllNamed(route);
    } else {
      await Future.delayed(const Duration(seconds: 3));
      Get.offAllNamed(splashPhoneRegisterScreenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Column(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(18)),
                child: Image(
                  image: const AssetImage("assets/images/png/android.png"),
                  width: width * .22,
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
              currentVersion.isNotEmpty
                  ? CustomText(
                      text: "Хувилбар: $currentVersion",
                      fontSize: 10,
                    )
                  : CustomShimmer(
                      width: Get.width * .22,
                      height: 14,
                    ),
              SizedBox(height: height * .05)
            ],
          )
        ],
      ),
    );
  }
}

String _initialRoute(String role) {
  switch (role) {
    case "store":
      return storeMainScreenRoute;
    case "driver":
      return driverMainScreenRoute;
    case "user":
      return userHomeScreenRoute;
    default:
      return userHomeScreenRoute;
  }
}

void _showUpdateDialog() {
  CustomDialogs().showNewVersionDialog(() async {
    final appId = Platform.isAndroid ? 'mn.et24' : '6444353401';
    final url = Uri.parse(
      Platform.isAndroid
          ? "market://details?id=$appId"
          : "https://apps.apple.com/app/id$appId",
    );
    launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  });
}
