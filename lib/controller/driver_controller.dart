import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/driver/driver_screen_bottomsheet_views.dart';

class DriverController extends GetxController {
  RxString distance = "".obs;
  RxString duration = "".obs;
  RxList polylinePoints = [].obs;
  Rx<LatLng> origin = LatLng(49.028494366069474, 104.04692604155208).obs;
  Rx<LatLng> destination = LatLng(47.80950865994985, 106.81740772677611).obs;
  RxBool isDriverActive = false.obs;
  int waitingSeconds = 30;
  Timer? countdownTimer;
  Duration myDuration = const Duration(hours: 3);
  final Rx<Completer<GoogleMapController>> googleMapController =
      Completer<GoogleMapController>().obs;
  final Rx<CountDownController> countDownController = CountDownController().obs;

  final player = AudioPlayer();

  void playSound(type) async {
    player.play(AssetSource("sounds/$type.wav"));
  }

  void stopSound() async {
    player.stop();
  }

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
      // origin.value = LatLng(position.latitude, position.longitude);
      final GoogleMapController controller =
          await googleMapController.value.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: origin.value, zoom: 19, tilt: 59)));
    }
  }
}


  // LocationSettings locationSettings = const LocationSettings(
  //     accuracy: LocationAccuracy.high,
  //     distanceFilter: 50,
  //   );
     // Geolocator.getPositionStream(locationSettings: locationSettings)
      //     .listen((Position? info) {
      //   if (info != null) {
      //     origin.value = LatLng(info.latitude, info.longitude);
      //   }
      // });