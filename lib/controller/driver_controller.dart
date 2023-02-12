import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/map_helper.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/driver/driver_bottom_views.dart';

class DriverController extends GetxController {
  //General values
  RxInt step = 0.obs;
  RxBool isActive = false.obs;
  RxMap remoteMessageData = {}.obs;
  RxMap deliveryInfo = {}.obs;
  RxDouble driverBearing = 0.0.obs;
  RxString fcmToken = "".obs;
  dynamic driverInfo = [].obs;
  Rx<HashSet<Circle>> circles = HashSet<Circle>().obs;
  Rx<LatLng> driverTarget = LatLng(49.02821126030273, 104.04634376483777).obs;
  //Location-tai holbootoi values
  RxString distanceAndDuration = "".obs;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  Rx<LatLng> storeLocation = LatLng(49.02821126030273, 104.04634376483777).obs;
  Rx<LatLng> driverLocation = LatLng(49.02821126030273, 104.04634376483777).obs;
  Rx<Completer<GoogleMapController>> googleMapController =
      Completer<GoogleMapController>().obs;

  void fetchDriverInfo(int id) async {
    dynamic response = await RestApi().getDriver(id);
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      driverInfo = d["data"];
    }
    log(driverInfo.toString());
  }

  void updateDriverInfo(dynamic body) async {
    var id = RestApiHelper.getUserId();
    dynamic user = await RestApi().updateDriver(id, body);
    dynamic data = Map<String, dynamic>.from(user);
    if (data["success"]) {}
  }

  void turnOnOff(value) async {
    if (step.value == 0) {
      isActive.value = value;
      if (value) {
        moveCamera(driverLocation.value, 18);
        addCircles("driver", driverLocation.value);
      }
    }
  }

  void getNewDelivery() async {
    storeLocation.value = LatLng(
      double.parse(deliveryInfo["latitude"]),
      double.parse(deliveryInfo["longitude"]),
    );
    calculateDistance(driverLocation.value, storeLocation.value);
    addCircles("store", storeLocation.value);
    moveCamera(storeLocation.value, 14);
    step.value = 1;
    playSound("incoming");
  }

  void cancelNewDelivery() async {
    step.value = 0;
    stopSound();
    removeMarker("store");
    moveCamera(driverLocation.value, 18);
  }

  void finishDelivery() {
    step.value = 0;
    removeMarker("store");
    moveCamera(driverLocation.value, 18);
    deliveryInfo.clear();
  }

  //Controller-d hereglej bga helper.uud:

  void moveCamera(LatLng latLng, double zoom) async {
    final GoogleMapController controller =
        await googleMapController.value.future;

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, zoom),
    );
  }

  void addMarker(String type, LatLng latLng) async {
    BitmapDescriptor iconBitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/png/app/$type.png",
    );
    var markerIdVal = type;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      icon: iconBitmap,
    );
    markers[markerId] = marker;
  }

  void addCircles(String type, LatLng point) {
    String circleId = "origin";
    double radius = 5;
    int strokeWidth = 24;
    Color fillColor = MyColors.white;
    Color strokeColor = MyColors.white;
    if (type == "driver") {
      circleId = "driver";
      fillColor = MyColors.primary;
      strokeColor = MyColors.primary.withOpacity(0.3);
    } else if (type == "store") {
      circleId = "store";
      radius = 15;
      fillColor = MyColors.white;
      strokeColor = MyColors.green;
      strokeWidth = 40;
    }

    circles.value.add(Circle(
      circleId: CircleId(circleId),
      center: point,
      radius: radius,
      fillColor: fillColor,
      strokeWidth: strokeWidth,
      strokeColor: strokeColor,
    ));
  }

  void removeCircles(String type) {
    circles.value.removeWhere((element) => element.circleId == type);
  }

  void removeMarker(String type) {
    markers.removeWhere(
      (key, value) => value.markerId == MarkerId(type),
    );
  }
}
