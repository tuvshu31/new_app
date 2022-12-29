import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/screens/user/profile/user/address/address.dart';
import 'package:Erdenet24/screens/user/profile/user/help/help.dart';
import 'package:Erdenet24/screens/user/profile/user/orders/user_orders.dart';
import 'package:Erdenet24/screens/user/profile/user/phone/phone.dart';
import 'package:Erdenet24/utils/shimmers.dart';
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

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    var query = {"id": RestApiHelper.getUserId()};
    dynamic res = await RestApi().getUsers(query);
    dynamic data = Map<String, dynamic>.from(res);
    log(data.toString());
    setState(() {
      _user = data["data"][0];
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
                _listTile(IconlyLight.location, "Хүргэлтийн хаяг", () {
                  Get.to(() => const AddressView());
                }),
                _listTile(IconlyLight.chart, "Захиалгууд", () {
                  Get.to(() => const UserOrders());
                }),
                _divider(),
                // _listTile(IconlyLight.document, "Үйлчилгээний нөхцөл", () {}),
                _listTile(IconlyLight.info_circle, "Тусламж", () {
                  Get.to(() => const HelpView());
                }),
                _listTile(IconlyLight.login, "Аппаас гарах", () {
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
