import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:another_flushbar/flushbar.dart';

_getDialogColors(ActionType actionType) {
  switch (actionType) {
    case ActionType.error:
      return Colors.red;
    case ActionType.warning:
      return Colors.amber;
    case ActionType.success:
      return Colors.green;
  }
}

void customSnackbar(ActionType ActionType, String text, int duration) {
  Flushbar(
      // title: _getDialogTitle(ActionType),
      message: text,
      duration: Duration(seconds: duration),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: _getDialogColors(ActionType),
      forwardAnimationCurve: Curves.bounceIn,
      shouldIconPulse: false,
      icon: const Icon(
        Icons.check_circle_rounded,
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      mainButton: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: 18,
        ),
      )).show(Get.context!);
}
