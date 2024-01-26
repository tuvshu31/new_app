import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import "package:flutter/material.dart";
import 'package:new_version/new_version.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:upgrader/upgrader.dart';

class SplashMainScreen extends StatefulWidget {
  const SplashMainScreen({Key? key}) : super(key: key);

  @override
  State<SplashMainScreen> createState() => _SplashMainScreenState();
}

class _SplashMainScreenState extends State<SplashMainScreen> {
  String currentVersion = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> handleInitialRoute(bool isUpdateNeeded) async {
    if (isUpdateNeeded) {
      return;
    } else {
      if (RestApiHelper.getUserId() != 0) {
        //Login хийсэн хэрэглэгч
        String route = _initialRoute(RestApiHelper.getUserRole());
        Get.offAllNamed(route);
      } else {
        //Login хийгээгүй хэрэглэгч
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(splashPhoneRegisterScreenRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return UpgradeAlert(
      upgrader: Upgrader(
        messages: UpgraderMessages(code: 'mn'),
        canDismissDialog: false,
        showIgnore: false,
        showLater: false,
        showReleaseNotes: false,
        shouldPopScope: () => false,
        willDisplayUpgrade: (
            {appStoreVersion,
            required display,
            installedVersion,
            minAppVersion}) async {
          handleInitialRoute(display);
        },
      ),
      child: Scaffold(
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
                SizedBox(height: height * .05)
              ],
            )
          ],
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
