import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/swipe_button.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:circular_countdown/circular_countdown.dart';

List numbers = List<int>.generate(60, (i) => i + 1);
void showOrdersNotificationView(context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 1,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Get.height * .2),
              const CustomText(text: "Шинэ захиалга ирлээ"),
              SizedBox(height: Get.height * .2),
              SizedBox(
                width: Get.width * .4,
                child: TimeCircularCountdown(
                  countdownRemainingColor: MyColors.primary,
                  unit: CountdownUnit.second,
                  textStyle: const TextStyle(
                    color: MyColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  countdownTotal: 60,
                  onUpdated: (unit, remainingTime) {},
                  onFinished: () {},
                ),
              ),
              const Spacer(),
              swipeButton("Баталгаажуулах", () {
                Get.back();
              }),
              SizedBox(height: Get.height * .05)
            ],
          ),
        ),
      );
    },
  );
}
