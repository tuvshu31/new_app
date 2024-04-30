import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:Erdenet24/api/dio_requests/login.dart';
import 'package:get/get.dart';
import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';

import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashMainScreen extends StatefulWidget {
  const SplashMainScreen({Key? key}) : super(key: key);

  @override
  State<SplashMainScreen> createState() => _SplashMainScreenState();
}

class _SplashMainScreenState extends State<SplashMainScreen> {
  bool loading = false;

  @override
  void initState() {
    super.initState();
    checkAppVersionNew();
  }

  void checkAppVersionNew() async {
    loading = true;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String platform = Platform.isIOS ? "IOS" : "Android";
    var body = {
      "version": version,
      "buildNumber": buildNumber,
      "platform": platform
    };
    dynamic checkAppVersionNew = await LoginAPi().checkAppVersionNew(body);
    loading = false;
    if (checkAppVersionNew != null) {
      dynamic response = Map<String, dynamic>.from(checkAppVersionNew);
      if (response["success"]) {
        handleInitialRoute();
      } else {
        final uri = Uri.parse(response["url"]);
        CustomDialogs().showNewVersionDialog(() async {
          launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        });
      }
    } else {
      log("Error!");
    }
    setState(() {});
  }

  Future<void> handleInitialRoute() async {
    if (RestApiHelper.getToken() == "") {
      Get.offAllNamed(splashPhoneRegisterScreenRoute);
    } else {
      String route = _initialRoute(RestApiHelper.getUserRole());
      Get.offAllNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: MyColors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(18)),
              child: Image(
                image: const AssetImage("assets/images/png/android.png"),
                width: width * .23,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "E24",
              softWrap: true,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 22,
                color: MyColors.black,
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        height: height * .1,
        child: Center(
          child: loading
              ? SizedBox(
                  width: width * .05,
                  height: width * .05,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    color: MyColors.primary,
                  ),
                )
              : Container(),
        ),
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
