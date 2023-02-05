import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../screens/driver/driver_bottom_views.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class DriverController extends GetxController {
  RxBool isActive = false.obs;
  RxInt step = 0.obs;
  Rx<LatLng> driverLocation = LatLng(49.02821126030273, 104.04634376483777).obs;
  Rx<LatLng> storeLocation = LatLng(49.02821126030273, 104.04634376483777).obs;
  RxList distanceAndDuration = [].obs;

  RxMap remoteMessageData = {}.obs;

  Rx<PageController> pageController = PageController().obs;

  Timer? countdownTimer;
  Duration myDuration = const Duration(hours: 3);
  Rx<Completer<GoogleMapController>> googleMapController =
      Completer<GoogleMapController>().obs;
  Rx<CountDownController> countDownController = CountDownController().obs;

  void turnedOnApp(value) async {
    isActive.value = value;
    if (value && await isLocationServiceEnabled()) {
      positionStreamForMap();
      positionStreamForServer();
      moveCamera(driverLocation.value);
    }
  }

  void getNewDelivery() async {
    distanceAndDuration.value =
        await getDistance(driverLocation.value, storeLocation.value);
    step.value = 1;
    countDownController.value.start();
    playSound("incoming");
  }

  //Controller Helpers
  Future<bool> isLocationServiceEnabled() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    return enabled;
  }

  void getCurrentLocation() async {
    var info = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    driverLocation.value = LatLng(info.latitude, info.longitude);
  }

  void positionStreamForMap() {
    LocationSettings locationSettingsForMap = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 3,
    );

    Geolocator.getPositionStream(locationSettings: locationSettingsForMap)
        .listen((Position? info) {
      log("forMap $info");
      driverLocation.value = LatLng(info!.latitude, info.longitude);
    });
  }

  void positionStreamForServer() {
    LocationSettings locationSettingsForServer = const LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 200,
    );
    Geolocator.getPositionStream(locationSettings: locationSettingsForServer)
        .listen((Position info) {
      log("forSrver: $info");
    });
  }

  void moveCamera(LatLng latLng) async {
    final GoogleMapController controller =
        await googleMapController.value.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 16, tilt: 59),
      ),
    );
  }

  Future<List<String>> getDistance(LatLng driver, LatLng store) async {
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
    return [distanceKm, durationText];
  }

  void setMarker(LatLng latLng, Set marKers, String type) async {
    BitmapDescriptor iconBitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/png/app/$type.png",
    );
    marKers.add(
      Marker(
        markerId: MarkerId(type),
        position: LatLng(
          latLng.latitude,
          latLng.longitude,
        ),
        icon: iconBitmap, //Icon for Marker
      ),
    );
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