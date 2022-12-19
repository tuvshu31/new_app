import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/screens/user/profile/user/orders/user_orders.dart';
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
        ? Column(
            children: [
              ListTile(
                leading: const SizedBox(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://www.woolha.com/media/2020/03/eevee.png'),
                    radius: 50,
                  ),
                ),
                title: CustomText(
                  text: _user["name"] ?? "Хэрэглэгч",
                  fontSize: 14,
                ),
                subtitle: CustomText(
                  text: "+976-${_user["phone"]}",
                  fontSize: 12,
                ),
                trailing: const Icon(
                  IconlyLight.arrow_right_2,
                  color: MyColors.black,
                  size: 18,
                ),
              ),
              _divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _listTile(IconlyLight.chart, "Миний захиалгууд", () {
                        Get.to(() => UserOrders());
                      }),
                      _listTile(IconlyLight.location, "Хүргэлтийн хаяг", () {}),
                      _listTile(IconlyLight.setting, "Тохиргоо", () {}),
                      _divider(),
                      _listTile(IconlyLight.info_circle, "Тусламж", () {}),
                      _listTile(
                          IconlyLight.document, "Үйлчилгээний нөхцөл", () {}),
                      _listTile(IconlyLight.login, "Системээс гарах", () {
                        logOutModal(context, () {
                          _loginCtrl.logout();
                        });
                      })
                    ],
                  ),
                ),
              ),
            ],
          )
        : MyShimmers().listView();
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        dense: true,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: MyColors.black,
              size: 20,
            ),
          ],
        ),
        title: CustomText(
          text: title,
          fontSize: 14,
        ),
      ),
    );
  }
}
