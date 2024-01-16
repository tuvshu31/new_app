import 'dart:developer';
import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/screens/driver/driver_auth_dialog_body.dart';
import 'package:Erdenet24/screens/driver/driver_bottom_sheets_body.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';

class DriverController extends GetxController with GetTickerProviderStateMixin {
  final player = AudioPlayer();
  RxList orders = [].obs;
  RxBool isOnline = false.obs;
  RxBool fetchingOrders = false.obs;
  RxMap driverInfo = {}.obs;
  RxMap driverLoc = {}.obs;
  Rx<DriverStatus> driverStatus = DriverStatus.withoutOrder.obs;
  late AnimationController animationController;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  Rx<ScrollController> scrollController = ScrollController().obs;

  void handleSocketActions(Map payload) async {
    String action = payload["action"];
    if (action == "preparing") {
      handlePreparingAction(payload);
    } else if (action == "accept") {
      handleAcceptAction(payload);
    } else if (action == "delivering") {
      // handleDeliveringAction(payload);
    } else if (action == "delivered") {
      handleDeliveredAction(payload);
    } else if (action == "accepted") {
      handleAcceptedByOthersAction(payload);
    } else {
      log(payload.toString());
    }
  }

  void handleAcceptedByOthersAction(Map item) {
    int index = orders.indexWhere((e) => e["id"] == item["id"]);
    if (index > 0) {
      orders[index]["driverName"] = item["driverName"];
      orders[index]["orderStatus"] = item["orderStatus"];
      orders[index]["deliveryStatus"] = item["deliveryStatus"];
      orders.refresh();
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
    log(payload.toString());
    int index = orders.indexWhere((e) => e["id"] == payload["id"]);
    if (index < 0) {
      // LocalNotification.showNotificationWithSound(
      //   id: 3,
      //   title: payload["store"],
      //   body: payload["address"],
      //   sound: "notify",s
      // );
      animationController = AnimationController(
          vsync: this, duration: Duration(seconds: payload["initialDuration"]));
      animationController.forward();
      payload["timer"] = animationController;
      orders.add(payload);
      player.play(AssetSource("sounds/doordash.mp3"));
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
          connectToSocket();
          refreshOrders();
        } else {
          socket.disconnect();
        }
      }
    }
  }

  Future<void> refreshOrders() async {
    orders.clear();
    getAllPreparingOrders();
  }

  void scrollToTop() {
    scrollController.value.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  Future<void> driverAcceptOrder(Map item) async {
    CustomDialogs().showLoadingDialog();
    dynamic driverAcceptOrder = await DriverApi().driverAcceptOrder(item["id"]);
    Get.back();
    if (driverAcceptOrder != null) {
      dynamic response = Map<String, dynamic>.from(driverAcceptOrder);
      if (response["success"]) {
        refreshOrders();
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
        orders.refresh();
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

  void connectToSocket() {
    if (socket.disconnected) {
      socket.connect();
      socket.emit("join", "drivers");
    }
  }
}
