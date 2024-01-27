import 'dart:io';
import 'dart:async';
import 'package:Erdenet24/api/dio_requests/user.dart';
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
    checkAppVersion();
  }

  void checkAppVersion() async {
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
    dynamic checkAppVersion = await UserApi().checkAppVersion(body);
    loading = false;
    if (checkAppVersion != null) {
      dynamic response = Map<String, dynamic>.from(checkAppVersion);
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
    }
    setState(() {});
  }

  Future<void> handleInitialRoute() async {
    if (RestApiHelper.getUserId() != 0) {
      String route = _initialRoute(RestApiHelper.getUserRole());
      Get.offAllNamed(route);
    } else {
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
                  fontFamily: "Montserrat",
                  fontSize: 22,
                  color: MyColors.black,
                ),
              )
            ],
          ),
          loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: MyColors.primary,
                    strokeWidth: 2,
                  ),
                )
              : Container()
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
