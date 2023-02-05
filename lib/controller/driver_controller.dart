import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:custom_timer/custom_timer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/driver/driver_bottom_views.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverController extends GetxController {
  //General values
  RxInt step = 0.obs;
  RxBool isActive = false.obs;
  RxMap remoteMessageData = {}.obs;
  RxDouble driverHeading = 0.0.obs;
  RxMap deliveryInfo = {}.obs;
  //Location-tai holbootoi values
  RxString distanceAndDuration = "".obs;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  Rx<LatLng> storeLocation = LatLng(49.02821126030273, 104.04634376483777).obs;
  Rx<LatLng> driverLocation = LatLng(49.02821126030273, 104.04634376483777).obs;
  Rx<Completer<GoogleMapController>> googleMapController =
      Completer<GoogleMapController>().obs;

  void turnOnOff(value) async {
    isActive.value = value;
    if (value && await isLocationServiceEnabled()) {
      getCurrentLocation();
      positionStreamForMap();
      positionStreamForServer();
      moveCamera(driverLocation.value, 18);
      addMarker("driver", driverLocation.value);
    }
  }

  void getNewDelivery() async {
    getDistance(driverLocation.value, storeLocation.value);
    addMarker("store", storeLocation.value);
    moveCamera(storeLocation.value, 12);
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
  Future<bool> isLocationServiceEnabled() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    return enabled;
  }

  void getCurrentLocation() async {
    var info = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    driverLocation.value = LatLng(info.latitude, info.longitude);
    driverHeading.value = info.heading;
  }

  void positionStreamForMap() {
    LocationSettings locationSettingsForMap = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 3,
    );
    Geolocator.getPositionStream(locationSettings: locationSettingsForMap)
        .listen((Position? info) {
      driverLocation.value = LatLng(info!.latitude, info.longitude);
    });
    moveCamera(driverLocation.value, 18);
  }

  void positionStreamForServer() {
    LocationSettings locationSettingsForServer = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 200,
    );
    Geolocator.getPositionStream(locationSettings: locationSettingsForServer)
        .listen((Position info) {});
  }

  void moveCamera(LatLng latLng, double zoom) async {
    final GoogleMapController controller =
        await googleMapController.value.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: zoom,
          bearing: driverHeading.value,
          tilt: 59,
        ),
      ),
    );
  }

  void getDistance(LatLng driver, LatLng store) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/directions/json?';
    final respose = await Dio().get(baseUrl, queryParameters: {
      "origin": "${driver.latitude}, ${driver.longitude}",
      "destination": "${store.latitude}, ${store.longitude}",
      "key": "AIzaSyAHTYs2cMm87YH3wppr6wTtKRZxfyXjvB4"
    });
    final Map parsed = json.decode(respose.toString());
    String distanceText = parsed["routes"][0]["legs"][0]["distance"]["text"];
    String durationText = parsed["routes"][0]["legs"][0]["duration"]["text"];
    distanceText = distanceText.substring(0, distanceText.length - 3);
    double distanceMile = double.parse(distanceText);
    String distanceKm = (distanceMile * 1.609).toStringAsFixed(3);
    distanceAndDuration.value = "$distanceKm km, $durationText";
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

  void removeMarker(String type) {
    markers.removeWhere(
      (key, value) => value.markerId == MarkerId(type),
    );
  }

  @pragma('vm:entry-point')
  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      storeLocation.value = LatLng(
        double.parse(message.data["latitude"]),
        double.parse(message.data["longitude"]),
      );
      getNewDelivery();
      log("Firebase.s foreground message irj bn $message");
    });
  }

  void firebaseMessagingForegroundHandler() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      storeLocation.value = LatLng(
        double.parse(message.data["latitude"]),
        double.parse(message.data["longitude"]),
      );

      deliveryInfo.value = message.data;
      storeLocation.value = LatLng(
        double.parse(deliveryInfo["latitude"]),
        double.parse(deliveryInfo["longitude"]),
      );
      getNewDelivery();
    });
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}


  // Widget activeTimerCountDown() {
  //   String strDigits(int n) => n.toString().padLeft(2, '0');
  //   final hours = strDigits(_driverCtx.myDuration.inHours.remainder(60));
  //   final minutes = strDigits(_driverCtx.myDuration.inMinutes.remainder(60));
  //   final seconds = strDigits(_driverCtx.myDuration.inSeconds.remainder(60));
  //   return _driverCtx.isDriverActive.value
  //       ? Positioned(
  //           right: 0,
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  //             decoration: const BoxDecoration(color: MyColors.white),
  //             child: CustomText(
  //               text: "$hours:$minutes:$seconds",
  //               color: MyColors.primary,
  //               fontSize: 12,
  //             ),
  //           ),
  //         )
  //       : Container();
  // }