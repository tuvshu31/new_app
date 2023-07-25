import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/slide_button.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:slide_to_act/slide_to_act.dart';

final _driverCtx = Get.put(DriverController());

Widget withoutOrderView() {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomText(
          text: "Сүүлийн хүргэлт:",
          fontSize: 14,
          color: MyColors.gray,
        ),
        const SizedBox(height: 24),
        Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            color: MyColors.black,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColors.primary,
                      ),
                      child: Icon(
                        IconlyLight.wallet,
                        color: MyColors.white,
                      ),
                    ),
                    CustomText(
                      color: MyColors.white,
                      text: convertToCurrencyFormat(
                        int.parse("3000"),
                        locatedAtTheEnd: true,
                        toInt: true,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: MyColors.primary,
                      ),
                      child: Icon(
                        IconlyLight.time_circle,
                        color: MyColors.white,
                      ),
                    ),
                    CustomText(
                      fontSize: 10,
                      color: MyColors.white,
                      text: formatedTime(timeInSecond: int.parse("23")),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget incomingNewOrderView() {
  return Container(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomInkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                _driverCtx.cancelOrder();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: MyColors.fadedGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("Цуцлах"),
              ),
            )
          ],
        ),
        SizedBox(height: Get.height * .03),
        Stack(
          children: [
            CustomImage(
              width: Get.width * .25,
              height: Get.width * .25,
              url:
                  "${URL.AWS}/users/${_driverCtx.newOrderInfo["storeId1"]}/small/1.png",
              radius: 100,
            ),
            CircularCountDownTimer(
              isReverseAnimation: true,
              isReverse: true,
              strokeWidth: 8,
              width: Get.width * .25,
              height: Get.width * .25,
              duration: 30,
              isTimerTextShown: false,
              fillColor: MyColors.primary,
              ringColor: Colors.white,
              strokeCap: StrokeCap.round,
              onComplete: () {},
            ),
          ],
        ),
        SizedBox(height: Get.height * .03),
        Text(
          _driverCtx.newOrderInfo["storeName"] ?? "No data",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          _driverCtx.newOrderInfo["storeAddress"] ?? "No data",
          style: TextStyle(
            fontSize: 12,
            color: MyColors.gray,
          ),
        ),
        SizedBox(height: Get.height * .03),
        Text(
          convertToCurrencyFormat(
            _driverCtx.newOrderInfo["deliveryPrice"] ?? 3000,
            locatedAtTheEnd: true,
            toInt: true,
          ),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: Get.height * .03),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on_rounded,
              size: 16,
              color: MyColors.primary,
            ),
            const SizedBox(width: 12),
            Text(_driverCtx.newOrderInfo["address"] ?? "No data"),
          ],
        ),
        SizedBox(height: Get.height * .05),
        CustomSlideButton(
          text: "Зөвшөөрөх",
          onSubmit: () {},
        )
      ],
    ),
  );
}

Widget arrivedAtStoreView() {
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
              text: _driverCtx.newOrderInfo["storeName"],
              fontSize: 16,
            ),
            subtitle: CustomText(
              text: _driverCtx.newOrderInfo["storeAddress"],
              fontSize: 12,
            ),
            trailing: GestureDetector(
              onTap: () {
                makePhoneCall("+976-${_driverCtx.newOrderInfo["storePhone"]}");
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

Widget receivedTheOrderView() {
  return Obx(
    () => Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CustomText(
          text: "Баталгаажуулах код:",
          color: MyColors.gray,
        ),
        const SizedBox(height: 12),
        CustomText(
          text: _driverCtx.newOrderInfo["orderId"],
          fontSize: 28,
        ),
        const SizedBox(height: 12),
        SlideCountdownSeparated(
          duration: const Duration(minutes: 15),
          onDone: () {},
        ),
        const SizedBox(height: 24),
      ],
    ),
  );
}

Widget deliveredTheOrderView() {
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
              text: _driverCtx.newOrderInfo["userAddress"],
              fontSize: 16,
            ),
            // subtitle: CustomText(
            //     text:
            //         "Захиалгын код: ${}"),
            trailing: GestureDetector(
              onTap: () {
                makePhoneCall("+976-${_driverCtx.newOrderInfo["userPhone"]}");
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

Widget finishedTheOrderView() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image(
        image: const AssetImage("assets/images/png/app/yes.png"),
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
