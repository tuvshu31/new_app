import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Widget customEmptyWidget(String text) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(
          'assets/json/no_data.json',
          height: Get.width * .35,
          width: Get.width * .35,
        ),
        CustomText(
          text: text,
          color: MyColors.gray,
        )
      ],
    ),
  );
}
