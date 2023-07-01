import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:another_flushbar/flushbar.dart';

_getDialogColors(DialogType dialogType) {
  switch (dialogType) {
    case DialogType.error:
      return Colors.red;
    case DialogType.warning:
      return Colors.amber;
    case DialogType.success:
      return Colors.green;
  }
}

_getDialogTitle(DialogType dialogType) {
  switch (dialogType) {
    case DialogType.error:
      return "Уучлаарай";
    case DialogType.warning:
      return "Анхааруулга";
    case DialogType.success:
      return "Амжилттай";
  }
}

void customSnackbar(DialogType dialogType, String text, int duration) {
  Flushbar(
      title: _getDialogTitle(dialogType),
      message: text,
      duration: Duration(seconds: duration),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: _getDialogColors(dialogType),
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
