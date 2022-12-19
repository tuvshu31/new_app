import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/screens/store/edit_products/main.dart';
import 'package:Erdenet24/screens/store/orders/main.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/login_controller.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  dynamic _user = [];
  bool isOpen = false;
  int userId = RestApiHelper.getUserId();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordRepeat = TextEditingController();
  final _loginCtrl = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    getStoreInfo();
  }

  void getStoreInfo() async {
    var query = {"id": RestApiHelper.getUserId()};
    dynamic res = await RestApi().getUsers(query);
    dynamic data = Map<String, dynamic>.from(res);
    setState(() {
      _user = data["data"][0];
      isOpen = data["data"][0]["isOpen"];
    });
  }

  void updateStoreHelper(int id, dynamic body) async {
    dynamic user = await RestApi().updateUser(id, body);
    dynamic data = Map<String, dynamic>.from(user);
    if (data["success"]) {
      successSnackBar(
          body["isOpen"] ? "Дэлгүүр нээгдлээ" : "Дэлгүүр хаагдлаа", 2, context);
    } else {
      errorSnackBar("Үл мэдэгдэх алдаа гарлаа", 2, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _user.isNotEmpty
        ? CustomHeader(
            customLeading: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://www.woolha.com/media/2020/03/eevee.png'),
                radius: 36,
              ),
            ),
            title: _user["name"],
            subtitle: "+976-${_user["phone"]}",
            customActions: IconButton(
                onPressed: () {},
                icon: Icon(
                  IconlyLight.edit,
                  size: 18,
                  color: MyColors.black,
                )),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Get.height * .02),
                        _switchListTile(),
                        _listTile(IconlyLight.edit, "Бараа нэмэх, засварлах",
                            () {
                          Get.to(() => AddProducts());
                        }),
                        _listTile(IconlyLight.chart, "Захиалгууд", () {
                          Get.to(() => StoreOrders());
                        }),
                        _divider(),
                        _listTile(IconlyLight.setting, "Тохиргоо", () {}),
                        _listTile(IconlyLight.wallet, "Төлбөр тооцоо", () {}),
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
            ),
          )
        : Material(child: MyShimmers().listView());
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

  Widget _switchListTile() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      dense: true,
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
      trailing: Switch(
          activeColor: MyColors.primary,
          value: isOpen,
          onChanged: (val) {
            closeStoreModal(
              context,
              "Дэлгүүрээ ${isOpen ? "хаах уу?" : "нээх үү?"}",
              isOpen
                  ? "Дэлгүүрээ хааснаар дэлгүүрийн мэдээлэл болон бараанууд аппликейшн дээр харагдахгүй болохыг анхаарна уу"
                  : "Дэлгүүрээ нээснээр дэлгүүрийн бараанууд хэрэглэгчидэд харагдаж, цагийн хуваарын дагуу захиалга хийх боломжтой болохыг анхаарна уу",
              isOpen ? "Хаах" : "Нээх",
              () {
                Get.back();
                loadingDialog(context);
                updateStoreHelper(_user["id"], {..._user, "isOpen": val});
                Get.back();
                setState(() {
                  isOpen = val;
                });
              },
            );
          }),
    );
  }
}
