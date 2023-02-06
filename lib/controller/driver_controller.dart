import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/driver/driver_bottom_views.dart';

class DriverController extends GetxController {
  //General values
  RxInt step = 0.obs;
  RxBool isActive = false.obs;
  RxMap remoteMessageData = {}.obs;
  RxMap deliveryInfo = {}.obs;
  RxDouble driverBearing = 0.0.obs;
  Rx<LatLng> driverTarget = LatLng(49.02821126030273, 104.04634376483777).obs;
  //Location-tai holbootoi values
  RxString distanceAndDuration = "".obs;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  Rx<LatLng> storeLocation = LatLng(49.02821126030273, 104.04634376483777).obs;
  Rx<LatLng> driverLocation = LatLng(49.02821126030273, 104.04634376483777).obs;
  Rx<Completer<GoogleMapController>> googleMapController =
      Completer<GoogleMapController>().obs;

  void turnOnOff(value) async {
    if (step.value == 0) {
      isActive.value = value;
      if (value) {
        getCurrentLocation();
        positionStreamForMap();
        // positionStreamForServer();
        moveCamera(driverLocation.value, 18);
      }
    }
  }

  void getNewDelivery() async {
    storeLocation.value = LatLng(
      double.parse(deliveryInfo["latitude"]),
      double.parse(deliveryInfo["longitude"]),
    );
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

  void getCurrentLocation() async {
    var info = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverLocation.value = LatLng(info.latitude, info.longitude);
  }

  void positionStreamForMap() {
    LocationSettings locationSettingsForMap = const LocationSettings(
      accuracy: LocationAccuracy.best,
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
      accuracy: LocationAccuracy.best,
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
          bearing: driverBearing.value,
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

  void checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
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
  }
}
