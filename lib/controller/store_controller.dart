import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  RxList orderList = [].obs;
  RxList filteredOrderList = [].obs;
  RxBool fetching = false.obs;
  RxInt pickedMinutes = 0.obs;
  RxString orderStatus = "".obs;
  RxInt prepDuration = 0.obs;

  void fetchNewOrders() async {
    fetching.value = true;
    dynamic response =
        await RestApi().getStoreOrders(RestApiHelper.getUserId(), {});
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      orderList.value = d["data"];
    }
    fetching.value = false;
  }

  void filterOrders(int value) {
    String type = value == 0
        ? "preparing"
        : value == 1
            ? "delivering"
            : "delivered";
    filteredOrderList.value =
        orderList.where((p0) => p0["orderStatus"] == type).toList();
  }

  void getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    var body = {"mapToken": fcmToken};
    await RestApi().updateUser(RestApiHelper.getUserId(), body);
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      var body = {"mapToken": newToken};
      await RestApi().updateUser(RestApiHelper.getUserId(), body);
    });
  }

  void updateOrder(int id, dynamic body) async {
    var response = await RestApi().updateOrder(id, body);
    log(response.toString());
  }

  void callDriver(dynamic body) async {
    var response = await RestApi().assignDriver(body);
    log(response.toString());
  }
}
