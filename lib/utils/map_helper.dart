import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LocationPermission> checkPermission() async {
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
  return permission;
}

Future<Map<String, dynamic>> calculateDistance(
    LatLng point1, LatLng point2) async {
  const String baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  final respose = await Dio().get(baseUrl, queryParameters: {
    "origin": "${point1.latitude}, ${point1.longitude}",
    "destination": "${point2.latitude}, ${point2.longitude}",
    "key": "AIzaSyAHTYs2cMm87YH3wppr6wTtKRZxfyXjvB4"
  });
  final Map parsed = json.decode(respose.toString());
  String distanceText = parsed["routes"][0]["legs"][0]["distance"]["text"];
  String durationText = parsed["routes"][0]["legs"][0]["duration"]["text"];
  distanceText = distanceText.substring(0, distanceText.length - 3);
  double distanceMile = double.parse(distanceText);
  String distanceKm = (distanceMile * 1.609).toStringAsFixed(3);
  return {
    "distance": distanceKm,
    "duration": durationText,
  };
}

Future<LatLng> findCurrentLocation() async {
  var info = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return LatLng(info.latitude, info.longitude);
}

Position? trackTheLocationForMap() {
  Position? data;
  LocationSettings locationSettingsForMap = const LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 3,
  );
  Geolocator.getPositionStream(locationSettings: locationSettingsForMap)
      .listen((Position? info) {
    data = info;
  });
  return data;
}

Position? trackTheLocationForServer() {
  Position? data;
  LocationSettings locationSettingsForServer = const LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 200,
  );
  Geolocator.getPositionStream(locationSettings: locationSettingsForServer)
      .listen((Position info) {
    data = info;
  });
  return data;
}
