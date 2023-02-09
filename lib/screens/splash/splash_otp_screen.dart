import 'dart:async';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/screens/driver/driver_main_screen.dart';
import 'package:Erdenet24/screens/store/store.dart';
import 'package:Erdenet24/screens/user/home/home.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SplashOtpScreen extends StatefulWidget {
  const SplashOtpScreen({super.key});

  @override
  State<SplashOtpScreen> createState() => _SplashOtpScreenState();
}

class _SplashOtpScreenState extends State<SplashOtpScreen> {
  var pinCode = "";
  dynamic user = [];
  String loginType = "";
  Timer? countdownTimer;
  Duration myDuration = const Duration(minutes: 1);
  final _loginCtrl = Get.put(LoginController());
  final _driverCtx = Get.put(DriverController());
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      const reduceSecondsBy = 1;
      setState(() {
        final seconds = myDuration.inSeconds - reduceSecondsBy;
        if (seconds < 0) {
          countdownTimer!.cancel();
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    });
  }

  void resetTimer() async {
    loadingDialog(context);
    _loginCtrl.verifyCode.value = random6digit();
    dynamic authCode = await RestApi().sendAuthCode(
        _loginCtrl.phoneController.text,
        _loginCtrl.verifyCode.value.toString());
    Get.back();
    if (authCode[0]["Result"] == "SUCCESS") {
      setState(() {
        countdownTimer!.cancel();
        myDuration = const Duration(minutes: 1);
        startTimer();
      });
    } else {
      errorSnackBar(
          "Серверийн алдаа гарлаа түр хүлээгээд дахин оролдоно уу", 2, context);
    }
  }

  void putUserIntoBox(int id, String type) {
    RestApiHelper.saveUserId(id);
    RestApiHelper.saveUserRole(type);
  }

  void submit() async {
    loadingDialog(context);
    dynamic response =
        await RestApi().checkUser(_loginCtrl.phoneController.text);
    dynamic data = Map<String, dynamic>.from(response);
    log(data.toString());
    if (data["success"] &&
        data["role"] != "test" &&
        _loginCtrl.verifyCode.value == int.parse(pinCode)) {
      Get.back();
      if (data.length > 1) {
        switch (data["role"]) {
          case "admin":
            putUserIntoBox(data["adminId"], "admin");
            break;
          case "manager":
            putUserIntoBox(data["managerId"], "manager");
            break;
          case "store":
            loginTypeBottomSheet(data["userId"], data["storeId"]);
            break;
          case "user":
            putUserIntoBox(data["userId"], "user");
            Get.offAll(const MainScreen());
            break;
          case "driver":
            putUserIntoBox(data["driverId"], "driver");
            _driverCtx.fetchDriverInfo(data["driverId"]);
            Get.offAll(const DriverMainScreen());
            break;
        }
      } else {
        var body = {
          "phone": _loginCtrl.phoneController.text,
          "role": "user",
        };
        dynamic response = await RestApi().registerUser(body);
        dynamic data = Map<String, dynamic>.from(response);
        putUserIntoBox(data["data"]["id"], "user");
        Get.offAll(const MainScreen());
      }
    } else if (data["success"] &&
        data["role"] == "test" &&
        int.parse(pinCode) == 111111) {
      Get.back();
      putUserIntoBox(data["testId"], "test");
      Get.offAll(const MainScreen());
    } else {
      Get.back();
      errorSnackBar("Баталгаажуулах код буруу байна", 2, context);
    }
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
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: MyColors.fadedGrey, shape: BoxShape.circle),
              child: Image(
                image: const AssetImage("assets/images/png/app/password.png"),
                width: Get.width * .1,
              ),
            ),
            SizedBox(height: Get.height * .03),
            CustomText(
              text:
                  "${_loginCtrl.phoneController.text} дугаарлуу илгээсэн нэвтрэх кодыг оруулна уу",
              color: MyColors.gray,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Get.height * .03),
            CustomPinCodeTextField(
              onCompleted: (value) {
                submit();
              },
              onChanged: (value) {
                setState(() {
                  pinCode = value;
                });
              },
            ),
            SizedBox(height: Get.height * .03),
            myDuration.inSeconds.isLowerThan(1)
                ? TextButton(
                    onPressed: resetTimer,
                    child: const CustomText(
                      text: "Дахин код авах",
                      fontSize: 14,
                      color: MyColors.black,
                    ),
                  )
                : CustomText(
                    text: '$minutes:$seconds',
                    fontSize: 20,
                  ),
          ],
        ),
      ),
    );
  }

  void loginTypeBottomSheet(int userId, int storeId) {
    setState(() {
      countdownTimer!.cancel();
      loginType = "";
    });
    Get.bottomSheet(isDismissible: false, StatefulBuilder(
      builder: ((context, setState) {
        return Container(
          height: Get.height * .3,
          decoration: const BoxDecoration(
            color: MyColors.white,
          ),
          padding: EdgeInsets.symmetric(
              vertical: Get.width * .06, horizontal: Get.width * .03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Нэвтрэх эрхээ сонгоно уу",
                fontSize: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RadioListTile(
                        activeColor: MyColors.primary,
                        dense: true,
                        value: "user",
                        groupValue: loginType,
                        title: CustomText(
                          text: "Хэрэглэгч",
                          fontSize: 14,
                        ),
                        onChanged: ((value) {
                          setState(() {
                            loginType = value!;
                          });
                        })),
                  ),
                  Expanded(
                    child: RadioListTile(
                        dense: true,
                        activeColor: MyColors.primary,
                        value: "store",
                        title: CustomText(
                          text: "Байгууллага",
                          fontSize: 14,
                        ),
                        groupValue: loginType,
                        onChanged: ((value) {
                          setState(() {
                            loginType = value!;
                          });
                        })),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width * .2),
                child: CustomButton(
                  isActive: loginType.isNotEmpty,
                  onPressed: (() {
                    if (loginType == "user") {
                      putUserIntoBox(userId, "user");
                      Get.offAll(() => const MainScreen());
                    } else if (loginType == "store") {
                      putUserIntoBox(storeId, "store");
                      Get.offAll(() => const StorePage());
                    }
                  }),
                  text: "Нэвтрэх",
                ),
              )
            ],
          ),
        );
      }),
    ));
  }
}
