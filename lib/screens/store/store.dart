import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/screens/store/edit_products/main.dart';
import 'package:Erdenet24/screens/store/orders/main.dart';
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
    dynamic res = await RestApi().getUser(RestApiHelper.getUserId());
    dynamic data = Map<String, dynamic>.from(res);
    setState(() {
      _user = data["data"];
      isOpen = data["data"]["isOpen"];
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
    return Scaffold(
      body: _user.isNotEmpty
          ? Column(
              children: [
                SizedBox(height: Get.height * .075),
                CircleAvatar(
                  backgroundImage: const NetworkImage(
                      'https://www.woolha.com/media/2020/03/eevee.png'),
                  radius: Get.width * .1,
                ),
                const SizedBox(height: 8),
                CustomText(
                  text: _user["name"],
                  fontSize: 16,
                ),
                const SizedBox(height: 4),
                CustomText(
                  text: _user["phone"],
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
                          Get.to(() => AddProducts());
                        }),
                        _listTile(IconlyLight.chart, "Захиалгууд", () {
                          Get.to(() => StoreOrders());
                        }),
                        // _divider(),
                        // _listTile(IconlyLight.setting, "Тохиргоо", () {}),
                        // _listTile(IconlyLight.wallet, "Төлбөр тооцоо", () {}),
                        // _divider(),
                        // _listTile(IconlyLight.info_circle,
                        //     "Үйлчилгээний нөхцөл", () {}),
                        _divider(),
                        _listTile(IconlyLight.info_circle, "Тусламж", () {}),
                        _listTile(IconlyLight.login, "Аппаас гарах", () {
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
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(18)),
                    child: Image(
                      image: const AssetImage("assets/images/png/android.png"),
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
    );
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

  Widget _switchListTile() {
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
