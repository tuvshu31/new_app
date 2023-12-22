import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomBottomSheet(BuildContext context, double height, Widget body) {
  Get.bottomSheet(
    StatefulBuilder(builder: (context, setState) {
      return FractionallySizedBox(
        heightFactor: height,
        child: body,
      );
    }),
    backgroundColor: MyColors.white,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
  );
}
