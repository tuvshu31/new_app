import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Erdenet24/widgets/text.dart';

final player = AudioCache();
String message = "Hello";
late AnimationController localAnimationController;
void successSnackBar(String text, int duration, dynamic context) {
  Flushbar(
    margin: const EdgeInsets.all(24),
    shouldIconPulse: true,
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: const Duration(milliseconds: 500),
    backgroundColor: MyColors.fadedGreen,
    borderRadius: BorderRadius.circular(8),
    mainButton: IconButton(
        onPressed: () {
          Flushbar().dismiss();
        },
        icon: const Icon(
          Icons.close,
          color: MyColors.success,
          size: 12,
        )),
    messageText: CustomText(text: text, color: MyColors.success),
    icon: const Icon(
      Icons.check_circle,
      size: 28.0,
      color: MyColors.success,
    ),
    duration: Duration(seconds: duration),
    isDismissible: true,
  ).show(context);
}

void errorSnackBar(String text, int duration, dynamic context) {
  Flushbar(
    margin: EdgeInsets.all(24),
    shouldIconPulse: true,
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: const Duration(milliseconds: 500),
    backgroundColor: Color(0xfffddde3),
    borderRadius: BorderRadius.circular(8),
    mainButton: IconButton(
        onPressed: () {
          Flushbar().dismiss();
        },
        icon: const Icon(
          Icons.close,
          color: MyColors.primary,
          size: 12,
        )),
    messageText: CustomText(text: text, color: MyColors.primary),
    icon: const Icon(
      Icons.check_circle,
      size: 28.0,
      color: MyColors.primary,
    ),
    duration: Duration(seconds: duration),
    isDismissible: true,
  ).show(context);
}

void warningSnackBar(String text, int duration, dynamic context) {
  Flushbar(
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.all(12),
    shouldIconPulse: false,
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: const Duration(milliseconds: 500),
    backgroundColor: Colors.orange.shade500,
    borderRadius: BorderRadius.circular(8),
    mainButton: IconButton(
        onPressed: () {
          Flushbar().dismiss();
        },
        icon: Icon(Icons.close, color: MyColors.white)),
    messageText: CustomText(text: text, color: MyColors.white),
    icon: const Icon(
      IconlyBold.danger,
      size: 28.0,
      color: MyColors.white,
    ),
    duration: Duration(seconds: duration),
  ).show(context);
}

void saleSnackBar(String text, int durationTime, dynamic context) {
  // player.play("sounds/sale.wav");
  Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: Duration(milliseconds: 500),
    backgroundColor: MyColors.success,
    messageText: CustomText(
      text: text,
      color: MyColors.white,
      fontWeight: FontWeight.bold,
    ),
    icon: const Icon(
      Icons.check_circle,
      size: 28.0,
      color: MyColors.white,
    ),
    duration: Duration(seconds: 2),
    leftBarIndicatorColor: MyColors.green,
  ).show(context);
}
