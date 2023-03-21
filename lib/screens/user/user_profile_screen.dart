import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/screens/user/user_profile_orders_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_help_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_phone_edit_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_address_edit_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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
    return CustomHeader(
        isMainPage: true,
        title: 'Профайл',
        customActions: Container(),
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
                    _divider(),
                    _listTile(IconlyLight.location, "Хүргэлтийн хаяг", () {
                      Get.to(() => const UserProfileAddressEditScreen());
                    }),
                    _listTile(IconlyLight.chart, "Захиалгууд", () {
                      Get.to(() => const UserProfileOrdersScreen());
                    }),
                    _divider(),
                    _listTile(IconlyLight.info_circle, "Тусламж", () {
                      Get.to(() => const UserProfileHelpScreen());
                    }),
                    _listTile(IconlyLight.delete, "Бүртгэлээ устгах", () {
                      accountDeleteModal(context, () async {
                        loadingDialog(context);
                        dynamic response = await RestApi()
                            .deleteUser(RestApiHelper.getUserId());
                        dynamic d = Map<String, dynamic>.from(response);
                        Get.back();
                        if (d["success"]) {
                          _loginCtx.logout();
                        } else {
                          errorSnackBar(
                              "Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу",
                              3,
                              context);
                        }
                      });
                    }),
                    _listTile(IconlyLight.login, "Аппаас гарах", () {
                      logOutModal(context, () {
                        _loginCtx.logout();
                      });
                    })
                  ],
                ),
              )
            : MyShimmers().userPage());
  }

  Widget _divider() {
    return Column(
      children: [
        SizedBox(height: Get.height * .01),
        Container(
          width: double.infinity,
          height: 1,
          color: MyColors.background,
        ),
        SizedBox(height: Get.height * .01),
      ],
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
