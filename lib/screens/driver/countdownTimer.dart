import 'package:Erdenet24/utils/styles.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget countDownTimer(controller) {
  return Align(
    alignment: Alignment.topCenter,
    child: Container(
      margin: EdgeInsets.only(top: Get.height * .1),
      child: CircularCountDownTimer(
        duration: 60,
        initialDuration: 0,
        controller: controller,
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
        onComplete: () {
          debugPrint('Countdown Ended');
        },
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
    ),
  );
}
