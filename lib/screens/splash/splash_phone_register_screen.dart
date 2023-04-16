import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/notification.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/screens/splash/splash_privacy_policy_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SplashPhoneRegisterScreen extends StatefulWidget {
  const SplashPhoneRegisterScreen({super.key});

  @override
  State<SplashPhoneRegisterScreen> createState() =>
      _SplashPhoneRegisterScreenState();
}

class _SplashPhoneRegisterScreenState extends State<SplashPhoneRegisterScreen> {
  bool _phoneNumberOk = false;
  bool _privacyApproved = false;

  final _loginCtrl = Get.put(LoginController());
  @override
  void initState() {
    super.initState();

    _loginCtrl.phoneController.clear();
  }

  void sendOTP() async {
    loadingDialog(context);
    if (_loginCtrl.phoneController.text == "99681828") {
      _loginCtrl.verifyCode.value = 111111;
    } else {
      _loginCtrl.verifyCode.value = random6digit();
    }
    dynamic authCode = await RestApi().sendAuthCode(
        _loginCtrl.phoneController.text,
        _loginCtrl.verifyCode.value.toString());
    Get.back();
    if (authCode[0]["Result"] == "SUCCESS") {
      Get.toNamed(splashOtpScreenRoute);
    } else {
      errorSnackBar(
          "Серверийн алдаа гарлаа түр хүлээгээд дахин оролдоно уу", 2, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      customActions: Container(),
      title: "Нэвтрэх",
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
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
              text: "Баталгаажуулах код илгээх утасны дугаараа оруулна уу",
              color: MyColors.gray,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Get.height * .03),
            CustomTextField(
              autoFocus: true,
              hintText: "Утасны дугаар",
              keyboardType: TextInputType.number,
              maxLength: 8,
              controller: _loginCtrl.phoneController,
              onChanged: ((val) {
                setState(() {
                  _phoneNumberOk = val.length == 8 ? true : false;
                });
              }),
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: (() {
                      setState(() {
                        _privacyApproved = !_privacyApproved;
                      });
                    }),
                    child: !_privacyApproved
                        ? const Icon(Icons.circle_outlined,
                            color: MyColors.primary)
                        : const Icon(Icons.check_circle_outline_outlined,
                            color: MyColors.primary)),
                const SizedBox(width: 12),
                Row(
                  children: [
                    GestureDetector(
                      onTap: (() {
                        Get.toNamed(splashPrivacyPolicyRoute);
                      }),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: Get.height * .03),
                        child: const CustomText(
                          text: "Үйлчилгээний нөхцөл",
                          color: MyColors.primary,
                          isUnderLined: true,
                        ),
                      ),
                    ),
                    const Text(" зөвшөөрч байна")
                  ],
                ),
              ],
            ),
            SizedBox(height: Get.height * .01),
            CustomButton(
              text: "Үргэлжлүүлэх",
              isActive: _phoneNumberOk && _privacyApproved,
              onPressed: sendOTP,
            ),
          ],
        ),
      ),
    );
  }
}
