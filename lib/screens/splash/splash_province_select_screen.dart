import 'dart:developer';

import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/api/dio_requests/login.dart';

class SplashProvinceSelectScreen extends StatefulWidget {
  const SplashProvinceSelectScreen({super.key});

  @override
  State<SplashProvinceSelectScreen> createState() =>
      _SplashProvinceSelectScreenState();
}

class _SplashProvinceSelectScreenState
    extends State<SplashProvinceSelectScreen> {
  bool loading = false;
  List province = [];
  final arguments = Get.arguments;
  final loginCtx = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    getProvinceList();
  }

  void getProvinceList() async {
    loading = true;
    dynamic getProvinceList = await LoginAPi().getProvinceList();
    loading = false;
    if (getProvinceList != null) {
      dynamic response = Map<String, dynamic>.from(getProvinceList);
      if (response["success"]) {
        province = response["data"];
      }
    }
    setState(() {});
  }

  void saveUserInfo(String token, String role) {
    RestApiHelper.saveUserRole(role);
    RestApiHelper.saveToken(token);
  }

  void handleUserLogin(token, role) {
    saveUserInfo(token, role);
    loginCtx.navigateToScreen(userHomeScreenRoute);
  }

  void handleStoreLogin(userToken, storeToken, role) {
    Get.bottomSheet(
        backgroundColor: MyColors.white,
        isDismissible: false,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        )), StatefulBuilder(
      builder: ((context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _content(
                storeToken,
                "store",
                "Байгууллага",
                storeMainScreenRoute,
                const AssetImage("assets/images/png/user.png"),
              ),
              const Divider(),
              _content(
                userToken,
                "user",
                "Хэрэглэгч",
                userHomeScreenRoute,
                const AssetImage("assets/images/png/user.png"),
              ),
            ],
          ),
        );
      }),
    ));
  }

  void handleDriverLogin(userToken, driverToken, role) {
    Get.bottomSheet(
      StatefulBuilder(
        builder: ((context, setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _content(
                  driverToken,
                  "driver",
                  "Жолооч",
                  driverMainScreenRoute,
                  const AssetImage("assets/images/png/car.png"),
                ),
                const Divider(),
                _content(
                  userToken,
                  "user",
                  "Хэрэглэгч",
                  userHomeScreenRoute,
                  const AssetImage("assets/images/png/user.png"),
                ),
              ],
            ),
          );
        }),
      ),
      backgroundColor: MyColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }

  Widget _content(
    String token,
    String role,
    String title,
    String route,
    ImageProvider image,
  ) {
    return GestureDetector(
      onTap: () {
        saveUserInfo(token, role);
        loginCtx.navigateToScreen(route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
            width: Get.width * .1,
            height: Get.width * .1,
            child: CircleAvatar(
              backgroundImage: image,
            ),
          ),
          title: Text(title),
          trailing: const Icon(
            IconlyLight.arrow_right_2,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }

  Future<void> handleRole(Map province) async {
    CustomDialogs().showLoadingDialog();
    var body = {"provinceId": province["id"], "phone": arguments["phone"]};
    dynamic handleRole = await LoginAPi().handleRole(body);
    Get.back();
    dynamic response = Map<String, dynamic>.from(handleRole);
    log(response.toString());
    if (response["success"]) {
      String role = response["role"];
      if (role == "user") {
        handleUserLogin(response["userToken"], role);
      }
      if (role == "store") {
        handleStoreLogin(response["userToken"], response["storeToken"], role);
      }
      if (role == "driver") {
        handleDriverLogin(response["userToken"], response["driverToken"], role);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Байршил сонгох",
      customActions: Container(),
      body: loading && province.isEmpty
          ? listShimmerWidget()
          : !loading && province.isEmpty
              ? customEmptyWidget("Байршил хоосон байна")
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 7,
                      color: MyColors.fadedGrey,
                    );
                  },
                  itemCount: province.length,
                  itemBuilder: (context, index) {
                    var item = province[index];
                    return CustomInkWell(
                      borderRadius: BorderRadius.zero,
                      onTap: () {
                        item["active"] ? handleRole(item) : null;
                      },
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        leading: SizedBox(
                            width: Get.width * .1,
                            height: Get.width * .1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColors.fadedGrey,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                IconlyLight.location,
                                color: item["active"]
                                    ? MyColors.primary
                                    : MyColors.gray,
                              ),
                            )),
                        title: Text(item["name"],
                            style: TextStyle(
                                fontSize: 14,
                                color: item["active"]
                                    ? MyColors.black
                                    : MyColors.gray)),
                        trailing: const Icon(
                          IconlyLight.arrow_right_2,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
