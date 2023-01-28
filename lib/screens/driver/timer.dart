import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/separator.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';

Widget countDownTimer(controller) {
  return Align(
    alignment: Alignment.topCenter,
    child: Container(
      margin: EdgeInsets.only(top: Get.height * .1),
      child: CircularCountDownTimer(
        duration: 60,
        initialDuration: 0,
        controller: controller,
        width: Get.width / 4,
        height: Get.width / 4,
        ringColor: MyColors.black,
        ringGradient: null,
        fillColor: MyColors.primary,
        fillGradient: null,
        backgroundColor: MyColors.white,
        backgroundGradient: null,
        strokeWidth: 20.0,
        strokeCap: StrokeCap.round,
        textStyle: TextStyle(
            fontSize: 24.0,
            color: MyColors.primary,
            fontWeight: FontWeight.bold),
        textFormat: CountdownTextFormat.MM_SS,
        isReverse: true,
        isReverseAnimation: false,
        isTimerTextShown: true,
        autoStart: false,
        onStart: () {
          print("Starting");
        },
        onComplete: () {
          debugPrint('Countdown Ended');
        },
        onChange: (String timeStamp) {
          debugPrint('Countdown Changed $timeStamp');
        },
        timeFormatterFunction: (defaultFormatterFunction, duration) {
          if (duration.inSeconds == 0) {
            return "Start";
          } else {
            return Function.apply(defaultFormatterFunction, [duration]);
          }
        },
      ),
    ),
  );
}

void showOrderDetailsBottomSheet() {
  Get.bottomSheet(
    barrierColor: Colors.white.withOpacity(0.1),
    isDismissible: false,
    SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          color: MyColors.white,
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * .06, vertical: Get.width * .06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundImage: const NetworkImage(
                      scale: 2,
                      "https://et24-images.s3.ap-northeast-1.amazonaws.com/users/26/small/1.png"),
                ),
                title: CustomText(
                  text: "Modern Nomads restaurant",
                  fontSize: 14,
                ),
                subtitle: CustomText(
                  text: "Утас: +976-99921312",
                  fontSize: 12,
                ),
                trailing: CustomText(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  text: convertToCurrencyFormat(double.parse("3000"),
                      toInt: true, locatedAtTheEnd: true),
                ),
              ),

              const SizedBox(height: 24),
              MySeparator(
                color: MyColors.gray,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  SizedBox(
                    width: Get.width * .1,
                    child: Column(
                      children: [
                        Icon(Icons.circle),
                        Container(
                          height: Get.height * .06,
                          width: 2,
                          color: MyColors.grey,
                        ),
                        Icon(Icons.circle),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Get.width * .75,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: CustomText(
                            text: "Modern Nomads restaurant",
                            fontSize: 14,
                          ),
                          subtitle: CustomText(
                            text: "5-р микр 8-р байр",
                            fontSize: 12,
                          ),
                        ),
                        ListTile(
                          title: CustomText(
                            text: "6-р микр 20-р байр, 31 тоот",
                            fontSize: 14,
                          ),
                          subtitle: CustomText(
                            text: "5-р микр 8-р байр",
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              SwipingButton(
                text: "Зөвшөөрөх",
                buttonTextStyle: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.normal,
                  color: MyColors.white,
                  fontSize: 14,
                ),
                swipeButtonColor: MyColors.primary,
                height: 50,
                onSwipeCallback: () {
                  print("Called back");
                },
              ),
              SizedBox(height: 24),
              CustomButton(
                elevation: 0,
                isFullWidth: false,
                bgColor: MyColors.white,
                text: "Татгалзах",
                textFontWeight: FontWeight.bold,
                textColor: MyColors.black,
                onPressed: Get.back,
                prefix: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    FontAwesomeIcons.close,
                    size: 18,
                  ),
                ),
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: CustomButton(
              //         bgColor: MyColors.white,
              //         textColor: MyColors.gray,
              //         elevation: 0,
              //         isActive: true,
              //         onPressed: () {
              //           Get.back();
              //         },
              //         text: "Татгалзах",
              //       ),
              //     ),
              //     SizedBox(width: 12),
              //     Expanded(
              //       child: CustomButton(
              //         isActive: true,
              //         onPressed: (() {
              //           // _goToTheLake();
              //         }),
              //         text: "Зөвшөөрөх",
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
    ignoreSafeArea: false,
  );
}
