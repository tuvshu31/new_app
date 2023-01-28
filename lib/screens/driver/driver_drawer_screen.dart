import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

Widget driverDrawer() {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
            decoration: BoxDecoration(color: Colors.red),
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColors.white,
                  ),
                  child: Icon(
                    FontAwesomeIcons.user,
                    size: 40,
                    color: MyColors.grey,
                  ),
                ),
                SizedBox(height: 14),
                CustomText(
                  text: "+976-99921312",
                  color: MyColors.white,
                )
              ],
            )),
        _listTile(IconlyLight.user, "Тохиргоо", () {}),
        _listTile(IconlyLight.location, "Хүргэлтүүд", () {}),
        _listTile(IconlyLight.wallet, "Төлбөр", () {}),
        SizedBox(height: Get.height * .45),
        CustomText(
          text: "Холбоо барих:",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 18),
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
