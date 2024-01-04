import 'dart:developer';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/screens/user/user_profile_phone_edit_otp_screen.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class UserProfilePhoneEditScreen extends StatefulWidget {
  const UserProfilePhoneEditScreen({super.key});

  @override
  State<UserProfilePhoneEditScreen> createState() =>
      _UserProfilePhoneEditScreenState();
}

class _UserProfilePhoneEditScreenState
    extends State<UserProfilePhoneEditScreen> {
  bool phoneNumberOk = false;
  TextEditingController phoneController = TextEditingController();
  final _userCtx = Get.put(UserController());

  void checkPhoneAndSendOTP() async {
    CustomDialogs().showLoadingDialog();
    String phone = phoneController.text;
    dynamic checkPhoneAndSendOTP = await UserApi().checkPhoneAndSendOTP(phone);
    Get.back();
    if (checkPhoneAndSendOTP != null) {
      dynamic response = Map<String, dynamic>.from(checkPhoneAndSendOTP);
      if (response["success"]) {
        Get.to(
          () => const UserProfilePhoneEditOtpScreen(),
          arguments: {"phone": phone, "code": response["code"]},
        );
      } else {
        customSnackbar(ActionType.error, response["error"], 3);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
        customActions: Container(),
        title: "Утасны дугаараа солих",
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
                text: "Шинэ утасны дугаараа оруулна уу",
                color: MyColors.gray,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Get.height * .03),
              CustomTextField(
                autoFocus: true,
                hintText: "Утасны дугаар",
                keyboardType: TextInputType.number,
                maxLength: 8,
                controller: phoneController,
                onChanged: ((val) {
                  phoneNumberOk = val.length == 8 ? true : false;
                  setState(() {});
                }),
              ),
              SizedBox(height: Get.height * .03),
              CustomButton(
                text: "Баталгаажуулах код авах",
                isActive: phoneNumberOk,
                onPressed: () {
                  if (_userCtx.userInfo["phone"] == phoneController.text) {
                    customSnackbar(
                        ActionType.error,
                        "Уучлаарай шинэ утасны дугаар одоогийн утасны дугаартай адил байна",
                        3);
                  } else {
                    checkPhoneAndSendOTP();
                  }
                },
              ),
            ])));
  }
}
