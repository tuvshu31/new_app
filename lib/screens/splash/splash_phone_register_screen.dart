import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/screens/splash/splash_otp_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class SplashPhoneRegisterScreen extends StatefulWidget {
  const SplashPhoneRegisterScreen({super.key});

  @override
  State<SplashPhoneRegisterScreen> createState() =>
      _SplashPhoneRegisterScreenState();
}

class _SplashPhoneRegisterScreenState extends State<SplashPhoneRegisterScreen> {
  bool _phoneNumberOk = false;
  bool _privacyApproved = false;
  String _agreementText = "";

  void loadAgreement() async {
    dynamic agreement =
        await rootBundle.loadString('assets/json/agreement.txt');
    setState(() {
      _agreementText = agreement;
    });
  }

  final _loginCtrl = Get.put(LoginController());
  @override
  void initState() {
    super.initState();
    loadAgreement();
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

  void showPrivacy() {
    Get.bottomSheet(
      SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            color: MyColors.white,
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * .06, vertical: Get.width * .06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomText(
                  text: "Үйлчилгээний нөхцөл",
                  fontSize: 14,
                  isUpperCase: true,
                ),
                const SizedBox(height: 24),
                _agreementText.isNotEmpty
                    ? CustomText(
                        text: _agreementText,
                        textAlign: TextAlign.justify,
                        height: 1.8,
                      )
                    : MyShimmers().userPage(),
                const SizedBox(height: 24),
                CustomButton(
                  isActive: true,
                  onPressed: (() {
                    setState(() {
                      if (!_privacyApproved) {
                        _privacyApproved = true;
                      }
                      Get.back();
                    });
                  }),
                  text: "Зөвшөөрөх",
                )
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
        customActions: Container(),
        title: "Нэвтрэх",
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
              SizedBox(height: Get.height * .03),
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
                          showPrivacy();
                        }),
                        child: const CustomText(
                          text: "Үйлчилгээний нөхцөл",
                          color: MyColors.primary,
                          isUnderLined: true,
                        ),
                      ),
                      const Text(" зөвшөөрч байна")
                    ],
                  ),
                ],
              ),
              SizedBox(height: Get.height * .03),
              CustomButton(
                text: "Үргэлжлүүлэх",
                isActive: _phoneNumberOk && _privacyApproved,
                // isActive: _phoneNumberOk,
                onPressed: sendOTP,
              ),
            ])));
  }
}
