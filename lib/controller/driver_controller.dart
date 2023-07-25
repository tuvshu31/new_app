import 'dart:async';
import 'dart:convert';
import 'dart:developer';
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
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 2,
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
      // var body = {
      //   "latitude": info.latitude.toString(),
      //   "longitude": info.longitude.toString(),
      //   "heading": info.heading.toString()
      // };
      // updateDriverInfo(body);
    });
  }

  void updateDriverInfo(dynamic body) async {
    dynamic user =
        await RestApi().updateDriver(RestApiHelper.getUserId(), body);
    dynamic data = Map<String, dynamic>.from(user);
  }

  void cancelOrder() async {
    stopSound();
    hideBottomView();
    driverStatus.value = DriverStatus.withoutOrder;
    var id = newOrderInfo["id"];
    var driverId = RestApiHelper.getUserId();
    dynamic res = await RestApi().cancelOrder(id, driverId);
    log(res.toString());
    newOrderInfo.clear();
    showBottomView();
  }

  void acceptOrder() async {
    stopSound();
    hideBottomView();
    driverStatus.value = DriverStatus.arrivedAtStore;
    await RestApi().acceptOrder(newOrderInfo["id"], RestApiHelper.getUserId());
    showBottomView();
  }

  void finishDelivery() {
    RestApiHelper.saveOrderId(0);
    RestApiHelper.saveOrderInfo({});
    orderList.clear();
    driverPayments.clear();
    fetchDriverOrders();
    fetchDriverPayments();
    // removeMarker("store");
    newOrderInfo.clear();
  }

  void driverActionHandler(payload) async {
    if (newOrderInfo.isEmpty) {
      animationController.reverse();
      newOrderInfo.value = payload;
      driverStatus.value = DriverStatus.incomingNewOrder;
      animationController.forward();
      playSound("incoming");
    }
  }

  void hideBottomView() {
    animationController.reverse();
  }

  void showBottomView() {
    Future.delayed(const Duration(milliseconds: 600), () {
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
