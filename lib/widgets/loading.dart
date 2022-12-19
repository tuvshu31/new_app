import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import "package:flutter/material.dart";
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final String text;
  const CustomLoadingIndicator({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
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
}
