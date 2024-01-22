import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:app_settings/app_settings.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';

import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/screens/user/user_profile_help_screen.dart';

class DriverDrawerScreen extends StatefulWidget {
  const DriverDrawerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DriverDrawerScreen> createState() => _DriverDrawerScreenState();
}

class _DriverDrawerScreenState extends State<DriverDrawerScreen> {
  bool loading = false;
  String userPhone = "";
  final _loginCtx = Get.put(LoginController());
  final _driverCtx = Get.put(DriverController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Drawer(
        width: double.infinity,
        child: CustomHeader(
            title: 'Профайл',
            customActions: Container(),
            customLeading: _leading(),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: Get.width * .075),
                    dense: true,
                    minLeadingWidth: Get.width * .07,
                    leading: const Icon(
                      IconlyLight.user,
                      color: MyColors.black,
                      size: 20,
                    ),
                    title: CustomText(
                      text: _driverCtx.driverInfo["firstName"] ?? "",
                      fontSize: 14,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Get.toNamed(driverProfileScreenRoute);
                      },
                      icon: const Icon(
                        IconlyLight.edit_square,
                        size: 16,
                        color: MyColors.black,
                      ),
                    ),
                  ),
                  _listTile(IconlyLight.location, "Хүргэлтүүд", () {
                    Get.toNamed(driverDeliverListScreenRoute);
                  }),
                  _listTile(IconlyLight.wallet, "Төлбөр", () {
                    Get.toNamed(driverPaymentsScreenRoute);
                  }),
                  _listTile(IconlyLight.setting, "Тохиргоо", () {
                    AppSettings.openAppSettings();
                  }),
                  _listTile(IconlyLight.info_circle, "Тусламж", () {
                    Get.toNamed(driverHelpScreenRoute);
                  }),
                  _listTile(IconlyLight.login, "Системээс гарах", () {
                    CustomDialogs().showLogoutDialog(() {
                      _loginCtx.logout();
                    });
                  })
                ],
              ),
            )),
      ),
    );
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
}

Widget _leading() {
  return IconButton(
    onPressed: () {
      Get.back();
    },
    icon: const Icon(
      Icons.clear_rounded,
      size: 24,
      color: MyColors.black,
    ),
  );
}
