import 'dart:developer';
import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/api/local_notification.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/screens/store/store_bottom_sheet_views.dart';

class StoreController extends GetxController {
  RxInt page = 1.obs;
  RxBool loading = false.obs;
  RxList orders = [].obs;
  RxBool hasMore = true.obs;
  RxMap pagination = {}.obs;
  RxInt tab = 0.obs;
  RxInt selectedTime = 0.obs;

  void getStoreOrders() async {
    loading.value = true;
    var query = {"page": page, "status": tab};
    dynamic getUserOrders = await StoreApi().getStoreOrders(query);
    loading.value = false;
    if (getUserOrders != null) {
      dynamic response = Map<String, dynamic>.from(getUserOrders);
      if (response["success"]) {
        orders = orders + response["data"];
        log(orders.toString());
      }
      pagination.value = response["pagination"];
      if (pagination["pageCount"] > page.value) {
        hasMore.value = true;
      } else {
        hasMore.value = false;
      }
    }
  }

  void handleSentAction(Map payload) {
    LocalNotification.showIncomingSoundNotification(
      id: payload["id"],
      title: "Erdenet24",
      body: "Шинэ захиалга ирлээ",
    );
    Get.offNamed(storeMainScreenRoute);
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return showIncomingOrderDialogBody(() {
          stopSound();
          Get.back();
          Get.toNamed(storeOrdersScreenRoute);
        });
      },
    );
  }

  void handleDeliveringAction(Map payload) {
    LocalNotification.showSimpleNotification(
      id: payload["id"],
      title: "Erdenet24",
      body: "${payload["orderId"]} дугаартай захиалга хүргэлтэнд гарлаа",
    );
    int index = orders.indexWhere((e) => e["id"] == payload["id"]);
    orders[index]["orderStatus"] = "delivering";
  }

  void handlePreparingAction(Map payload) {}

  void handleSocketActions(Map payload) async {
    log(payload.toString());
    String action = payload["action"];
    if (action == "sent") {
      handleSentAction(payload);
    }
    if (action == "preparing") {
      handlePreparingAction(payload);
    }
    if (action == "delivering") {
      handleDeliveringAction(payload);
    }
  }
}
