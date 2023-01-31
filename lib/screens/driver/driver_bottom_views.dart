import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/separator.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:iconly/iconly.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';

final _driverCtx = Get.put(DriverController());
final player = AudioPlayer();

void playSound(type) async {
  player.play(AssetSource("sounds/$type.wav"));
}

void stopSound() async {
  player.stop();
}

void incomingNewOrder() {
  playSound("incoming");
  _driverCtx.countDownController.value.start();
  Get.bottomSheet(
    barrierColor: Colors.white.withOpacity(0.1),
    isDismissible: false,
    Obx(
      () => SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            color: MyColors.white,
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * .06, vertical: Get.width * .06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                    fontWeight: FontWeight.bold,
                    text:
                        "${_driverCtx.distance.value} km, ${_driverCtx.duration.value}"),
                ListTile(
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
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CustomText(
                        text: "Төлбөр:",
                        fontSize: 10,
                        color: MyColors.gray,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        text: convertToCurrencyFormat(double.parse("3000"),
                            toInt: true, locatedAtTheEnd: true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const MySeparator(
                  color: MyColors.gray,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    SizedBox(
                      width: Get.width * .1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 18,
                            color: MyColors.primary,
                          ),
                          SizedBox(height: Get.height * .01),
                          Container(
                            height: Get.height * .05,
                            width: 1,
                            color: MyColors.grey,
                          ),
                          SizedBox(height: Get.height * .01),
                          Icon(
                            Icons.circle,
                            size: 18,
                          ),
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
                    _driverCtx.acceptDeliveryRequest();
                    _driverCtx.changePage(1);
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
                  onPressed: () {
                    _driverCtx.declineDeliveryRequest();
                  },
                  prefix: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      FontAwesomeIcons.close,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    isScrollControlled: true,
    ignoreSafeArea: false,
  );
}

Widget arrivedAtRestaurant() {
  return Align(
    alignment: Alignment.bottomCenter,
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
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                    image: AssetImage("assets/images/png/app/phone-call.png")),
              ),
            ),
            const SizedBox(height: 24),
            MySeparator(
              color: MyColors.gray,
            ),
            const SizedBox(height: 24),
            SwipingButton(
              text: "Ирлээ",
              buttonTextStyle: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.normal,
                color: MyColors.white,
                fontSize: 14,
              ),
              swipeButtonColor: MyColors.primary,
              height: 50,
              onSwipeCallback: () {
                _driverCtx.changePage(2);
              },
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}

Widget receivedFromRestaurant() {
  return Align(
    alignment: Alignment.bottomCenter,
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        color: MyColors.white,
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * .06, vertical: Get.width * .06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomText(
              text: "Баталгаажуулах код:",
              color: MyColors.gray,
              fontSize: 12,
            ),
            const SizedBox(height: 8),
            const CustomText(
              text: "3728",
              fontSize: 28,
            ),
            const SizedBox(height: 12),
            const CustomText(
              text: "15:00:00",
              color: MyColors.success,
            ),
            const SizedBox(height: 24),
            MySeparator(
              color: MyColors.gray,
            ),
            const SizedBox(height: 24),
            SwipingButton(
              text: "Хүлээн авсан",
              buttonTextStyle: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.normal,
                color: MyColors.white,
                fontSize: 14,
              ),
              swipeButtonColor: MyColors.primary,
              height: 50,
              onSwipeCallback: () {
                _driverCtx.changePage(3);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}

Widget arrivedAtReceiver() {
  return Align(
    alignment: Alignment.bottomCenter,
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
              leading: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: MyColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      IconlyLight.user,
                      size: 18,
                    ),
                  ),
                ],
              ),
              title: CustomText(
                text: "Хүлээн авагч:",
                fontSize: 14,
              ),
              subtitle: CustomText(
                text: "4-р микр 24-р байр 31 тоот",
                fontSize: 12,
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                    image: AssetImage("assets/images/png/app/phone-call.png")),
              ),
            ),
            const SizedBox(height: 24),
            MySeparator(
              color: MyColors.gray,
            ),
            const SizedBox(height: 24),
            SwipingButton(
              text: "Хүлээлгэн өгсөн",
              buttonTextStyle: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.normal,
                color: MyColors.white,
                fontSize: 14,
              ),
              swipeButtonColor: MyColors.primary,
              height: 50,
              onSwipeCallback: () {
                _driverCtx.changePage(4);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}

Widget deliverySucceeded() {
  return Align(
    alignment: Alignment.bottomCenter,
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        color: MyColors.white,
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * .06, vertical: Get.width * .06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(text: "Хүргэлт амжилттай"),
            SizedBox(height: 8),
            CustomText(
              fontSize: 28,
              text: convertToCurrencyFormat(
                double.parse("3000"),
                toInt: true,
                locatedAtTheEnd: true,
              ),
            ),
            SizedBox(height: 8),
            CustomText(text: "Орлого нэмэгдлээ"),
            const SizedBox(height: 24),
            MySeparator(
              color: MyColors.gray,
            ),
            const SizedBox(height: 24),
            SwipingButton(
              text: "Үргэлжлүүлэх",
              buttonTextStyle: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.normal,
                color: MyColors.white,
                fontSize: 14,
              ),
              swipeButtonColor: MyColors.primary,
              height: 50,
              onSwipeCallback: () {
                _driverCtx.changePage(5);
              },
            ),
            const SizedBox(height: 24),
            CustomButton(
              elevation: 0,
              isFullWidth: false,
              bgColor: MyColors.white,
              text: "Дуусгах",
              textFontWeight: FontWeight.bold,
              textColor: MyColors.black,
              onPressed: () {
                _driverCtx.changePage(5);
              },
              prefix: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  FontAwesomeIcons.close,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget testButton(context) {
  return Container(
    height: 48,
    margin: const EdgeInsets.all(12),
    child: CustomButton(
      text: "Show New Order",
      onPressed: () {
        if (_driverCtx.isDriverActive.value) {
          // _driverCtx.calculateDistance(context);
        }
      },
    ),
  );
}
