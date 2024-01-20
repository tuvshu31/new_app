import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';

class SplashPhoneRegisterScreen extends StatefulWidget {
  const SplashPhoneRegisterScreen({super.key});

  @override
  State<SplashPhoneRegisterScreen> createState() =>
      _SplashPhoneRegisterScreenState();
}

class _SplashPhoneRegisterScreenState extends State<SplashPhoneRegisterScreen> {
  bool _phoneNumberOk = false;
  bool _privacyApproved = false;
  TextEditingController controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void sendOTP() async {
    CustomDialogs().showLoadingDialog();
    dynamic generateCode = await UserApi().sendAuthCode(controller.text);
    dynamic codeResponse = Map<String, dynamic>.from(generateCode);
    Get.back();
    if (codeResponse["success"]) {
      int code = codeResponse["code"];
      Get.toNamed(
        splashOtpScreenRoute,
        arguments: {"code": code.toString(), "phone": controller.text},
      );
    } else {
      customSnackbar(
          ActionType.error, "Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу", 3);
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
                image: const AssetImage("assets/images/png/dial.png"),
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
              controller: controller,
              onChanged: ((val) {
                _phoneNumberOk = val.length == 8 ? true : false;
                setState(() {});
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
