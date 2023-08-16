import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:app_settings/app_settings.dart';

final _loginCtx = Get.put(LoginController());

class DriverDrawerScreen extends StatefulWidget {
  const DriverDrawerScreen({super.key});

  @override
  State<DriverDrawerScreen> createState() => _DriverDrawerScreenState();
}

class _DriverDrawerScreenState extends State<DriverDrawerScreen> {
  bool loading = false;
  List driverInfo = [];
  @override
  void initState() {
    super.initState();
    getDriverInfo();
  }

  Future<void> getDriverInfo() async {
    loading = true;
    dynamic res = await RestApi().getUser(RestApiHelper.getUserId());
    if (res != null) {
      dynamic response = Map<String, dynamic>.from(res);
      driverInfo = [response["data"]];
      log(response["data"].toString());
    }
    loading = false;
    setState(() {});
  }

  String generateDriverName(driverInfo) {
    var first = driverInfo["firstName"] ?? "";
    var last = driverInfo["lastName"] ?? "";
    var name = "${first[0]}. $last";
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          DrawerHeader(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.white,
                  border: Border.all(width: 1, color: MyColors.background),
                ),
                child: const Icon(
                  FontAwesomeIcons.user,
                  size: 40,
                  color: MyColors.grey,
                ),
              ),
              loading
                  ? CustomShimmer(width: Get.width * .2, height: 14)
                  : Text(generateDriverName(driverInfo[0]))
            ],
          )),
          _listTile(IconlyLight.user, "Миний бүртгэл", () {
            Get.toNamed(driverSettingsScreenRoute);
          }),
          _listTile(IconlyLight.setting, "Тохиргоо", () {
            AppSettings.openAppSettings();
          }),
          _listTile(IconlyLight.location, "Хүргэлтүүд", () {
            Get.toNamed(driverDeliverListScreenRoute);
          }),
          _listTile(IconlyLight.wallet, "Төлбөр", () {
            Get.toNamed(driverPaymentsScreenRoute);
          }),
          _listTile(IconlyLight.logout, "Аппаас гарах", () {
            CustomDialogs().showLogoutDialog(() {
              _loginCtx.logout();
            });
          }),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

Widget _listTile(IconData icon, String title, dynamic onTap) {
  return CustomInkWell(
    borderRadius: BorderRadius.zero,
    onTap: onTap,
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: Get.width * .075),
      dense: true,
      minLeadingWidth: Get.width * .07,
      leading: Icon(
        icon,
        color: MyColors.black,
        size: 20,
      ),
      title: CustomText(
        text: title,
        fontSize: 14,
      ),
    ),
  );
}
