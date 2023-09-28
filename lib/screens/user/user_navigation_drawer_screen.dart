import 'dart:convert';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/screens/user/user_products_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_address_edit_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_help_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_phone_edit_screen.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:iconly/iconly.dart';

class UserNavigationDrawerScreen extends StatefulWidget {
  const UserNavigationDrawerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserNavigationDrawerScreen> createState() =>
      _UserNavigationDrawerScreenState();
}

class _UserNavigationDrawerScreenState
    extends State<UserNavigationDrawerScreen> {
  dynamic _user = [];
  final _loginCtx = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    dynamic res = await RestApi().getUser(RestApiHelper.getUserId());
    dynamic data = Map<String, dynamic>.from(res);
    setState(() {
      _user = data["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: double.infinity,
      child: CustomHeader(
        title: 'Ангилал',
        customActions: Container(),
        customLeading: _leading(),
        body: _user.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: Get.width * .075),
                      dense: true,
                      minLeadingWidth: Get.width * .07,
                      leading: const Icon(
                        IconlyLight.call,
                        color: MyColors.black,
                        size: 20,
                      ),
                      title: CustomText(
                        text: _user["phone"],
                        fontSize: 14,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          Get.to(() => const UserProfilePhoneEditScreen());
                        },
                        icon: const Icon(
                          IconlyLight.edit_square,
                          size: 16,
                          color: MyColors.black,
                        ),
                      ),
                    ),
                    _listTile(IconlyLight.location, "Хүргэлтийн хаяг", () {
                      Get.to(() => const UserProfileAddressEditScreen());
                    }),
                    _listTile(IconlyLight.info_circle, "Тусламж", () {
                      Get.to(() => const UserProfileHelpScreen());
                    }),
                    _listTile(IconlyLight.delete, "Бүртгэлээ устгах", () {
                      CustomDialogs().showAccountDeleteDialog(() async {
                        CustomDialogs().showLoadingDialog();
                        dynamic response = await RestApi()
                            .deleteUser(RestApiHelper.getUserId());
                        dynamic d = Map<String, dynamic>.from(response);
                        Get.back();
                        if (d["success"]) {
                          _loginCtx.logout();
                        } else {
                          customSnackbar(
                            DialogType.error,
                            "Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу",
                            3,
                          );
                        }
                      });
                    }),
                    _listTile(IconlyLight.login, "Системээс гарах", () {
                      CustomDialogs().showLogoutDialog(() {
                        _loginCtx.logout();
                      });
                    })
                  ],
                ),
              )
            : MyShimmers().userPage(),
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
