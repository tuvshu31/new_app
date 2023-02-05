import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Erdenet24/widgets/separator.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:slide_countdown/slide_countdown.dart';

final _driverCtx = Get.put(DriverController());
final player = AudioPlayer();

void playSound(type) async {
  player.play(AssetSource("sounds/$type.wav"));
}

void stopSound() async {
  player.stop();
}

Widget step1() {
  return Obx(
    () => Column(
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
                    const SizedBox(height: 4),
                    CustomText(
                      text: _driverCtx.distanceAndDuration.value != ""
                          ? _driverCtx.distanceAndDuration.value
                          : "km",
                      color: MyColors.gray,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _driverCtx.cancelNewDelivery();
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  "https://et24-images.s3.ap-northeast-1.amazonaws.com/users/26/small/1.png"),
            ),
            title: CustomText(
              text: _driverCtx.deliveryInfo["storeName"],
              fontSize: 16,
            ),
            subtitle: CustomText(
              text: _driverCtx.deliveryInfo["storeAddress"],
              fontSize: 12,
            ),
          ),
        ),
        const MySeparator(color: MyColors.grey),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
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
              text: _driverCtx.deliveryInfo["userAddress"],
              fontSize: 16,
            ),
            subtitle: CustomText(
              text: _driverCtx.deliveryInfo["userPhone"],
              fontSize: 12,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget step2() {
  return Obx(
    () => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                  scale: 2,
                  "https://et24-images.s3.ap-northeast-1.amazonaws.com/users/26/small/1.png"),
            ),
            title: CustomText(
              text: _driverCtx.deliveryInfo["storeName"],
              fontSize: 16,
            ),
            subtitle: CustomText(
              text: _driverCtx.deliveryInfo["storeAddress"],
              fontSize: 12,
            ),
            trailing: GestureDetector(
              onTap: () {
                _driverCtx.makePhoneCall(
                    "+976-${_driverCtx.deliveryInfo["storePhone"]}");
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                    image: AssetImage("assets/images/png/app/phone-call.png")),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12)
      ],
    ),
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
      CustomText(
        text: random4digit().toString(),
        fontSize: 28,
      ),
      const SizedBox(height: 12),
      SlideCountdownSeparated(
        duration: const Duration(minutes: 15),
        onDone: () {},
      ),
      const SizedBox(height: 24),
    ],
  );
}

Widget step4() {
  return Obx(
    () => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
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
              text: _driverCtx.deliveryInfo["userAddress"],
              fontSize: 16,
            ),
            trailing: GestureDetector(
              onTap: () {
                _driverCtx.makePhoneCall(
                    "+976-${_driverCtx.deliveryInfo["userPhone"]}");
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Image(
                    image: AssetImage("assets/images/png/app/phone-call.png")),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    ),
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
      const CustomText(
        text: "Хүргэлт амжилттай",
        fontSize: 16,
      ),
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
        color: MyColors.gray,
      ),
      const SizedBox(height: 12),
    ],
  );
}
