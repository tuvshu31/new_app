import 'dart:async';
import 'dart:developer';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/screens/driver/driver_drawer_screen.dart';
import 'package:Erdenet24/screens/driver/driver_bottom_views.dart';
import 'package:Erdenet24/screens/driver/driver_screen_map_view.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:Erdenet24/utils/styles.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  final _driverCtx = Get.put(DriverController());
  final CountDownController _countDownController = CountDownController();
  @override
  void initState() {
    super.initState();
    // _driverCtx.determineUsersPosition();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Firebase.s foreground message irj bn ;)");
    });
  }

  void showPrivacy() async {
    // playSound("incoming");
    loadingDialog(context);
    _countDownController.start();
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
            body: _body(),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Obx(
      () => Stack(children: [
        const DriverScreenMapView(),
        countDownTimer(),
        PageView(
          allowImplicitScrolling: false,
          physics: const NeverScrollableScrollPhysics(),
          controller: _driverCtx.pageController.value,
          onPageChanged: (value) {
            _driverCtx.changePage(value);
          },
          children: [
            Align(
                alignment: Alignment.bottomCenter, child: testButton(context)),
            arrivedAtRestaurant(),
            receivedFromRestaurant(),
            arrivedAtReceiver(),
            deliverySucceeded(),
            Align(
                alignment: Alignment.bottomCenter, child: testButton(context)),
          ],
        ),
      ]),
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
          text: _driverCtx.isDriverActive.value ? "Online" : "Offline",
          color: MyColors.black,
          fontSize: 16,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: CupertinoSwitch(
              value: _driverCtx.isDriverActive.value,
              thumbColor: _driverCtx.isDriverActive.value
                  ? MyColors.primary
                  : MyColors.gray,
              trackColor: MyColors.background,
              activeColor: MyColors.black,
              onChanged: (value) => _driverCtx.turnedOnApp(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget activeTimerCountDown() {
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final hours = strDigits(_driverCtx.myDuration.inHours.remainder(60));
    final minutes = strDigits(_driverCtx.myDuration.inMinutes.remainder(60));
    final seconds = strDigits(_driverCtx.myDuration.inSeconds.remainder(60));
    return _driverCtx.isDriverActive.value
        ? Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: const BoxDecoration(color: MyColors.white),
              child: CustomText(
                text: "$hours:$minutes:$seconds",
                color: MyColors.primary,
                fontSize: 12,
              ),
            ),
          )
        : Container();
  }

  Widget countDownTimer() {
    return Obx(
      () => Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.only(top: Get.height * .05),
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
              textStyle: TextStyle(
                  fontSize: 24.0,
                  color: MyColors.primary,
                  fontWeight: FontWeight.bold),
              textFormat: CountdownTextFormat.MM_SS,
              isReverse: true,
              isReverseAnimation: false,
              isTimerTextShown: true,
              autoStart: false,
              onStart: () {
                print("Starting");
              },
              onComplete: () {},
              onChange: (String timeStamp) {
                debugPrint('Countdown Changed $timeStamp');
              },
              timeFormatterFunction: (defaultFormatterFunction, duration) {
                if (duration.inSeconds == 0) {
                  return "Start";
                } else {
                  return Function.apply(defaultFormatterFunction, [duration]);
                }
              },
            ),
          )),
    );
  }
}
