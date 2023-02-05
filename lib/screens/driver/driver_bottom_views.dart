import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/separator.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:circular_countdown_timer/countdown_text_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:iconly/iconly.dart';

final _driverCtx = Get.put(DriverController());
final player = AudioPlayer();

void playSound(type) async {
  player.play(AssetSource("sounds/$type.wav"));
}

void stopSound() async {
  player.stop();
}

Widget step1() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    text: convertToCurrencyFormat(
                      3000,
                      toInt: true,
                      locatedAtTheEnd: true,
                    ),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  SizedBox(height: 4),
                  CustomText(
                    text: "2.5 km, 4 минут",
                    color: MyColors.gray,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                _driverCtx.step.value = 0;
                stopSound();
              },
              child: Icon(
                Icons.close,
                size: 28,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                "https://et24-images.s3.ap-northeast-1.amazonaws.com/users/26/small/1.png"),
          ),
          title: const CustomText(
            text: "Modern Nomads restaurant",
            fontSize: 14,
          ),
          subtitle: const CustomText(
            text: "5-р микр 8-р байр",
            fontSize: 12,
          ),
        ),
      ),
      const MySeparator(color: MyColors.grey),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: MyColors.white,
            radius: 30,
            child: Image(
              width: 32,
              image: AssetImage(
                "assets/images/png/app/home.png",
              ),
            ),
          ),
          title: CustomText(
            text: "6-20-31 тоот",
            fontSize: 14,
          ),
          subtitle: CustomText(
            text: "99921312",
            fontSize: 12,
          ),
        ),
      ),
    ],
  );
}

Widget step2() {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
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
          trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
                image: AssetImage("assets/images/png/app/phone-call.png")),
          ),
        ),
      ),
      SizedBox(height: 12)
    ],
  );
}

Widget step3() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const CustomText(
        text: "Баталгаажуулах код:",
        color: MyColors.gray,
      ),
      const SizedBox(height: 12),
      const CustomText(
        text: "3728",
        fontSize: 28,
      ),
      const SizedBox(height: 12),
      const CustomText(
        text: "15:00",
        color: MyColors.success,
      ),
      const SizedBox(height: 24),
    ],
  );
}

Widget step4() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: MyColors.white,
            radius: 20,
            child: Image(
              width: 32,
              image: AssetImage(
                "assets/images/png/app/home.png",
              ),
            ),
          ),
          title: CustomText(
            text: "4-р микр 24-р байр 31 тоот",
          ),
          trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
                image: AssetImage("assets/images/png/app/phone-call.png")),
          ),
        ),
      ),
      const SizedBox(height: 12),
    ],
  );
}

Widget step5() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image(
        image: AssetImage("assets/images/png/app/yes.png"),
        width: Get.width * .3,
      ),
      const SizedBox(height: 24),
      const CustomText(text: "Хүргэлт амжилттай"),
      const SizedBox(height: 8),
      CustomText(
        fontSize: 28,
        text: convertToCurrencyFormat(
          double.parse("3000"),
          toInt: true,
          locatedAtTheEnd: true,
        ),
      ),
      const SizedBox(height: 8),
      const CustomText(
        text: "Орлого нэмэгдлээ",
        fontSize: 12,
      ),
      const SizedBox(height: 12),
    ],
  );
}
