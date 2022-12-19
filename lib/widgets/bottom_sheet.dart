import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

Widget _listItem(dynamic onTap, IconData icon, String text) {
  return Expanded(
    child: CustomInkWell(
      borderRadius: BorderRadius.zero,
      onTap: onTap,
      child: Center(
        child: Row(
          children: [
            SizedBox(width: Get.width * .03),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: MyColors.fadedGrey, shape: BoxShape.circle),
              child: Icon(
                icon,
                size: 18,
              ),
            ),
            SizedBox(width: Get.width * .03),
            CustomText(text: text),
          ],
        ),
      ),
    ),
  );
}

Widget _listItemWithColor(
    dynamic onTap, IconData icon, String text, bool isActive) {
  return Expanded(
    child: CustomInkWell(
      borderRadius: BorderRadius.zero,
      onTap: onTap,
      child: Center(
        child: Row(
          children: [
            SizedBox(width: Get.width * .03),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: isActive ? MyColors.fadedRed : Color(0xffd8f4e5),
                  shape: BoxShape.circle),
              child: Icon(
                icon,
                size: 16,
                color: isActive ? MyColors.primary : MyColors.success,
              ),
            ),
            SizedBox(width: Get.width * .03),
            CustomText(text: text),
          ],
        ),
      ),
    ),
  );
}

Widget _listItemWithColor1(
    dynamic onTap, IconData icon, String text, bool isActive) {
  return Expanded(
    child: CustomInkWell(
      borderRadius: BorderRadius.zero,
      onTap: onTap,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: Get.width * .03),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: isActive
                      ? MyColors.fadedRed
                      : Color.fromARGB(255, 224, 248, 235),
                  shape: BoxShape.circle),
              child: Icon(
                icon,
                size: 16,
                color: isActive ? MyColors.primary : MyColors.success,
              ),
            ),
            SizedBox(width: Get.width * .03),
            CustomText(text: text),
          ],
        ),
      ),
    ),
  );
}

void editProductBottomSheet(onTap, isActive) {
  Get.bottomSheet(Container(
    height: Get.height * .3,
    decoration: const BoxDecoration(
      color: MyColors.white,
    ),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: Get.width * .03),
      child: Column(
        children: [
          _listItem(onTap[0], IconlyLight.edit, "Барааны мэдээлэл засах"),
          _listItemWithColor(onTap[1], IconlyLight.show,
              isActive ? "Идэвхгүй болгох" : "Идэвхтэй болгох", isActive),
          _listItem(onTap[2], IconlyLight.document, "Үлдэгдэл өөрчлөх"),
          _listItem(onTap[3], IconlyLight.delete, "Устгах")
        ],
      ),
    ),
  ));
}

void paymentBottomSheet(onTap) {
  Get.bottomSheet(Container(
    height: Get.height * .2,
    decoration: const BoxDecoration(
      color: MyColors.white,
    ),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: Get.width * .03),
      child: Column(
        children: [
          _listItem(onTap[0], IconlyLight.swap, "Дансны шилжүүлгээр"),
          _listItem(() {}, IconlyLight.wallet, "Банкны апп-аар"),
          _listItem(() {}, IconlyLight.scan, "QPay-ээр")
        ],
      ),
    ),
  ));
}

void cartListBottomSheet(onTap) {
  Get.bottomSheet(Container(
    height: Get.height * .12,
    decoration: const BoxDecoration(
      color: MyColors.white,
    ),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: Get.width * .03),
      child: Row(
        children: [
          _listItemWithColor1(
              onTap[0], IconlyLight.buy, "Сагсанд нэмэх", false),
          _listItemWithColor1(() {}, IconlyLight.delete, "Устгах", true),
        ],
      ),
    ),
  ));
}

void savedListBottomSheet(onTap) {
  Get.bottomSheet(Container(
    height: Get.height * .12,
    decoration: const BoxDecoration(
      color: MyColors.white,
    ),
    child: Container(
      margin: EdgeInsets.symmetric(vertical: Get.width * .03),
      child: Row(
        children: [
          _listItemWithColor1(onTap[0], IconlyLight.buy, "Хадгалах", false),
          _listItemWithColor1(() {}, IconlyLight.delete, "Устгах", true),
        ],
      ),
    ),
  ));
}
