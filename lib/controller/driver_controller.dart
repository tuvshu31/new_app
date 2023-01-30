import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/driver/driver_screen_bottomsheet_views.dart';

class DriverController extends GetxController {
  RxBool distanceCalculated = false.obs;
  RxBool acceptedTheDelivery = false.obs;
  RxInt deliverySteps = 0.obs;
  RxString distance = "".obs;
  RxString duration = "".obs;
  RxList polylinePoints = [].obs;
  Rx<LatLng> origin = LatLng(49.028494366069474, 104.04692604155208).obs;
  Rx<LatLng> destination = LatLng(49.02646128988077, 104.0399308405171).obs;
  RxBool isDriverActive = false.obs;
  Rx<PageController> pageController = PageController().obs;
  int waitingSeconds = 30;
  Timer? countdownTimer;
  Duration myDuration = const Duration(hours: 3);
  final Rx<Completer<GoogleMapController>> googleMapController =
      Completer<GoogleMapController>().obs;
  final Rx<CountDownController> countDownController = CountDownController().obs;

  void turnedOnApp(value) {
    isDriverActive.value = value;
    // startTimer();
    determineUsersPosition();
  }

  void startTimer() {
    myDuration = const Duration(hours: 3);
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      const reduceSecondsBy = 1;
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  void calculateDistance(context) async {
    loadingDialog(context);
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/directions/json?';
    final respose = await Dio().get(baseUrl, queryParameters: {
      "origin": "${origin.value.latitude}, ${origin.value.longitude}",
      "destination":
          "${destination.value.latitude}, ${destination.value.longitude}",
      "key": "AIzaSyAHTYs2cMm87YH3wppr6wTtKRZxfyXjvB4"
    });

    final Map parsed = json.decode(respose.toString());

    String distanceText = parsed["routes"][0]["legs"][0]["distance"]["text"];
    String durationText = parsed["routes"][0]["legs"][0]["duration"]["text"];
    dynamic polyline = PolylinePoints()
        .decodePolyline(parsed["routes"][0]["overview_polyline"]["points"]);

    if (distanceText.isNotEmpty) {
      distanceText = distanceText.substring(0, distanceText.length - 3);
    }
    double distanceMile = double.parse(distanceText);
    double distanceKm = (distanceMile * 1.609);

    distance.value = distanceKm.toStringAsFixed(3);
    duration.value = durationText;
    polylinePoints.value = polyline;

    Get.back();
    incomingNewOrder();
    distanceCalculated.value = true;
    countDownController.value.start();
  }

  void determineUsersPosition() async {
    bool serviceEnabled;
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      origin.value = LatLng(position.latitude, position.longitude);
      final GoogleMapController controller =
          await googleMapController.value.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: origin.value, zoom: 19, tilt: 59)));
    }
  }

  void trackDriversLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? info) {
      if (info != null) {
        origin.value = LatLng(info.latitude, info.longitude);
      }
    });
  }

  void declineDeliveryRequest() {
    Get.back();
    distanceCalculated.value = false;
    countDownController.value.pause();
    stopSound();
  }

  void acceptDeliveryRequest() async {
    stopSound();
    Get.back();
    distanceCalculated.value = false;
    acceptedTheDelivery.value = true;
    final GoogleMapController controller =
        await googleMapController.value.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: -120, target: origin.value, zoom: 16, tilt: 32)));
    trackDriversLocation();
  }

  void changePage(int value) {
    pageController.value.animateToPage(
      value,
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceInOut,
    );
  }
}
