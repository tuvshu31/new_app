import 'dart:developer';

import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/api/local_notification.dart';
import 'package:Erdenet24/api/socket_instance.dart';
import 'package:Erdenet24/screens/driver/driver_auth_dialog_body.dart';
import 'package:Erdenet24/screens/driver/driver_bottom_sheets_body.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';

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
    if (action == "preparing" && isOnline.value) {
      handlePreparingAction(payload);
    }
    if (action == "accepted" && isOnline.value) {
      handleAcceptAction(payload);
      log(payload.toString());
    }
    if (action == "delivering" && isOnline.value) {
      // handleDeliveringAction(payload);
    }
    if (action == "delivered" && isOnline.value) {
      handleDeliveredAction(payload);
    }
  }

  void handleDeliveredAction(Map item) {
    int index = orders.indexWhere((e) => e["id"] == item["id"]);
    if (index > 0) {
      orders.removeAt(index);
      orders.refresh();
    }
  }

  void handleAcceptAction(Map item) {
    int index = orders.indexWhere((e) => e["id"] == item["id"]);
    if (index > 0) {
      orders[index]["orderStatus"] = "driverAccepted";
      orders[index]["driverName"] = item["driverName"];
      orders.refresh();
    }
  }

  void handlePreparingAction(payload) {
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

  Future<void> driverAcceptOrder(Map item) async {
    CustomDialogs().showLoadingDialog();
    dynamic driverAcceptOrder = await DriverApi().driverAcceptOrder(item["id"]);
    Get.back();
    if (driverAcceptOrder != null) {
      dynamic response = Map<String, dynamic>.from(driverAcceptOrder);
      if (response["success"]) {
        if (!acceptedOrders.contains(item["id"])) {
          acceptedOrders.add(item["id"]);
          int index = acceptedOrders.indexWhere((e) => e == item["id"]);
          orders.remove(item);
          item["acceptedByMe"] = true;
          orders.insert(index, item);
          orders.refresh();
        }
      } else {
        customSnackbar(
            ActionType.error, response["errorText"] ?? "Алдаа гарлаа", 2);
      }
    }
  }

  void driverReceived(Map item) async {
    CustomDialogs().showLoadingDialog();
    dynamic driverReceived = await DriverApi().driverReceived(item["id"]);
    Get.back();
    if (driverReceived != null) {
      dynamic response = Map<String, dynamic>.from(driverReceived);
      if (response["success"]) {
        int index = orders.indexWhere((e) => e["id"] == item["id"]);
        orders[index]["orderStatus"] = "delivering";
        orders.refresh();
        showOrderBottomSheet(item);
      }
    }
  }

  void driverDelivered(Map item) async {
    CustomDialogs().showLoadingDialog();
    dynamic driverDelivered = await DriverApi().driverDelivered(item["id"]);
    Get.back();
    if (driverDelivered != null) {
      dynamic response = Map<String, dynamic>.from(driverDelivered);
      if (response["success"]) {
        int index = orders.indexWhere((e) => e["id"] == item["id"]);
        orders[index]["orderStatus"] = "delivered";
        orders.remove(orders[index]);
        acceptedOrders.removeWhere((element) => element == item["id"]);
        orders.refresh();
        acceptedOrders.refresh();
        customSnackbar(ActionType.success, "Захиалга амжилттай хүргэгдлээ", 3);
      }
    }
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
          animationController = AnimationController(
              vsync: this,
              duration: Duration(seconds: orders[i]["initialDuration"]));
          animationController.forward();
          orders[i]["timer"] = animationController;
        }
      }
    }
  }
}
