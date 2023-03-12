import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/screens/store/store_orders_bottom_sheets.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  RxList storeOrderList = [].obs;
  RxMap storeInfo = {}.obs;
  RxList filteredOrderList = [].obs;
  RxBool fetching = false.obs;
  RxString orderStatus = "".obs;
  RxInt prepDuration = 0.obs;
  Timer? countdownTimer;
  RxList prepDurationList = [].obs;

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

  void storeNotificationHandler(message) {
    var data = message.data;
    var jsonData = json.decode(data["data"]);
    var dataType = data["type"];
    if (dataType == "sent") {
      // showOrdersNotificationView(context, jsonData);
      log("Hello");
    } else if (dataType == "received") {
    } else if (dataType == "preparing") {
    } else if (dataType == "delivering") {
    } else if (dataType == "delivered") {
      for (dynamic i in storeOrderList) {
        if (i == data) {
          i["orderStatus"] = "delivered";
        }
      }
      filterOrders(0);
    }
  }
}
