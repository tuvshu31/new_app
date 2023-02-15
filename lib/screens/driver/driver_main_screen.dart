import 'dart:async';
import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:iconly/iconly.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/screens/driver/driver_bottom_views.dart';
import 'package:Erdenet24/screens/driver/driver_drawer_screen.dart';
import 'package:Erdenet24/screens/driver/driver_screen_map_view.dart';

import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  final _driverCtx = Get.put(DriverController());
  final GlobalKey<SlideActionState> key = GlobalKey();
  late CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch + 20000 * 540;

  List<Widget> steps = [
    step0(),
    step1(),
    step2(),
    step3(),
    step4(),
    step5(),
  ];
  List<String> texts = [
    "",
    "Зөвшөөрөх",
    "Ирлээ",
    "Хүлээн авсан",
    "Хүлээлгэн өгсөн",
    "Дуусгах"
  ];
  @override
  void initState() {
    super.initState();
    getToken();
    _driverCtx.firebaseMessagingForegroundHandler();
    _driverCtx.fetchDriverInfo(RestApiHelper.getUserId());
    controller = CountdownTimerController(endTime: endTime, onEnd: onEnd);
    controller.start();
    // _driverCtx.firebaseMessagingForegroundHandler(RestApiHelper.getUserId());
  }

  void getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    var body = {"mapToken": fcmToken};
    await RestApi().updateUser(RestApiHelper.getUserId(), body);
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      var body = {"mapToken": newToken};
      await RestApi().updateUser(RestApiHelper.getUserId(), body);
    });
  }

  void onEnd() {
    log("onEnd");
  }

  @override
  void dispose() {
    onEnd();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: MyColors.white,
            drawer: driverDrawer(context),
            appBar: _appBar(),
            body: Stack(
              children: [
                const DriverScreenMapView(),
                _infoSnackbar(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    countDownTimer(),
                    bottomSheets(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(54.0),
      child: AppBar(
        iconTheme: const IconThemeData(color: MyColors.primary),
        backgroundColor: MyColors.white,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        title: CustomText(
          text: _driverCtx.isActive.value ? "Online" : "Offline",
          color: MyColors.black,
          fontSize: 16,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: CupertinoSwitch(
                value: _driverCtx.isActive.value,
                thumbColor: _driverCtx.isActive.value
                    ? MyColors.primary
                    : MyColors.gray,
                trackColor: MyColors.background,
                activeColor: MyColors.black,
                onChanged: (value) {
                  _driverCtx.turnOnOff(value);
                }),
          ),
        ],
      ),
    );
  }

  Widget countDownTimer() {
    return Obx(
      () => _driverCtx.step.value == 1
          ? Container(
              margin: EdgeInsets.only(bottom: Get.height * .03),
              child: TimeCircularCountdown(
                countdownRemainingColor: MyColors.primary,
                unit: CountdownUnit.second,
                textStyle: const TextStyle(
                  color: MyColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
                countdownTotal: 30,
                onUpdated: (unit, remainingTime) {},
                onFinished: () {
                  _driverCtx.cancelNewDelivery();
                },
              ),
            )
          : Container(),
    );
  }

  Widget bottomSheets() {
    return Obx(
      () => _driverCtx.isActive.value
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: MyColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  steps[_driverCtx.step.value],
                  _driverCtx.step.value != 0
                      ? Builder(
                          builder: (context) {
                            final GlobalKey<SlideActionState> key = GlobalKey();
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SlideAction(
                                outerColor: MyColors.black,
                                innerColor: MyColors.primary,
                                elevation: 0,
                                key: key,
                                submittedIcon: const Icon(
                                  FontAwesomeIcons.check,
                                  color: MyColors.white,
                                ),
                                onSubmit: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    key.currentState!.reset();
                                    if (_driverCtx.step.value == 5) {
                                      _driverCtx.finishDelivery();
                                    } else {
                                      stopSound();
                                      _driverCtx.step.value += 1;
                                    }
                                  });
                                },
                                alignment: Alignment.centerRight,
                                sliderButtonIcon: const Icon(
                                  Icons.double_arrow_rounded,
                                  color: MyColors.white,
                                ),
                                child: Text(
                                  texts[_driverCtx.step.value].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                ]),
              ),
            )
          : Container(),
    );
  }

  Widget _infoSnackbar() {
    return Obx(
      () => Container(
        height: Get.height * .075,
        width: double.infinity,
        color: MyColors.black,
        child: _driverCtx.isActive.value
            ? Row(
                children: [
                  Expanded(
                    child: ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            IconlyLight.wallet,
                            color: MyColors.white,
                          ),
                        ],
                      ),
                      title: const CustomText(
                        text: "Өнөөдрийн орлого:",
                        color: MyColors.white,
                        fontSize: 12,
                      ),
                      subtitle: CustomText(
                          color: MyColors.white,
                          text: convertToCurrencyFormat(
                            int.parse("0"),
                            locatedAtTheEnd: true,
                            toInt: true,
                          )),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            IconlyLight.time_circle,
                            color: MyColors.white,
                          ),
                        ],
                      ),
                      title: const CustomText(
                        text: "Идэвхтэй хугацаа:",
                        color: MyColors.white,
                        fontSize: 12,
                      ),
                      // subtitle: CustomText(
                      //   color: MyColors.white,
                      //   text: "02:15:00",
                      // ),
                      subtitle: CountdownTimer(
                        textStyle: const TextStyle(color: MyColors.white),
                        controller: controller,
                        onEnd: onEnd,
                        endTime: endTime,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.nightlight_outlined,
                            color: MyColors.white,
                          ),
                        ],
                      ),
                      title: const CustomText(
                        text: "Та идэвхгүй байна!",
                        color: MyColors.white,
                        fontSize: 12,
                      ),
                      subtitle: const CustomText(
                          color: MyColors.white,
                          text: "Идэвхтэй үед захиалга хүлээн авах боломжтой"),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
