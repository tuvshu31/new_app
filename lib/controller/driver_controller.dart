import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../screens/driver/driver_bottom_views.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class DriverController extends GetxController {
  RxBool isDriverActive = false.obs;
  int waitingSeconds = 30;
  RxDouble driverLat = 49.02821126030273.obs;
  RxDouble driverLng = 104.04634376483777.obs;
  RxDouble storeLat = 49.02646128988077.obs;
  RxDouble storeLng = 104.0399308405171.obs;
  RxBool acceptedTheDelivery = false.obs;
  RxBool deliveryRequest = false.obs;
  RxString distance = "".obs;
  RxString duration = "".obs;
  RxInt step = 0.obs;
  RxMap remoteMessageData = {}.obs;

  Rx<PageController> pageController = PageController().obs;

  Timer? countdownTimer;
  Duration myDuration = const Duration(hours: 3);
  Rx<Completer<GoogleMapController>> googleMapController =
      Completer<GoogleMapController>().obs;
  Rx<CountDownController> countDownController = CountDownController().obs;

  void turnedOnApp(value) async {
    log(remoteMessageData["latitude"].toString());
    isDriverActive.value = value;
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 50,
      );
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position? info) {
        if (info != null) {
          driverLat.value = info.latitude;
          driverLng.value = info.longitude;
        }
      });
      final GoogleMapController controller =
          await googleMapController.value.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(driverLat.value, driverLng.value),
              zoom: 16,
              tilt: 59),
        ),
      );
    }
  }

  void deliveryRequestArrived() async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/directions/json?';
    final respose = await Dio().get(baseUrl, queryParameters: {
      "origin": "${driverLat.value}, ${driverLng.value}",
      "destination": "${storeLat.value}, ${storeLng.value}",
      "key": "AIzaSyAHTYs2cMm87YH3wppr6wTtKRZxfyXjvB4"
    });
    final Map parsed = json.decode(respose.toString());

    if (parsed.isNotEmpty) {
      String distanceText = parsed["routes"][0]["legs"][0]["distance"]["text"];
      String durationText = parsed["routes"][0]["legs"][0]["duration"]["text"];
      distanceText = distanceText.substring(0, distanceText.length - 3);
      double distanceMile = double.parse(distanceText);
      double distanceKm = (distanceMile * 1.609);
      distance.value = distanceKm.toStringAsFixed(3);
      duration.value = durationText;
    }
    countDownController.value.start();
    playSound("incoming");
    deliveryRequest.value = true;
  }

  // void startTimer() {
  //   myDuration = const Duration(hours: 3);
  //   countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
  //     const reduceSecondsBy = 1;
  //     final seconds = myDuration.inSeconds - reduceSecondsBy;
  //     if (seconds < 0) {
  //       countdownTimer!.cancel();
  //     } else {
  //       myDuration = Duration(seconds: seconds);
  //     }
  //   });
  // }

  void changePage(int value) {
    pageController.value.animateToPage(
      value,
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceInOut,
    );
  }
}
