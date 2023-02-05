import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/screens/driver/driver_bottom_views.dart';
import 'package:Erdenet24/screens/driver/driver_drawer_screen.dart';
import 'package:Erdenet24/screens/driver/driver_screen_map_view.dart';

import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  final _driverCtx = Get.put(DriverController());
  final GlobalKey<SlideActionState> key = GlobalKey();

  List<Widget> steps = [
    Container(),
    step1(),
    step2(),
    step3(),
    step4(),
    step5()
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
    // _driverCtx.determineUsersPosition();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // _driverCtx.storeLat.value = double.parse(message.data["latitude"]);
      // _driverCtx.storeLng.value = double.parse(message.data["longitude"]);
      // _driverCtx.deliveryRequestArrived();
      log("Firebase.s foreground message irj bn ;)");
    });
  }

  @override
  void dispose() {
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
            drawer: driverDrawer(),
            appBar: _appBar(),
            body: Stack(
              children: [
                const DriverScreenMapView(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: "Press me",
                      onPressed: (() {
                        _driverCtx.getNewDelivery();
                      }),
                    ),
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
                  _driverCtx.turnedOnApp(value);
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
              child: CircularCountDownTimer(
                duration: 30,
                initialDuration: 0,
                controller: _driverCtx.countDownController.value,
                width: Get.width / 4,
                height: Get.width / 4,
                ringColor: MyColors.black,
                ringGradient: null,
                fillColor: MyColors.primary,
                fillGradient: null,
                backgroundColor: MyColors.white,
                backgroundGradient: null,
                strokeWidth: 20.0,
                strokeCap: StrokeCap.round,
                textStyle: const TextStyle(
                    fontSize: 24.0,
                    color: MyColors.primary,
                    fontWeight: FontWeight.bold),
                textFormat: CountdownTextFormat.MM_SS,
                isReverse: true,
                isReverseAnimation: false,
                isTimerTextShown: true,
                autoStart: false,
                onStart: () {},
                onComplete: () {
                  stopSound();
                  _driverCtx.step.value = 0;
                },
                onChange: (String timeStamp) {},
                timeFormatterFunction: (defaultFormatterFunction, duration) {
                  if (duration.inSeconds == 0) {
                    return "Start";
                  } else {
                    return Function.apply(defaultFormatterFunction, [duration]);
                  }
                },
              ),
            )
          : Container(),
    );
  }

  Widget bottomSheets() {
    return Obx(
      () => _driverCtx.step.value != 0
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
                  Builder(
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
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              key.currentState!.reset();
                              if (_driverCtx.step.value == 5) {
                                _driverCtx.step.value = 0;
                              } else {
                                _driverCtx.step.value += 1;
                                stopSound();
                              }
                            });
                          },
                          alignment: Alignment.centerRight,
                          sliderButtonIcon: const Icon(
                            Icons.double_arrow_rounded,
                            color: MyColors.white,
                          ),
                          child: Text(
                            texts[_driverCtx.step.value],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ]),
              ),
            )
          : Container(),
    );
  }
}
