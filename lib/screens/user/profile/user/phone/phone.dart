import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PhoneEditView extends StatefulWidget {
  const PhoneEditView({super.key});

  @override
  State<PhoneEditView> createState() => _PhoneEditViewState();
}

class _PhoneEditViewState extends State<PhoneEditView> {
  TextEditingController phoneController = TextEditingController();
  bool phoneIsOk = false;
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
    setState(() {
      _user = data["data"][0];
    });
    phoneController.text = _user["phone"].toString();
  }

  void savePhoneNumber() async {
    loadingDialog(context);
    var body = {
      "phone": phoneController.text,
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
    return _user.isNotEmpty
        ? CustomHeader(
            customActions: Container(),
            title: "Утасны дугаар өөрчлөх",
            body: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color: MyColors.fadedGrey, shape: BoxShape.circle),
                    child: Image(
                      image: const AssetImage("assets/images/png/app/dial.png"),
                      width: Get.width * .1,
                    ),
                  ),
                  SizedBox(height: Get.height * .03),
                  const CustomText(
                    text: "Утасны дугаараа оруулна уу",
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
                    onChanged: (p0) {
                      setState(() {
                        phoneIsOk = p0.length == 8;
                      });
                    },
                  ),
                  SizedBox(height: Get.height * .03),
                  CustomButton(
                    text: "Өөрчлөх",
                    isActive: phoneIsOk,
                    onPressed: savePhoneNumber,
                  ),
                ])))
        : Material(
            child: Container(),
          );
  }
}
