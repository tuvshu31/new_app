import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  bool _phoneNumberOk = false;
  bool _addressOk = false;
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
    var query = {"id": RestApiHelper.getUserId()};
    dynamic res = await RestApi().getUsers(query);
    dynamic data = Map<String, dynamic>.from(res);
    log(data.toString());
    setState(() {
      _user = data["data"][0];
    });
    phoneController.text = _user["deliveryPhone"].toString();
    addressController.text = _user["deliveryAddress"];
    kodeController.text = _user["deliveryKode"];
  }

  void saveDeliveryInfo() async {
    loadingDialog(context);
    var body = {
      "deliveryPhone": phoneController.text,
      "deliveryAddress": addressController.text,
      "deliveryKode": kodeController.text,
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
                  onChanged: ((val) {
                    setState(() {
                      _phoneNumberOk = val.length == 8 ? true : false;
                    });
                  }),
                ),
                SizedBox(height: Get.height * .02),
                CustomTextField(
                  hintText: "Хаяг",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: addressController,
                  onChanged: ((val) {
                    setState(() {
                      _addressOk = val.isNotEmpty;
                    });
                  }),
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
                  isActive: _phoneNumberOk && _addressOk,
                  onPressed: saveDeliveryInfo,
                ),
              ]))
          : MyShimmers().userPage(),
    );
  }
}
