import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/screens/splash/otp.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/header.dart';
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
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _kodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void sendOTP() async {
    // loadingDialog(context);
    // // _loginCtrl.verifyCode.value = random6digit();
    // dynamic authCode = await RestApi().sendAuthCode(
    //     _loginCtrl.phoneController.text,
    //     _loginCtrl.verifyCode.value.toString());
    // Get.back();
    // if (authCode[0]["Result"] == "SUCCESS") {
    //   Get.to(() => const OtpScreen());
    // } else {
    //   errorSnackBar(
    //       "Серверийн алдаа гарлаа түр хүлээгээд дахин оролдоно уу", 2, context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
        customActions: Container(),
        title: "Хүргэлтийн хаяг",
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: MyColors.fadedGrey, shape: BoxShape.circle),
                child: Image(
                  image: const AssetImage("assets/images/png/app/address.png"),
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
                controller: _phoneController,
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
                controller: _addressController,
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
                controller: _kodeController,
              ),
              SizedBox(height: Get.height * .03),
              CustomButton(
                text: "Хадгалах",
                isActive: _phoneNumberOk && _addressOk,
                onPressed: sendOTP,
              ),
            ])));
  }
}
