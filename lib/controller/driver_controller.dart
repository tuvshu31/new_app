import 'dart:async';
import 'dart:developer';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverController extends GetxController {
  final player = AudioPlayer();
  RxBool isOnline = false.obs;
  RxMap newOrderInfo = {}.obs;
  RxList driverInfo = [].obs;
  RxList driverPayments = [].obs;
  RxList orderList = [].obs;
  Rx<LatLng> driverPosition = LatLng(0, 0).obs;
  RxDouble driverRotation = 0.0.obs;
  Rx<DriverStatus> driverStatus = DriverStatus.withoutOrder.obs;
  late AnimationController animationController;
  RxMap driverBonusInfo = {}.obs;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  TextEditingController textEditingController = TextEditingController();

  void playSound(type) async {
    player.play(AssetSource("sounds/$type.wav"));
  }

  void stopSound() async {
    player.stop();
  }

  void fetchDriverOrders() async {
    var query = {
      "deliveryDriverId": RestApiHelper.getUserId(),
      "orderStatus": "delivered"
    };
    dynamic res = await RestApi().getOrders(query);
    dynamic data = Map<String, dynamic>.from(res);
    if (data["success"]) {
      orderList.value = data["data"];
    }
  }

  void fetchDriverPayments() async {
    var body = {
      "deliveryDriverId": RestApiHelper.getUserId(),
      "orderStatus": "delivered"
    };
    dynamic res = await RestApi().driverPayments(body);
    dynamic data = Map<String, dynamic>.from(res);
    if (data["success"]) {
      driverPayments.value = data["deliveryCountByDate"];
    }
  }

  void onMapCreated(GoogleMapController controller) {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: isOnline.value ? 50 : 2,
      ),
    ).listen((Position? info) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );
      driverPosition.value = LatLng(position.latitude, position.longitude);
      driverRotation.value = position.heading;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: driverPosition.value,
            zoom: 17.0,
          ),
        ),
      );
      if (isOnline.value) {
        var body = {
          "latitude": info!.latitude.toString(),
          "longitude": info.longitude.toString(),
          "heading": info.heading.toString()
        };
        dynamic res =
            await RestApi().updateDriver(RestApiHelper.getUserId(), body);
        log(res.toString());
      }
    });
  }

  void updateDriverInfo(dynamic body) async {
    CustomDialogs().showLoadingDialog();
    dynamic user =
        await RestApi().updateDriver(RestApiHelper.getUserId(), body);
    if (user != null) {}
    Get.back();
  }

  void saveUserToken() {
    _messaging.getToken().then((token) async {
      if (token != null) {
        var body = {"mapToken": token};
        await RestApi().updateUser(RestApiHelper.getUserId(), body);
      }
    });
  }

  void turnOnOff(dynamic body) async {
    CustomDialogs().showLoadingDialog();
    saveUserToken();
    dynamic user =
        await RestApi().updateDriver(RestApiHelper.getUserId(), body);
    if (user != null) {
      dynamic res = Map<String, dynamic>.from(user);
      isOnline.value = res["data"]["isOpen"];
    }
    Get.back();
  }

  Future<void> getDriverBonusInfo() async {
    CustomDialogs().showLoadingDialog();
    int driverId = RestApiHelper.getUserId();
    dynamic response = await RestApi().getDriverBonus(driverId);
    if (response != null) {
      dynamic res = Map<String, dynamic>.from(response);
      driverBonusInfo.value = res;
      log(res.toString());
    }
    Get.back();
  }

  void incoming() async {
    hideBottomView();
    driverStatus.value = DriverStatus.incoming;
    showBottomView();
  }

  void acceptOrder() async {
    stopSound();
    hideBottomView();
    driverStatus.value = DriverStatus.arrived;
    var orderId = newOrderInfo["id"];
    CustomDialogs().showLoadingDialog();
    int driverId = RestApiHelper.getUserId();
    dynamic res = await RestApi().acceptOrder(orderId, driverId);
    Get.back();
    if (res != null) {
      showBottomView();
    } else {
      customSnackbar(DialogType.error, "Алдаа гарлаа", 3);
    }
  }

  void cancelOrder() async {
    stopSound();
    hideBottomView();
    AwesomeNotifications().cancel(1);
    driverStatus.value = DriverStatus.withoutOrder;
    newOrderInfo.clear();
    showBottomView();
  }

  void arrived() async {
    hideBottomView();
    driverStatus.value = DriverStatus.received;
    var orderId = newOrderInfo["id"];
    CustomDialogs().showLoadingDialog();
    int driverId = RestApiHelper.getUserId();
    dynamic res = await RestApi().arrived(orderId, driverId);
    Get.back();
    if (res != null) {
      showBottomView();
    } else {
      customSnackbar(DialogType.error, "Алдаа гарлаа", 3);
    }
  }

  void received() async {
    hideBottomView();
    driverStatus.value = DriverStatus.delivered;
    var orderId = newOrderInfo["id"];
    CustomDialogs().showLoadingDialog();
    int driverId = RestApiHelper.getUserId();
    dynamic res = await RestApi().received(orderId, driverId);
    Get.back();
    if (res != null) {
      showBottomView();
    } else {
      customSnackbar(DialogType.error, "Алдаа гарлаа", 3);
    }
  }

  void delivered() {
    driverDeliveryCodeApproveDialog(
      textEditingController,
      () async {
        if (textEditingController.text ==
            newOrderInfo["userAndDriverCode"].toString()) {
          Get.back();
          hideBottomView();
          driverStatus.value = DriverStatus.finished;
          var orderId = newOrderInfo["id"];
          textEditingController.clear();
          int driverId = RestApiHelper.getUserId();
          await RestApi().finished(orderId, driverId);
          showBottomView();
        } else {
          customSnackbar(DialogType.error, "Захиалгын код буруу байна", 3);
        }
      },
    );
  }

  void finished() async {
    hideBottomView();
    driverStatus.value = DriverStatus.withoutOrder;
    newOrderInfo.clear();
    showBottomView();
  }

  void driverActionHandler(payload) async {
    if (payload["action"] == "available") {
      int id = int.parse(payload["orderId"]);
      int driverId = RestApiHelper.getUserId();
      dynamic res = await RestApi().getNotifiedDrivers(id, driverId);
      log(res.toString());
      log(payload.toString());
    } else {
      if (newOrderInfo.isEmpty && isOnline.value) {
        animationController.reverse();
        newOrderInfo.value = payload;
        driverStatus.value = DriverStatus.incoming;
        animationController.forward();
        playSound("incoming");
      }
    }
  }

  void hideBottomView() {
    animationController.reverse();
  }

  void showBottomView() {
    Future.delayed(const Duration(milliseconds: 300), () {
      animationController.forward();
    });
  }

  void updateOrder(dynamic body) async {
    dynamic response =
        await RestApi().updateOrder(int.parse(newOrderInfo["id"]), body);
    dynamic d = Map<String, dynamic>.from(response);
    log(d.toString());
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
