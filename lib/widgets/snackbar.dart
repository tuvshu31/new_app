import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:audioplayers/audioplayers.dart';

final player = AudioCache();
String message = "Hello";
late AnimationController localAnimationController;

void successSnackBar(String text, int duration, dynamic context) {
  showToast(text,
      context: context,
      backgroundColor: MyColors.fadedGreen,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      textStyle: const TextStyle(color: MyColors.green),
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: const StyledToastPosition(align: Alignment.topCenter),
      duration: Duration(seconds: duration),
      animDuration: const Duration(seconds: 1),
      curve: Curves.fastLinearToSlowEaseIn,
      reverseCurve: Curves.fastOutSlowIn);
}

void errorSnackBar(String text, int duration, dynamic context) {
  showToast(text,
      context: context,
      backgroundColor: MyColors.fadedRed,
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
