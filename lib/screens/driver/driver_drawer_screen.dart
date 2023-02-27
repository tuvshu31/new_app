import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/screens/driver/driver_deliver_list_page.dart';
import 'package:Erdenet24/screens/driver/driver_payments_page.dart';
import 'package:Erdenet24/screens/driver/driver_settings_page.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:app_settings/app_settings.dart';

final _loginCtx = Get.put(LoginController());
final _driverCtx = Get.put(DriverController());
Widget driverDrawer(context) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
            decoration: const BoxDecoration(color: Colors.red),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(const DriverSettingsPage());
                  },
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.white,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.user,
                      size: 40,
                      color: MyColors.grey,
                    ),
                  ),
                ),
                CustomText(
                  text: "Э.Түвшинбаяр",
                  color: MyColors.white,
                )
              ],
            )),
        _listTile(IconlyLight.user, "Тохиргоо", () {
          AppSettings.openAppSettings();
        }),
        _listTile(IconlyLight.location, "Хүргэлтүүд", () {
          Get.to(() => const DriverDeliverListPage());
        }),
        _listTile(IconlyLight.wallet, "Төлбөр", () {
          Get.to(() => const DriverPaymentsPage());
        }),
        _listTile(
            IconlyLight.logout,
            "Аппаас гарах",
            () => logOutModal(context, () {
                  _loginCtx.logout();
                })),
        const SizedBox(height: 18),
      ],
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
