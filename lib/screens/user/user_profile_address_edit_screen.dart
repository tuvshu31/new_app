import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';

class UserProfileAddressEditScreen extends StatefulWidget {
  const UserProfileAddressEditScreen({super.key});

  @override
  State<UserProfileAddressEditScreen> createState() =>
      _UserProfileAddressEditScreenState();
}

class _UserProfileAddressEditScreenState
    extends State<UserProfileAddressEditScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController kodeController = TextEditingController();
  dynamic _user = [];

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    dynamic res = await RestApi().getUser(RestApiHelper.getUserId());
    dynamic data = Map<String, dynamic>.from(res);
    _user = data["data"];
    if (_user["userPhone"] != 0 && _user["userPhone"] != null) {
      phoneController.text = _user["userPhone"].toString();
    }
    if (_user["userAddress"] != null && _user["userAddress"].isNotEmpty) {
      addressController.text = _user["userAddress"];
    }
    if (_user["userAddress"] != null && _user["userEntranceCode"].isNotEmpty) {
      kodeController.text = _user["userEntranceCode"];
    }
    setState(() {});
  }

  void saveDeliveryInfo() async {
    loadingDialog(context);
    var body = {
      "userPhone": phoneController.text,
      "userAddress": addressController.text,
      "userEntranceCode": kodeController.text,
    };
    dynamic authCode =
        await RestApi().updateUser(RestApiHelper.getUserId(), body);
    dynamic response = Map<String, dynamic>.from(authCode);
    Get.back();
    if (response["success"]) {
      successSnackBar("Амжилттай хадгалагдлаа", 3, context);
      Get.back();
    } else {
      errorSnackBar(
          "Серверийн алдаа гарлаа түр хүлээгээд дахин оролдоно уу", 2, context);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      customActions: Container(),
      title: "Хүргэлтийн хаяг",
      body: _user.isNotEmpty
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: MyColors.fadedGrey, shape: BoxShape.circle),
                  child: Image(
                    image:
                        const AssetImage("assets/images/png/app/address.png"),
                    width: Get.width * .1,
                  ),
                ),
                SizedBox(height: Get.height * .03),
                const CustomText(
                  text: "Хүргэлтийн мэдээллээ хадгалах",
                  color: MyColors.gray,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Get.height * .03),
                CustomTextField(
                  autoFocus: true,
                  hintText: "Утасны дугаар",
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  controller: phoneController,
                  onChanged: ((val) {}),
                ),
                SizedBox(height: Get.height * .02),
                CustomTextField(
                  hintText: "Хаяг",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: addressController,
                  onChanged: ((val) {}),
                ),
                SizedBox(height: Get.height * .02),
                CustomTextField(
                  textInputAction: TextInputAction.done,
                  hintText: "Орцны код - (Заавал биш)",
                  keyboardType: TextInputType.text,
                  controller: kodeController,
                ),
                SizedBox(height: Get.height * .03),
                CustomButton(
                  text: "Хадгалах",
                  onPressed: saveDeliveryInfo,
                ),
              ]))
          : MyShimmers().userPage(),
    );
  }
}
