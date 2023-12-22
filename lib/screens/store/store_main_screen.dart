import 'dart:developer';
import 'dart:io';

import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/api/socket_instance.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
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
import 'package:Erdenet24/widgets/custom_loading_widget.dart';

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
  bool isOpen = false;
  int storeId = RestApiHelper.getUserId();
  String deviceStatus = "";

  @override
  void initState() {
    super.initState();
    getStoreInfo();
    _loginCtx.checkUserDeviceInfo();
  }

  void getStoreInfo() async {
    loading = true;
    dynamic getStoreInfo = await StoreApi().getStoreInfo();
    loading = false;
    if (getStoreInfo != null) {
      dynamic response = Map<String, dynamic>.from(getStoreInfo);
      if (response["success"]) {
        data = response["data"];
        isOpen = data["isOpen"];
        if (isOpen) {
          SocketClient().connect();
          checkStoreNewOrders();
        } else {
          SocketClient().disconnect();
        }
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
        isOpen = open == 1;
        setState(() {});
        if (isOpen) {
          SocketClient().connect();
          checkStoreNewOrders();
        } else {
          SocketClient().disconnect();
        }
        customSnackbar(ActionType.success,
            "Дэлгүүр ${isOpen ? "нээгдлээ" : "хаагдлаа"}", 2);
      }
    }
  }

  void checkStoreNewOrders() async {
    dynamic checkStoreNewOrders = await StoreApi().checkStoreNewOrders();
    if (checkStoreNewOrders != null) {
      dynamic response = Map<String, dynamic>.from(checkStoreNewOrders);
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
        body: loading
            ? customLoadingWidget()
            : Column(
                children: [
                  SizedBox(height: Get.height * .075),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      "${URL.AWS}/users/${data["id"]}/small/1.png",
                    ),
                    radius: Get.width * .1,
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    text: data["name"] ?? "",
                    fontSize: 16,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text: data["phone"] ?? "",
                    fontSize: 12,
                    color: MyColors.gray,
                  ),
                  SizedBox(height: Get.height * .02),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: Get.width * .075),
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
                        showCustomDialog(ActionType.warning,
                            "Та дэлгүүрээ ${isOpen ? "хаахдаа" : "нээхдээ"} итгэлтэй байна уу?",
                            () {
                          Get.back();
                          openAndCloseStore(isOpen ? 0 : 1);
                        });
                      },
                    ),
                  ),
                  _listTile(IconlyLight.plus, "Бараа нэмэх", () {
                    Get.toNamed(storeProductsAddScreenRoute);
                  }),
                  _listTile(IconlyLight.edit, "Бараа засварлах", () {
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
              ));
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
