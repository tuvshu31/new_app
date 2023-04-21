import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/notifications.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/screens/driver/driver_bottom_views.dart';
import 'package:Erdenet24/screens/store/store_orders_bottom_sheets.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';

final _storeCtx = Get.put(StoreController());

class StoreController extends GetxController {
  RxList storeOrderList = [].obs;
  RxMap storeInfo = {}.obs;
  RxList filteredOrderList = [].obs;
  RxBool fetching = false.obs;
  RxString orderStatus = "".obs;
  RxInt prepDuration = 0.obs;
  Timer? countdownTimer;
  RxList prepDurationList = [].obs;
  RxBool driverAccepted = false.obs;

  void startTimer(Duration i) {
    prepDurationList.add(i);
    countdownTimer = Timer.periodic(Duration(seconds: 1), (_) {
      const reduceSecondsBy = 1;
      final seconds = prepDurationList.last.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        prepDurationList.last = Duration(seconds: seconds);
      }
    });
  }

  void fetchStoreInfo() async {
    fetching.value = true;
    dynamic res1 = await RestApi().getUser(RestApiHelper.getUserId());
    dynamic data1 = Map<String, dynamic>.from(res1);
    if (data1["success"]) {
      storeInfo.value = data1["data"];
    }

    dynamic res2 =
        await RestApi().getStoreOrders(RestApiHelper.getUserId(), {});
    dynamic data2 = Map<String, dynamic>.from(res2);
    if (data2["success"]) {
      storeOrderList.value = data2["data"];
    }
    fetching.value = false;
  }

  void updateStoreInfo(body, context, successMsg, errorMsg) async {
    dynamic user = await RestApi().updateUser(RestApiHelper.getUserId(), body);
    dynamic data = Map<String, dynamic>.from(user);
    if (data["success"]) {
      successSnackBar(successMsg, 2, context);
    } else {
      errorSnackBar(errorMsg, 2, context);
    }
  }

  void filterOrders(int value) {
    filteredOrderList.clear();
    String type = value == 0
        ? "preparing"
        : value == 1
            ? "delivering"
            : "delivered";
    filteredOrderList.value =
        storeOrderList.where((p0) => p0["orderStatus"] == type).toList();
  }

  void updateOrder(int id, dynamic body) async {
    await RestApi().updateOrder(id, body);
  }

  // void storeNotifications(action, payload, isBackground) {
  //   if (action == "payment_success") {
  //   } else if (action == "sent") {
  //     createCustomNotification(
  //       isBackground,
  //       payload,
  //       isVisible: true,
  //       customSound: false,
  //       isCall: true,
  //       body: "Шинэ захиалга ирлээ",
  //     );
  //   } else if (action == "received") {
  //   } else if (action == "driverAccepted") {
  //     Get.back();
  //     driverAccepted.value = true;
  //     createCustomNotification(
  //       isBackground,
  //       payload,
  //       isVisible: true,
  //       customSound: false,
  //       isCall: false,
  //       body: "Жолооч дуудлага хүлээн авлаа",
  //     );
  //   } else if (action == "preparing") {
  //   } else if (action == "delivering") {
  //     createCustomNotification(
  //       isBackground,
  //       payload,
  //       isVisible: true,
  //       customSound: false,
  //       isCall: false,
  //       body: "Хүргэлтэнд гарлаа",
  //     );
  //   } else if (action == "delivered") {
  //     driverAccepted.value = false;
  //     createCustomNotification(
  //       isBackground,
  //       payload,
  //       isVisible: true,
  //       customSound: false,
  //       isCall: false,
  //       body: "Хүргэлт амжилттай",
  //     );
  //   } else {
  //     log(payload.toString());
  //   }
  // }

  void storeActionHandler(action, payload, context) {
    if (action == "payment_success") {
    } else if (action == "sent") {
      playSound("incoming");
      showDialog(
          useSafeArea: true,
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) {
            return FractionallySizedBox(
              heightFactor: 0.5,
              child: Container(
                margin: const EdgeInsets.all(12),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  child: SafeArea(
                    minimum: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: CustomText(
                            text: "Шинэ захиалга ирлээ!",
                          ),
                        ),
                        TimeCircularCountdown(
                          diameter: Get.width * .3,
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
                        Container(
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
                                    stopSound();
                                    // AwesomeNotifications().dismiss(1);
                                    Get.back();
                                    showOrdersSetTimeView(context, payload);
                                    var body = {"orderStatus": "received"};
                                    _storeCtx.updateOrder(payload["id"], body);
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    } else if (action == "received") {
    } else if (action == "driverAccepted") {
      log("driverAccepted");
    } else if (action == "preparing") {
    } else if (action == "delivering") {
      Get.back();
      for (dynamic i in storeOrderList) {
        if (i["id"] == payload["id"]) {
          log("orderStatus: ${i["id"]}");
          i["orderStatus"] = "delivering";
        }
      }
      filterOrders(0);
    } else if (action == "delivered") {
      for (dynamic i in storeOrderList) {
        if (i["id"] == payload["id"]) {
          i["orderStatus"] = "delivered";
        }
      }
      filterOrders(0);
    } else {}
  }
}
