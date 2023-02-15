import 'dart:convert';

import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/screens/driver/driver_bottom_views.dart';
import 'package:Erdenet24/screens/store/orders/store_orders_set_time_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/swipe_button.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:http/http.dart';
import 'package:slide_to_act/slide_to_act.dart';

final _storeCtx = Get.put(StoreController());
void showOrdersNotificationView(context, data) {
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
              Builder(
                builder: (contexts) {
                  final GlobalKey<SlideActionState> key = GlobalKey();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SlideAction(
                      outerColor: MyColors.black,
                      innerColor: MyColors.primary,
                      elevation: 0,
                      key: key,
                      submittedIcon: const Icon(
                        FontAwesomeIcons.check,
                        color: MyColors.white,
                      ),
                      onSubmit: () {
                        Future.delayed(const Duration(milliseconds: 300), () {
                          key.currentState!.reset();
                          stopSound();
                          Get.back();
                          showOrdersSetTime(context, json.decode(data["data"]));
                        });
                      },
                      alignment: Alignment.centerRight,
                      sliderButtonIcon: const Icon(
                        Icons.double_arrow_rounded,
                        color: MyColors.white,
                      ),
                      child: Text(
                        "Баталгаажуулах",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: Get.height * .05)
            ],
          ),
        ),
      );
    },
  );
}
