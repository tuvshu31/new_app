import 'dart:developer';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:slide_to_act/slide_to_act.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/screens/store/store_orders_screen.dart';
import 'package:Erdenet24/screens/driver/driver_bottom_views.dart';

final _storeCtx = Get.put(StoreController());
final _driverCtx = Get.put(DriverController());
int selectedTime = 0;

void showOrdersNotificationView(context, data) {
  showModalBottomSheet(
    enableDrag: false,
    isDismissible: false,
    backgroundColor: MyColors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 24),
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Container(
                    margin: EdgeInsets.only(top: Get.height * .1),
                    child: const CustomText(
                      text: "Шинэ захиалга ирлээ!",
                      fontSize: 18,
                    )),
              ),
              Align(
                alignment: AlignmentDirectional.center,
                child: TimeCircularCountdown(
                  diameter: Get.width * .5,
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
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  height: 70,
                  child: Builder(
                    builder: (contexts) {
                      final GlobalKey<SlideActionState> key = GlobalKey();
                      return SlideAction(
                        height: 70,
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
                            var body = {"orderStatus": "received"};
                            _storeCtx.updateOrder(data["id"], body);
                            showOrdersSetTime(context, data);
                          });
                        },
                        alignment: Alignment.centerRight,
                        sliderButtonIcon: const Icon(
                          Icons.double_arrow_rounded,
                          color: MyColors.white,
                        ),
                        child: const Text(
                          "Баталгаажуулах",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

void storeOrdersToDeliveryView(context, data) {
  showModalBottomSheet(
    backgroundColor: MyColors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 24),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomText(
                    text: "Захиалгын код:",
                    fontSize: 14,
                    color: MyColors.gray,
                  ),
                  CustomText(
                    text: data["orderId"].toString(),
                    fontSize: 16,
                    color: MyColors.black,
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 7,
                        color: MyColors.fadedGrey,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: data["products"].length,
                    itemBuilder: (context, index) {
                      var product = data["products"][index];
                      return Container(
                          height: Get.height * .09,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          color: MyColors.white,
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: MyColors.black,
                                      width: 1,
                                    ),
                                  ),
                                  child: CustomText(
                                    text: "${index + 1}",
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            title: CustomText(
                              text: product["name"],
                              fontSize: 16,
                            ),
                            subtitle: CustomText(
                                text: convertToCurrencyFormat(
                              int.parse(product["price"]),
                              toInt: true,
                              locatedAtTheEnd: true,
                            )),
                            trailing: CustomText(
                                text: "${product["quantity"]} ширхэг"),
                          ));
                    },
                  ),
                ],
              ),
              data["orderStatus"] == "preparing"
                  ? Align(
                      alignment: AlignmentDirectional.bottomEnd,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        height: 70,
                        child: Builder(
                          builder: (contexts) {
                            final GlobalKey<SlideActionState> key = GlobalKey();
                            return SlideAction(
                              height: 70,
                              outerColor: MyColors.black,
                              innerColor: MyColors.primary,
                              elevation: 0,
                              key: key,
                              submittedIcon: const Icon(
                                FontAwesomeIcons.check,
                                color: MyColors.white,
                              ),
                              onSubmit: () {
                                Future.delayed(
                                    const Duration(milliseconds: 300),
                                    () async {
                                  key.currentState!.reset();
                                  // for (dynamic i in _storeCtx.orderList) {
                                  //   if (i == data) {
                                  //     i["orderStatus"] = "delivering";
                                  //   }
                                  // }
                                  // _storeCtx.filterOrders(0);
                                  var body = {"orderStatus": "delivering"};
                                  // _storeCtx.updateOrder(data["id"], body);
                                  //  CALL DRIVER
                                  var body1 = {
                                    "orderId": data['orderId'],
                                    'address': data["address"],
                                    'phone': data["phone"],
                                  };

                                  _storeCtx.callDriver(body1);
                                  notifyToDrivers(context, data);
                                  // Get.back();
                                });
                                // Future.delayed(const Duration(minutes: 5), () {
                                //   key.currentState!.reset();
                                //   callDriver(data);
                                // });
                              },
                              alignment: Alignment.centerRight,
                              sliderButtonIcon: const Icon(
                                Icons.double_arrow_rounded,
                                color: MyColors.white,
                              ),
                              child: const Text(
                                "Хүргэлтэнд гаргах",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      );
    },
  );
}

void showOrdersSetTime(context, data) {
  showModalBottomSheet(
    backgroundColor: MyColors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Obx(
        () => FractionallySizedBox(
          heightFactor: 0.9,
          child: SafeArea(
            minimum: const EdgeInsets.symmetric(vertical: 24),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: "Захиалгын код:",
                      fontSize: 14,
                      color: MyColors.gray,
                    ),
                    CustomText(
                      text: data["orderId"].toString(),
                      fontSize: 16,
                      color: MyColors.black,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return Container(
                                  height: 7,
                                  color: MyColors.fadedGrey,
                                );
                              },
                              shrinkWrap: true,
                              itemCount: data["products"].length,
                              itemBuilder: (context, index) {
                                var product = data["products"][index];
                                return Container(
                                    height: Get.height * .09,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    color: MyColors.white,
                                    child: Center(
                                      child: ListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: MyColors.black,
                                                  width: 1,
                                                ),
                                              ),
                                              child: CustomText(
                                                text: "${index + 1}",
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        title: CustomText(
                                          text: product["name"],
                                          fontSize: 16,
                                        ),
                                        subtitle: CustomText(
                                            text: convertToCurrencyFormat(
                                          int.parse(product["price"]),
                                          toInt: true,
                                          locatedAtTheEnd: true,
                                        )),
                                        trailing: CustomText(
                                            text:
                                                "${product["quantity"]} ширхэг"),
                                      ),
                                    ));
                              },
                            ),
                            Container(height: 7, color: MyColors.fadedGrey),
                            Container(
                              height: Get.height * .09,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              color: MyColors.white,
                              child: Center(
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      CustomText(
                                        text: "Нийт үнэ:",
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                  trailing: CustomText(
                                    text: convertToCurrencyFormat(
                                      int.parse(data["totalAmount"].toString()),
                                      locatedAtTheEnd: true,
                                      toInt: true,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Container(height: 7, color: MyColors.fadedGrey),
                            Container(
                              height: Get.height * .09,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              color: MyColors.white,
                              child: Center(
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  leading: const CustomText(
                                    text: "Бэлдэх хугацаа:",
                                    fontSize: 16,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomButton(
                                        isFullWidth: false,
                                        text: _storeCtx.prepDuration.value == 0
                                            ? "Сонгох"
                                            : "${_storeCtx.prepDuration.value} минут",
                                        onPressed: () {
                                          showPickerNumber(context, data);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: Get.height * .15)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                _storeCtx.prepDuration.value != 0
                    ? Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          height: 70,
                          child: Builder(
                            builder: (contexts) {
                              final GlobalKey<SlideActionState> key =
                                  GlobalKey();
                              return SlideAction(
                                height: 70,
                                outerColor: MyColors.black,
                                innerColor: MyColors.primary,
                                elevation: 0,
                                key: key,
                                submittedIcon: const Icon(
                                  FontAwesomeIcons.check,
                                  color: MyColors.white,
                                ),
                                onSubmit: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    key.currentState!.reset();
                                    Get.back();
                                    data["orderStatus"] = "preparing";
                                    data["prepDuration"] =
                                        _storeCtx.prepDuration.value;
                                    CountDownController cDownCtrl =
                                        CountDownController();
                                    _storeCtx.countDownControllerList
                                        .add(cDownCtrl);
                                    _storeCtx.orderList.add(data);
                                    _storeCtx.filterOrders(0);
                                    var body = {
                                      "orderStatus": "preparing",
                                      "prepDuration": _storeCtx
                                          .prepDuration.value
                                          .toString(),
                                    };
                                    _storeCtx.updateOrder(data["id"], body);
                                    _storeCtx.prepDuration.value = 0;
                                    _storeCtx.countDownControllerList.last
                                        .start();
                                    Get.to(() => const StoreOrdersScreen());
                                  });
                                },
                                alignment: Alignment.centerRight,
                                sliderButtonIcon: const Icon(
                                  Icons.double_arrow_rounded,
                                  color: MyColors.white,
                                ),
                                child: const Text(
                                  "Бэлдэж эхлэх",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      );
    },
  );
}

showPickerNumber(BuildContext context, data) {
  Picker(
      adapter: NumberPickerAdapter(data: [
        const NumberPickerColumn(begin: 1, end: 60),
      ]),
      delimiter: [
        PickerDelimiter(
            child: Container(
          width: 100.0,
          alignment: Alignment.center,
          child: const CustomText(
            text: "минут",
            isLowerCase: true,
          ),
        ))
      ],
      hideHeader: true,
      title: const CustomText(text: "Хугацаа сонгох"),
      looping: true,
      smooth: 100,
      cancel: Container(),
      confirmText: "Сонгох",
      confirmTextStyle:
          const TextStyle(color: MyColors.black, fontFamily: "Nunito"),
      onConfirm: (Picker picker, List value) {
        _storeCtx.prepDuration.value = picker.getSelectedValues()[0];
      }).showDialog(context);
}

void notifyToDrivers(context, data) {
  showModalBottomSheet(
    isDismissible: false,
    enableDrag: false,
    backgroundColor: MyColors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.5,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 12),
                  //   child: AnimatedTextKit(
                  //     repeatForever: true,
                  //     animatedTexts: [
                  //       RotateAnimatedText(
                  //         '1 жолооч татгалзлаа',
                  //         textStyle: TextStyle(
                  //           color: MyColors.primary,
                  //         ),
                  //       ),
                  //     ],
                  //     onTap: () {
                  //       print("Tap Event");
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 8),
                    child: IconButton(
                        onPressed: Get.back, icon: const Icon(Icons.close)),
                  )
                ],
              ),
              Lottie.asset(
                'assets/json/calling.json',
                height: Get.width * .5,
                width: Get.width * .5,
              ),
              const CustomText(
                  textAlign: TextAlign.center,
                  text:
                      "Хамгийн ойрхон байгаа жолоочтой \n холбогдож байна..."),
            ],
          ),
        ),
      );
    },
  );
}
