import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:app_settings/app_settings.dart';

final _loginCtx = Get.put(LoginController());
final _driverCtx = Get.put(DriverController());
String generateDriverName(driverInfo) {
  var first = driverInfo["firstName"] ?? "";
  var last = driverInfo["lastName"] ?? "";
  var name = "${first[0]}. $last";
  return name;
}

Widget driverDrawer(context) {
  return Obx(
    () => Drawer(
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
                      Get.toNamed(driverSettingsScreenRoute);
                    },
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: const BoxDecoration(
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
                    text: _driverCtx.driverInfo.isNotEmpty
                        ? generateDriverName(_driverCtx.driverInfo[0])
                        : "Жолооч",
                    color: MyColors.white,
                  )
                ],
              )),
          _listTile(IconlyLight.user, "Тохиргоо", () {
            AppSettings.openAppSettings();
          }),
          _listTile(IconlyLight.location, "Хүргэлтүүд", () {
            Get.toNamed(driverDeliverListScreenRoute);
          }),
          _listTile(IconlyLight.wallet, "Төлбөр", () {
            Get.toNamed(driverPaymentsScreenRoute);
          }),
          _listTile(IconlyLight.logout, "Аппаас гарах", () {}
              // () => logOutModal(() async {
              //   // var body = {"isOpen": 0};
              //   // await RestApi().updateUser(RestApiHelper.getUserId(), body);
              //   // _loginCtx.logout();
              // }),
              ),
          const SizedBox(height: 18),
        ],
      ),
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
