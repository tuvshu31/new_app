import 'dart:async';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/notifications.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/network_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../screens/driver/driver_bottom_views.dart';

class DriverController extends GetxController {
  //=========================Driver states==================================
  RxInt step = 0.obs;
  RxBool isOnline = false.obs;
  RxMap remoteMessageData = {}.obs;
  RxMap deliveryInfo = {}.obs;
  RxString fcmToken = "".obs;
  RxMap lastDelivery = {}.obs;
  RxString todayDate = "".obs;
  RxList driverInfo = [].obs;
  RxList driverPayments = [].obs;
  RxInt todaysDeliveryCount = 0.obs;
  RxList orderList = [].obs;
  Rx<Stopwatch> stopwatch = Stopwatch().obs;

  RxString fakeDeliveryTimer = "".obs;

  //=========================Map states==================================
  RxString distanceAndDuration = "".obs;
  Rx<LatLng> storeLocation = LatLng(49.02821126030273, 104.04634376483777).obs;
  RxInt markerIdCounter = 0.obs;
  RxDouble markerRotation = 0.0.obs;
  Rx<LatLng> initialPosition =
      LatLng(49.02821126030273, 104.04634376483777).obs;
  Rx<Completer<GoogleMapController>> mapController =
      Completer<GoogleMapController>().obs;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  final _networkCtx = Get.put(NetWorkController());

  //=========================Map controllers==================================
  void getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    initialPosition.value = LatLng(position.latitude, position.longitude);
    CameraPosition currentCameraPosition = CameraPosition(
      bearing: 0,
      target: initialPosition.value,
      zoom: 16,
    );
    final GoogleMapController controller = await mapController.value.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition));
    markerRotation.value = position.heading;
    addDriverMarker();
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

      todayDate.value = DateTime.now().toString().substring(0, 10);
      List todayOrders = [];
      for (var element in orderList) {
        if (element["orderTime"].substring(0, 10) == todayDate.value) {
          todayOrders.add(element);
        }
      }
      lastDelivery.value = todayOrders.isNotEmpty ? todayOrders.last : {};
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
      for (var element in driverPayments) {
        if (element["date"] == DateTime.now().toString().substring(0, 10)) {
          todaysDeliveryCount.value = element["count"];
        }
      }
    }
  }

  void addDriverMarker() async {
    Future<Uint8List> getBytesFromAsset(String path, int width) async {
      ByteData data = await rootBundle.load(path);
      ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
          targetWidth: width);
      ui.FrameInfo fi = await codec.getNextFrame();
      return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
    }

    MarkerId markerId = const MarkerId("driver");
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/png/app/driver.png', 50);
    Marker marker = Marker(
      markerId: markerId,
      position: initialPosition.value,
      icon: BitmapDescriptor.fromBytes(markerIcon),
      rotation: markerRotation.value,
    );
    markers[markerId] = marker;
  }

  void addStoreMarker() async {
    BitmapDescriptor iconBitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/png/app/store.png",
    );
    MarkerId markerId = const MarkerId("store");
    Marker marker = Marker(
      markerId: markerId,
      position: storeLocation.value,
      icon: iconBitmap,
    );
    markers[markerId] = marker;
  }

  void onCameraMove(CameraPosition cameraPosition) {
    if (markers.isNotEmpty) {
      MarkerId markerId = const MarkerId("driver");
      Marker? marker = markers[markerId];
      Marker updatedMarker = marker!.copyWith(
        positionParam: cameraPosition.target,
      );
      markers[markerId] = updatedMarker;
    }
  }

  void getPositionStream() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      ),
    ).listen((Position? info) async {
      initialPosition.value = LatLng(info!.latitude, info.longitude);
      CameraPosition currentCameraPosition = CameraPosition(
        bearing: 0,
        target: initialPosition.value,
        zoom: 16,
      );
      markerRotation.value = info.heading;
      addDriverMarker();
      final GoogleMapController controller = await mapController.value.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition));
      var body = {
        "latitude": info.latitude.toString(),
        "longitude": info.longitude.toString(),
        "heading": info.heading.toString()
      };
      updateDriverInfo(body);
    });
  }

  void onMapCreated(GoogleMapController controller) async {
    mapController.value.complete(controller);
    Future.delayed(const Duration(seconds: 1), () async {
      GoogleMapController controller = await mapController.value.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: initialPosition.value,
            zoom: 17.0,
          ),
        ),
      );
    });
  }

  //=========================Driver controllers==================================
  void turnOnOff(value, context) async {
    if (_networkCtx.hasNetwork.value) {
      isOnline.value = value;
      if (value == true) {
        playSound("engine_start");
        getUserLocation();
        getPositionStream();
        startActiveTimer(10800, context);
      } else {
        // stopActiveTimer();
        stopSound();
      }
      var body = {"isOpen": value};
      updateDriverInfo(body);
    } else {
      _networkCtx.showNetworkSnackbar(context);
    }
  }

  void fetchDriverInfo(context) async {
    dynamic response = await RestApi().getDriver(RestApiHelper.getUserId());
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      driverInfo.value = d["data"];
      isOnline.value = d["data"][0]["isOpen"];
      if (isOnline.value) {
        turnOnOff(true, context);
      }
    }
  }

  void updateDriverInfo(dynamic body) async {
    dynamic user =
        await RestApi().updateDriver(RestApiHelper.getUserId(), body);
    dynamic data = Map<String, dynamic>.from(user);
  }

  void cancelNewDelivery() async {
    step.value = 0;
    stopwatch.value.stop();
    stopSound();
    removeMarker("store");
    List canceledDrivers = json.decode(deliveryInfo["canceledDrivers"]);
    canceledDrivers.add(RestApiHelper.getUserId());
    var body = {
      "orderId": int.parse(deliveryInfo['orderId']),
      "canceledDrivers": canceledDrivers
    };
    dynamic response = await RestApi().assignDriver(body);
    dynamic d = Map<String, dynamic>.from(response);

    if (d["success"]) {
      step.value = 0;
      deliveryInfo.clear();
    }
  }

  void finishDelivery() {
    RestApiHelper.saveOrderId(0);
    RestApiHelper.saveOrderInfo({});
    orderList.clear();
    driverPayments.clear();
    fetchDriverOrders();
    fetchDriverPayments();
    step.value = 0;
    removeMarker("store");
    deliveryInfo.clear();
  }

  Future<void> checkIfDriverKilled() async {
    log(RestApiHelper.getOrderId().toString());
    log(RestApiHelper.getOrderInfo().toString());

    if (RestApiHelper.getOrderId() != 0) {
      if (RestApiHelper.getOrderInfo().isEmpty) {
        log("blank");
        step.value = 0;
        var body = {"orderStatus": "canceled"};
        int id = RestApiHelper.getOrderId();
        dynamic response = await RestApi().updateOrder(id, body);
        dynamic d = Map<String, dynamic>.from(response);
      }
      if (RestApiHelper.getOrderInfo().isNotEmpty) {
        log("notBlank");
        deliveryInfo.value = RestApiHelper.getOrderInfo();
        step.value = 2;
      }
    }
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

  void removeMarker(String type) {
    markers.removeWhere(
      (key, value) => value.markerId == MarkerId(type),
    );
  }

  // void driverNotifications(action, payload, isBackground) async {
  //   if (action == "new_order") {
  //     // createCustomNotification(
  //     //   isBackground,
  //     //   payload,
  //     //   isVisible: true,
  //     //   customSound: true,
  //     //   isCall: true,
  //     //   body: "Шинэ захиалга ирлээ",
  //     // );
  //   }
  // }

  void driverActionHandler(action, payload) async {
    if (action == "new_order") {
      deliveryInfo.clear();
      deliveryInfo.value = payload;
      storeLocation.value = LatLng(
        double.parse(deliveryInfo["latitude"]),
        double.parse(deliveryInfo["longitude"]),
      );
      addStoreMarker();
      getDistance(initialPosition.value, storeLocation.value);
      step.value = 1;
      playSound("incoming");
    }
  }

  void isOpenAndIsCLose(int id) async {
    var body = {"isOpen": id};
    await RestApi().updateUser(RestApiHelper.getUserId(), body);
  }

  void updateOrder(dynamic body) async {
    dynamic response =
        await RestApi().updateOrder(int.parse(deliveryInfo["id"]), body);
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

//time controller====================

  Timer? _activeTimer;
  int remainingSeconds = 0;
  final time = '00.00'.obs;

  void stopActiveTimer() {
    _activeTimer!.cancel();
  }

  void startActiveTimer(int seconds, context) {
    const duration = Duration(seconds: 1);
    remainingSeconds = seconds;
    _activeTimer = Timer.periodic(duration, (Timer timer) {
      if (remainingSeconds == 0) {
        turnOnOff(false, context);
        timer.cancel();
      } else {
        int hours = remainingSeconds ~/ 3600;
        int minutes = remainingSeconds ~/ 60 % 60;
        int seconds = (remainingSeconds % 60);
        time.value = hours.toString().padLeft(2, "0") +
            ":" +
            minutes.toString().padLeft(2, "0") +
            ":" +
            seconds.toString().padLeft(2, "0");
        remainingSeconds--;
      }
    });
  }
}
