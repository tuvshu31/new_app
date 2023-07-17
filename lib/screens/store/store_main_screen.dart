import 'package:Erdenet24/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';

class StoreMainScreen extends StatefulWidget {
  const StoreMainScreen({Key? key}) : super(key: key);

  @override
  State<StoreMainScreen> createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {
  final _storeCtx = Get.put(StoreController());
  final _loginCtx = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    _storeCtx.fetchStoreInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => !_storeCtx.fetching.value
            ? Column(
                children: [
                  SizedBox(height: Get.height * .075),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "${URL.AWS}/users/${RestApiHelper.getUserId()}/small/1.png"),
                    radius: Get.width * .1,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    text: _storeCtx.storeInfo["name"] ?? "",
                    fontSize: 16,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text: _storeCtx.storeInfo["phone"] ?? "",
                    fontSize: 12,
                    color: MyColors.gray,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * .02),
                          _switchListTile(),
                          _listTile(IconlyLight.edit, "Бараа нэмэх, засварлах",
                              () {
                            Get.toNamed(storeProductsEditMainScreenRoute);
                          }),
                          _listTile(IconlyLight.chart, "Захиалгууд", () {
                            Get.toNamed(storeOrdersScreenRoute);
                          }),
                          _listTile(IconlyLight.setting, "Тохиргоо", () {
                            Get.toNamed(storeSettingsScreenRoute);
                          }),
                          _listTile(IconlyLight.info_circle, "Тусламж", () {}),
                          _listTile(IconlyLight.login, "Аппаас гарах", () {
                            CustomDialogs().showLogoutDialog(() {
                              _loginCtx.logout();
                            });
                          })
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18)),
                      child: Image(
                        image:
                            const AssetImage("assets/images/png/android.png"),
                        width: Get.width * .22,
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

  Widget _switchListTile() {
    bool isOpen = _storeCtx.storeInfo["isOpen"];
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: Get.width * .075),
      dense: true,
      minLeadingWidth: Get.width * .07,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isOpen ? IconlyLight.hide : IconlyLight.show,
            color: MyColors.black,
            size: 20,
          ),
        ],
      ),
      title: CustomText(
        text: isOpen ? "Дэлгүүрээ хаах" : "Дэлгүүрээ нээх",
        fontSize: 14,
      ),
      trailing: CupertinoSwitch(
        value: isOpen,
        thumbColor: isOpen ? MyColors.primary : MyColors.gray,
        trackColor: MyColors.background,
        activeColor: MyColors.black,
        onChanged: (value) {
          closeStoreModal(
            context,
            "Дэлгүүрээ ${isOpen ? "хаах уу?" : "нээх үү?"}",
            isOpen
                ? "Дэлгүүрээ хааснаар дэлгүүрийн мэдээлэл болон бараанууд аппликейшн дээр харагдахгүй болохыг анхаарна уу"
                : "Дэлгүүрээ нээснээр дэлгүүрийн бараанууд хэрэглэгчидэд харагдаж, цагийн хуваарын дагуу захиалга хийх боломжтой болохыг анхаарна уу",
            isOpen ? "Хаах" : "Нээх",
            () {
              Get.back();
              if (value == true) {}
              _storeCtx.storeInfo["isOpen"] = value;
              var body = {"isOpen": value};
              _storeCtx.updateStoreInfo(
                  body,
                  context,
                  isOpen ? "Дэлгүүр хаагдлаа" : "Дэлгүүр нээгдлээ",
                  "Алдаа гарлаа");
            },
          );
        },
      ),
    );
  }
}
