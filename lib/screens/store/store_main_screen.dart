import 'dart:developer';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/controller/login_controller.dart';

class StoreMainScreen extends StatefulWidget {
  const StoreMainScreen({Key? key}) : super(key: key);

  @override
  State<StoreMainScreen> createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {
  final _loginCtx = Get.put(LoginController());
  final _storeCtx = Get.put(StoreController());
  Map data = {};
  bool loading = false;
  int storeId = RestApiHelper.getUserId();
  String deviceStatus = "";

  @override
  void initState() {
    super.initState();
    _loginCtx.saveUserToken();
    _loginCtx.checkUserDeviceInfo();
    getStoreInfo();
  }

  void getStoreInfo() async {
    loading = true;
    dynamic getStoreInfo = await StoreApi().getStoreInfo();
    loading = false;
    if (getStoreInfo != null) {
      dynamic response = Map<String, dynamic>.from(getStoreInfo);
      if (response["success"]) {
        data = response["data"];

        _storeCtx.isOpen.value = data["isOpen"];
        if (_storeCtx.isOpen.value) {
          checkStoreNewOrders();
        } else {}
      }
    }
    setState(() {});
  }

  void openAndCloseStore(int open) async {
    CustomDialogs().showLoadingDialog();
    dynamic openAndCloseStore = await StoreApi().openAndCloseStore(open);
    Get.back();
    if (openAndCloseStore != null) {
      dynamic response = Map<String, dynamic>.from(openAndCloseStore);
      if (response["success"]) {
        _storeCtx.isOpen.value = open == 1;
        setState(() {});
        if (_storeCtx.isOpen.value) {
          checkStoreNewOrders();
        } else {}
        customSnackbar(ActionType.success,
            "Дэлгүүр ${_storeCtx.isOpen.value ? "нээгдлээ" : "хаагдлаа"}", 2);
      }
    }
  }

  void checkStoreNewOrders() async {
    dynamic checkStoreNewOrders = await StoreApi().checkStoreNewOrders();
    if (checkStoreNewOrders != null) {
      dynamic response = Map<String, dynamic>.from(checkStoreNewOrders);
      log(response.toString());
      if (response["success"]) {
        if (response["data"]) {
          _storeCtx.handleSentAction({"id": 0});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: Get.height * .075),
          customImage(
            Get.width * .23,
            "${URL.AWS}/users/${data["id"]}/small/1.png",
            isCircle: true,
          ),
          SizedBox(height: Get.width * .03),
          loading
              ? CustomShimmer(width: Get.width * .3, height: 16)
              : Text(data["name"]),
          SizedBox(height: Get.width * .02),
          loading
              ? CustomShimmer(width: Get.width * .3, height: 16)
              : Text(
                  data["phone"],
                  style: const TextStyle(
                    color: MyColors.gray,
                  ),
                ),
          SizedBox(height: Get.height * .02),
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: Get.width * .075),
            dense: true,
            minLeadingWidth: Get.width * .07,
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _storeCtx.isOpen.value ? IconlyLight.hide : IconlyLight.show,
                  color: MyColors.black,
                  size: 20,
                ),
              ],
            ),
            title: CustomText(
              text:
                  _storeCtx.isOpen.value ? "Дэлгүүрээ хаах" : "Дэлгүүрээ нээх",
              fontSize: 14,
            ),
            trailing: CupertinoSwitch(
              value: loading ? false : _storeCtx.isOpen.value,
              thumbColor:
                  _storeCtx.isOpen.value ? MyColors.primary : MyColors.gray,
              trackColor: MyColors.background,
              activeColor: MyColors.black,
              onChanged: (value) {
                showCustomDialog(ActionType.warning,
                    "Та дэлгүүрээ ${_storeCtx.isOpen.value ? "хаахдаа" : "нээхдээ"} итгэлтэй байна уу?",
                    () {
                  Get.back();
                  openAndCloseStore(_storeCtx.isOpen.value ? 0 : 1);
                });
              },
            ),
          ),
          _listTile(IconlyLight.plus, "Бараа нэмэх", () {
            Get.toNamed(storeProductsAddScreenRoute);
          }),
          _listTile(IconlyLight.edit, "Барааны мэдээлэл засах", () {
            Get.toNamed(storeProductsEditScreenRoute);
          }),
          _listTile(IconlyLight.graph, "Захиалгууд", () {
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
          }),
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
}
