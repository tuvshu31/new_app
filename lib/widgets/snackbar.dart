import 'package:Erdenet24/widgets/button.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
// import 'package:audioplayers/audioplayers.dart';

// final player = AudioCache();
String message = "Hello";
late AnimationController localAnimationController;

void successSnackBar(String text, int duration, dynamic context) {
  Flushbar(
      title: "Амжилттай",
      message: "Амжилттай хадгалагдлаа",
      duration: Duration(seconds: duration),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.green,
      forwardAnimationCurve: Curves.bounceIn,
      shouldIconPulse: false,
      icon: Icon(
        Icons.check_circle_rounded,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      mainButton: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: 18,
        ),
      ))
    ..show(context);
  // showToast(
  //   text,
  //   context: context,
  //   backgroundColor: MyColors.black.withOpacity(0.5),
  //   shapeBorder: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(25),
  //   ),
  //   textStyle: const TextStyle(color: MyColors.white),
  //   animation: StyledToastAnimation.scale,
  //   reverseAnimation: StyledToastAnimation.fade,
  //   position:
  //       const StyledToastPosition(align: Alignment.bottomCenter, offset: 100),
  //   duration: Duration(seconds: duration),
  //   animDuration: const Duration(seconds: 1),
  //   curve: Curves.fastLinearToSlowEaseIn,
  //   reverseCurve: Curves.fastOutSlowIn,
  // );
}

void errorSnackBar(String text, int duration, dynamic context) {
  showToast(text,
      context: context,
      backgroundColor: MyColors.primary,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      textStyle: const TextStyle(color: MyColors.white),
      animation: StyledToastAnimation.slideFromTopFade,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
      position: const StyledToastPosition(align: Alignment.topCenter),
      duration: Duration(seconds: duration),
      animDuration: const Duration(seconds: 1),
      curve: Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.fastOutSlowIn);
}

void warningSnackBar(String text, int duration, dynamic context) {
  showToast(text,
      context: context,
      backgroundColor: MyColors.pinkyRed,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      textStyle: TextStyle(color: MyColors.primary),
      animation: StyledToastAnimation.slideFromTopFade,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
      position: StyledToastPosition(align: Alignment.topCenter),
      duration: Duration(seconds: duration),
      animDuration: Duration(seconds: 1),
      curve: Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.fastOutSlowIn);
}

void saleSnackBar(String text, int durationTime, dynamic context) {
  // player.play("sounds/sale.wav");
}
