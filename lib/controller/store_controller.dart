import 'dart:developer';

import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/api/local_notification.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/screens/store/store_bottom_sheet_views.dart';

import '../screens/store/store_order_details_screen.dart';

class StoreController extends GetxController with GetTickerProviderStateMixin {
  RxInt page = 1.obs;
  RxBool loading = false.obs;
  RxList orders = [].obs;
  RxBool hasMore = true.obs;
  RxBool isOpen = false.obs;
  RxMap pagination = {}.obs;
  RxInt tab = 0.obs;
  RxInt selectedTime = 0.obs;
  RxBool bottomSheetOpened = false.obs;
  late AnimationController animationController;

  void getStoreOrders() async {
    loading.value = true;
    var query = {"page": page, "status": tab};
    dynamic getUserOrders = await StoreApi().getStoreOrders(query);
    loading.value = false;
    if (getUserOrders != null) {
      dynamic response = Map<String, dynamic>.from(getUserOrders);
      if (response["success"]) {
        List newOrders = response["data"];
        orders = orders + newOrders;
      }
      pagination.value = response["pagination"];
      if (pagination["pageCount"] > page.value) {
        hasMore.value = true;
      } else {
        hasMore.value = false;
      }
    }
  }

  Future<void> refreshOrders() async {
    loading.value = false;
    pagination.clear();
    page.value = 1;
    orders.clear();
    getStoreOrders();
  }

  void handleSentAction(Map payload) {
    LocalNotification.showNotificationWithSound(
      id: payload["id"],
      title: "Erdenet24",
      body: "Шинэ захиалга ирлээ",
      sound: "incoming",
    );
    Get.offNamed(storeMainScreenRoute);
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return showIncomingOrderDialogBody(() {
          LocalNotification.cancelLocalNotification(id: payload["id"]);
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
    orders[index]["updatedTime"] = payload["updatedTime"];
    orders.refresh();
  }

  void handleDeliveredAction(Map payload) {
    LocalNotification.showSimpleNotification(
      id: payload["id"],
      title: "Erdenet24",
      body: "${payload["orderId"]} дугаартай захиалга хүргэгдлээ",
    );
    int index = orders.indexWhere((e) => e["id"] == payload["id"]);
    orders.removeAt(index);
    orders.refresh();
  }

  void handlePreparingAction(Map payload) {}

  void handleSocketActions(Map payload) async {
    String action = payload["action"];
    if (action == "sent" && isOpen.value) {
      handleSentAction(payload);
    }
    if (action == "preparing" && isOpen.value) {
      handlePreparingAction(payload);
    }
    if (action == "delivering" && isOpen.value) {
      handleDeliveringAction(payload);
    }
    if (action == "delivered" && isOpen.value) {
      handleDeliveredAction(payload);
    }
  }

  Future<void> showOrderBottomSheet(Map item) {
    bottomSheetOpened.value = true;
    return Get.bottomSheet(
      StoreOrdersDetailScreen(item: item),
      backgroundColor: MyColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }

  void startPreparingOrder(Map item, int pickedTime) async {
    CustomDialogs().showLoadingDialog();
    dynamic startPreparingOrder =
        await StoreApi().startPreparingOrder(item["id"], pickedTime);
    Get.back();
    if (startPreparingOrder != null) {
      dynamic response = Map<String, dynamic>.from(startPreparingOrder);
      if (response["success"]) {
        int index = orders.indexWhere((e) => e["id"] == item["id"]);
        orders[index]["orderStatus"] = "preparing";
        orders[index]["prepDuration"] = pickedTime;
        orders[index]["initialDuration"] = 0;
        orders.refresh();
      }
    }
  }

  void setToDelivery(Map item) async {
    CustomDialogs().showLoadingDialog();
    dynamic setToDelivery = await StoreApi().setToDelivery(item["id"]);
    Get.back();
    if (setToDelivery != null) {
      dynamic response = Map<String, dynamic>.from(setToDelivery);
      if (response["success"]) {
        Map data = response["data"];
        int index = orders.indexWhere((e) => e["id"] == data["id"]);
        orders[index]["orderStatus"] = "waitingForDriver";
        orders[index]["updatedTime"] = data["updatedTime"];
        orders.refresh();
      }
    } else {
      customSnackbar(ActionType.error, "Алдаа гарлаа", 3);
    }
  }
}
