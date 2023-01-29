import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverController extends GetxController {
  RxBool hasMapData = false.obs;
  RxString distance = "".obs;
  RxString duration = "".obs;
  RxList polylinePoints = [].obs;
  Rx<LatLng> origin = LatLng(49.028494366069474, 104.04692604155208).obs;
  Rx<LatLng> destination = LatLng(47.80950865994985, 106.81740772677611).obs;

  final player = AudioPlayer();

  void playSound(type) async {
    player.play(AssetSource("sounds/$type.wav"));
  }

  void stopSound() async {
    player.stop();
  }

  void calculateDistance() async {
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

    if (distanceText != null && distanceText.isNotEmpty) {
      distanceText = distanceText.substring(0, distanceText.length - 3);
    }
    double distanceMile = double.parse(distanceText);
    double distanceKm = (distanceMile * 1.609);

    distance.value = distanceKm.toStringAsFixed(3);
    duration.value = durationText;
    polylinePoints.value = polyline;
    hasMapData.value = parsed.isNotEmpty;
  }

  void determineUsersPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );
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
    var position = await Geolocator.getCurrentPosition();
    origin.value = LatLng(position.latitude, position.longitude);
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? info) {
      if (info != null) {
        origin.value = LatLng(info.latitude, info.longitude);
      }
    });
  }
}
