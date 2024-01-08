import 'dart:developer';

import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/api/local_notification.dart';
import 'package:Erdenet24/api/socket_instance.dart';
import 'package:Erdenet24/screens/driver/driver_auth_dialog_body.dart';
import 'package:Erdenet24/screens/driver/driver_bottom_sheets_body.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:iconly/iconly.dart';

class DriverController extends GetxController with GetTickerProviderStateMixin {
  final player = AudioPlayer();
  RxList orders = [].obs;
  RxList acceptedOrders = [].obs;
  RxBool isOnline = false.obs;
  RxBool fetchingOrders = false.obs;
  RxMap driverInfo = {}.obs;
  RxMap driverLoc = {}.obs;
  Rx<DriverStatus> driverStatus = DriverStatus.withoutOrder.obs;
  late AnimationController animationController;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  void handleSocketActions(Map payload) async {
    String action = payload["action"];
    payload["accepted"] = false;
    animationController = AnimationController(
        vsync: this, duration: Duration(seconds: payload["prepDuration"] ?? 0));
    animationController.forward();
    payload["timer"] = animationController;
    payload.toString();
    if (action == "preparing") {
      int index = orders.indexWhere((e) => e["id"] == payload["id"]);
      if (index < 0) {
        LocalNotification.showNotificationWithSound(
          id: 3,
          title: payload["store"],
          body: payload["address"],
          sound: "notify",
        );
        orders.add(payload);
      } else {
        log("not included!");
      }
    } else if (action == "preparing") {}
  }

  void saveUserToken() {
    _messaging.getToken().then((token) async {
      if (token != null) {
        var body = {"mapToken": token};
        await RestApi().updateUser(RestApiHelper.getUserId(), body);
      }
    });
  }

  void driverTurOnOff() async {
    CustomDialogs().showLoadingDialog();
    // saveUserToken();
    dynamic driverTurOnOff = await DriverApi().driverTurOnOff(!isOnline.value);
    Get.back();
    if (driverTurOnOff != null) {
      dynamic res = Map<String, dynamic>.from(driverTurOnOff);
      if (res["success"]) {
        isOnline.value = !isOnline.value;
        if (isOnline.value) {
          SocketClient().connect();
          refreshOrders();
        } else {
          SocketClient().disconnect();
        }
      }
    }
  }

  Future<void> refreshOrders() async {
    orders.clear();
    acceptedOrders.clear();
    getAllPreparingOrders();
  }

  void accept(Map item) {
    if (!acceptedOrders.contains(item["id"])) {
      acceptedOrders.add(item["id"]);
      int index = acceptedOrders.indexWhere((e) => e == item["id"]);
      orders.remove(item);
      item["accepted"] = true;
      orders.insert(index, item);
    }
    Get.back();
  }

  void received(Map item) async {
    int index = orders.indexWhere((e) => e["id"] == item["id"]);
    orders[index]["orderStatus"] = "delivering";
    orders.refresh();
    showOrderBottomSheet(item);
  }

  void delivered(Map item) async {
    int index = orders.indexWhere((e) => e["id"] == item["id"]);
    orders[index]["orderStatus"] = "delivered";
    orders.remove(orders[index]);
    acceptedOrders.removeWhere((element) => element == item["id"]);
    orders.refresh();
    acceptedOrders.refresh();
  }

  Future<void> showPasswordDialog(Map item) {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: DriverAuthDialogBody(
            item: item,
            type: "auth",
          ),
        );
      },
    );
  }

  Future<void> showSecretCodeDialog(Map item) {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: DriverAuthDialogBody(
            item: item,
            type: "secret",
          ),
        );
      },
    );
  }

  Future<void> showOrderBottomSheet(Map item) {
    return Get.bottomSheet(
      DriverBottomSheetsBody(item: item),
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

  void getAllPreparingOrders() async {
    fetchingOrders.value = true;
    dynamic getAllPreparingOrders = await DriverApi().getAllPreparingOrders();
    fetchingOrders.value = false;
    if (getAllPreparingOrders != null) {
      dynamic response = Map<String, dynamic>.from(getAllPreparingOrders);
      if (response["success"]) {
        orders.value = response["data"];
        for (var i = 0; i < orders.length; i++) {
          orders[i]["accepted"] = false;
          animationController = AnimationController(
              vsync: this,
              duration: Duration(seconds: orders[i]["prepDuration"]));
          animationController.forward();
          orders[i]["timer"] = animationController;
        }
      } else {}
    }
  }
}
