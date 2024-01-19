import 'dart:async';
import 'dart:developer';

import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/screens/driver/driver_auth_dialog_body.dart';
import 'package:Erdenet24/screens/driver/driver_bottom_sheets_body.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  final _loginCtx = Get.put(LoginController());

  void handleSocketActions(Map payload) async {
    String action = payload["action"];
    if (action == "preparing") {
      handlePreparingAction(payload);
    }
    if (action == "accepted") {
      handleAcceptAction(payload);
    }
    if (action == "delivered") {
      handleDeliveredAction(payload);
    }
    if (action == "waitingForDriver") {
      handleWaitingForDriverAction(payload);
    }
  }

  void handlePreparingAction(payload) {
    int index = orders.indexWhere((e) => e["id"] == payload["id"]);
    if (index < 0) {
      payload["accepted"] = false;
      animationController = AnimationController(
          vsync: this, duration: Duration(seconds: payload["initialDuration"]));
      animationController.forward();
      payload["timer"] = animationController;
      orders.add(payload);
      player.play(AssetSource("sounds/doordash.mp3"));
    }
  }

  void handleAcceptAction(Map item) {
    int driverId = RestApiHelper.getUserId();
    if (item["driverId"] != driverId) {
      int index = orders.indexWhere((e) => e["id"] == item["id"]);
      orders[index] = item;
      animationController = AnimationController(
          vsync: this, duration: Duration(seconds: item["initialDuration"]));
      animationController.forward();
      item["timer"] = animationController;
      orders.refresh();
    }
  }

  void handleDeliveredAction(Map item) {
    int driverId = RestApiHelper.getUserId();
    if (item["driverId"] != driverId) {
      int index = orders.indexWhere((e) => e["id"] == item["id"]);
      if (index > -1) {
        orders.removeAt(index);
        orders.refresh();
      }
    }
  }

  void handleWaitingForDriverAction(Map item) {
    int index = orders.indexWhere((e) => e["id"] == item["id"]);
    if (index > -1) {
      orders[index]["orderStatus"] = item["orderStatus"];
      orders.refresh();
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
    dynamic driverTurOnOff = await DriverApi().driverTurOnOff(!isOnline.value);
    Get.back();
    if (driverTurOnOff != null) {
      dynamic res = Map<String, dynamic>.from(driverTurOnOff);
      if (res["success"]) {
        isOnline.value = !isOnline.value;
        if (isOnline.value) {
          _loginCtx.saveUserToken();
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
        listenDriverLocation();
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
        refreshOrders();
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

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  void listenDriverLocation() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      if (position != null) {
        String latitude = position.latitude.toString();
        String longitude = position.longitude.toString();
        String heading = position.heading.toString();
        var body = {
          "latitude": latitude,
          "longitude": longitude,
          "heading": heading,
        };
        dynamic updateDriverLocation =
            await DriverApi().updateDriverLocation(body);
        if (updateDriverLocation != null) {
          dynamic response = Map<String, dynamic>.from(updateDriverLocation);
          if (response["success"]) {
            log(response.toString());
          }
        }
      }
    });
  }
}
