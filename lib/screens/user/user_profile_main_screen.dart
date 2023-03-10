import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/screens/user/user_orders_main_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_address_edit_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_help_screen.dart';
import 'package:Erdenet24/screens/user/user_cart_address_info_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_phone_edit_screen.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/login_controller.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  dynamic _user = [];
  int userId = RestApiHelper.getUserId();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordRepeat = TextEditingController();
  final _loginCtrl = Get.put(LoginController());
  final _userCtx = Get.put(UserController());

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
    return _user.isNotEmpty
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
                      Get.to(() => const PhoneEditView());
                    },
                    icon: const Icon(
                      IconlyLight.edit_square,
                      size: 16,
                      color: MyColors.black,
                    ),
                  ),
                ),
                _divider(),
                _listTile(IconlyLight.location, "???????????????????? ????????", () {
                  Get.to(() => const UserProfileAddressEditScreen());
                }),
                _listTile(IconlyLight.chart, "????????????????????", () {
                  // Get.to(() => const UserOrderScreen());
                  Get.to(() => const UserOrdersMainScreen());
                }),
                _divider(),
                _listTile(IconlyLight.info_circle, "??????????????", () {
                  Get.to(() => const UserProfileHelpScreen());
                }),
                _listTile(IconlyLight.delete, "?????????????????? ????????????", () {
                  accountDeleteModal(context, () async {
                    loadingDialog(context);
                    dynamic response =
                        await RestApi().deleteUser(RestApiHelper.getUserId());
                    dynamic d = Map<String, dynamic>.from(response);
                    Get.back();
                    if (d["success"]) {
                      _loginCtrl.logout();
                    } else {
                      errorSnackBar(
                          "?????????? ????????????, ?????? ?????????????????? ?????????? ???????????????? ????",
                          3,
                          context);
                    }
                  });
                }),
                _listTile(IconlyLight.login, "???????????? ??????????", () {
                  logOutModal(context, () {
                    _loginCtrl.logout();
                  });
                })
              ],
            ),
          )
        : MyShimmers().userPage();
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
