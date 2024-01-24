import 'dart:async';
import 'dart:developer';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';

class SplashOtpScreen extends StatefulWidget {
  const SplashOtpScreen({super.key});

  @override
  State<SplashOtpScreen> createState() => _SplashOtpScreenState();
}

class _SplashOtpScreenState extends State<SplashOtpScreen> {
  String loginType = "";
  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 1);
  final arguments = Get.arguments;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        final seconds = myDuration.inSeconds - 1;
        if (seconds < 0) {
          countdownTimer!.cancel();
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    });
  }

  void sendOTP() async {
    CustomDialogs().showLoadingDialog();
    dynamic generateCode = await UserApi().sendAuthCode(arguments["phone"]);
    dynamic response = Map<String, dynamic>.from(generateCode);
    Get.back();
    myDuration = const Duration(minutes: 1);
    setState(() {});
    startTimer();
    if (response["success"]) {
      int code = response["code"];
      arguments['code'] = code.toString();
    } else {
      countdownTimer!.cancel();
      customSnackbar(
          ActionType.error, "Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу", 3);
    }
  }

  Future<void> onCompleted(String value) async {
    CustomDialogs().showLoadingDialog();
    if (arguments["code"] == value) {
      dynamic checkUserRole = await UserApi().checkUserRole(arguments["phone"]);
      Get.back();
      dynamic response = Map<String, dynamic>.from(checkUserRole);
      if (response["success"]) {
        var data = response["data"];
        log(data.toString());
        switch (data["role"]) {
          case "user":
            handleUserLogin(data);
            break;
          case "store":
            handleStoreLogin(data);
            break;
          case "driver":
            handleDriverLogin(data);
            break;
          default:
            handleUserLogin(data);
            break;
        }
      }
    } else {
      Get.back();
      customSnackbar(ActionType.error, "Баталгаажуулах код буруу байна", 3);
    }
  }

  @override
  void dispose() {
    super.dispose();
    countdownTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));
    return CustomHeader(
      customActions: Container(),
      title: "Баталгаажуулах",
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: MyColors.fadedGrey, shape: BoxShape.circle),
              child: Image(
                image: const AssetImage("assets/images/png/password.png"),
                width: Get.width * .1,
              ),
            ),
            SizedBox(height: Get.height * .03),
            CustomText(
              text:
                  "${arguments["phone"]} дугаарлуу илгээсэн нэвтрэх кодыг оруулна уу",
              color: MyColors.gray,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Get.height * .03),
            PinCodeTextField(
              autoFocus: true,
              appContext: context,
              cursorColor: MyColors.primary,
              controller: controller,
              cursorWidth: 1,
              length: 6,
              animationType: AnimationType.fade,
              keyboardType: TextInputType.number,
              textStyle: const TextStyle(fontSize: 16),
              pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 48,
                  fieldWidth: (Get.width - 90) / 6,
                  activeFillColor: Colors.white,
                  inactiveFillColor: MyColors.white,
                  selectedFillColor: MyColors.white,
                  borderWidth: 1,
                  activeColor: MyColors.grey,
                  inactiveColor: MyColors.grey,
                  selectedColor: MyColors.primary),
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              onCompleted: onCompleted,
              onChanged: (value) {},
              enablePinAutofill: false,
              useExternalAutoFillGroup: true,
            ),
            SizedBox(height: Get.height * .03),
            myDuration.inSeconds.isLowerThan(1)
                ? TextButton(
                    onPressed: sendOTP,
                    child: const CustomText(
                      text: "Дахин код авах",
                      fontSize: 14,
                      color: MyColors.black,
                    ),
                  )
                : CustomText(
                    text:
                        '$minutes:$seconds секундын дараа дахин код авах боломжтой',
                    fontSize: 14,
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }
}

void saveUserInfo(int id, String role) {
  RestApiHelper.saveUserId(id);
  RestApiHelper.saveUserRole(role);
}

void handleUserLogin(data) {
  final loginCtx = Get.put(LoginController());
  var userId = data["userId"];
  saveUserInfo(userId, "user");
  loginCtx.navigateToScreen(userHomeScreenRoute);
}

void handleStoreLogin(data) {
  Get.bottomSheet(
      backgroundColor: MyColors.white,
      isDismissible: false,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      )), StatefulBuilder(
    builder: ((context, setState) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _content(
              data["storeId"],
              "store",
              NetworkImage(data["image"]),
              data["storeName"],
              storeMainScreenRoute,
            ),
            const Divider(),
            _content(
              data["userId"],
              "user",
              const AssetImage("assets/images/png/user.png"),
              "Хэрэглэгч",
              userHomeScreenRoute,
            ),
          ],
        ),
      );
    }),
  ));
}

void handleDriverLogin(data) {
  Get.bottomSheet(
    StatefulBuilder(
      builder: ((context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _content(
                data["driverId"],
                "driver",
                const AssetImage("assets/images/png/car.png"),
                "Жолооч",
                driverMainScreenRoute,
              ),
              const Divider(),
              _content(
                data["userId"],
                "user",
                const AssetImage("assets/images/png/user.png"),
                "Хэрэглэгч",
                userHomeScreenRoute,
              ),
            ],
          ),
        );
      }),
    ),
    backgroundColor: MyColors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
  );
}

Widget _content(
  int id,
  String role,
  ImageProvider image,
  String title,
  String route,
) {
  final loginCtx = Get.put(LoginController());
  return GestureDetector(
    onTap: () {
      saveUserInfo(id, role);
      loginCtx.navigateToScreen(route);
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SizedBox(
          width: Get.width * .1,
          height: Get.width * .1,
          child: CircleAvatar(
            backgroundImage: image,
          ),
        ),
        title: Text(title),
        trailing: const Icon(
          IconlyLight.arrow_right_2,
          color: Colors.black,
          size: 20,
        ),
      ),
    ),
  );
}
