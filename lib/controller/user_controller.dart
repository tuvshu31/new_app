import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/api/notifications.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/screens/user/user_home_screen.dart';
import 'package:Erdenet24/screens/user/user_orders_active_screen.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserController extends GetxController {
  RxInt activeOrderStep = 0.obs;
  Rx<PageController> activeOrderPageController = PageController().obs;
  RxList userOrderList = [].obs;
  RxList filteredOrderList = [].obs;
  RxBool loading = false.obs;
  RxDouble markerRotation = 0.0.obs;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  Rx<LatLng> driverPosition = LatLng(49.02821126030273, 104.04634376483777).obs;
  Rx<Completer<GoogleMapController>> mapController =
      Completer<GoogleMapController>().obs;

  void getOrders() async {
    loading.value = true;
    var body = {"userId": RestApiHelper.getUserId()};
    dynamic response = await RestApi().getOrders(body);
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      userOrderList.value = d["data"];
    }
    loading.value = false;
  }

  void getCurrentOrderInfo(int orderId) async {
    loading.value = true;
    var body = {"id": orderId};
    dynamic response = await RestApi().getOrders(body);
    dynamic d = Map<String, dynamic>.from(response);
    log(d.toString());
    if (d["success"]) {
      userOrderList.value = d["data"];
    }
    loading.value = false;
  }

  void filterOrders(String status) {
    filteredOrderList.value =
        userOrderList.where((p0) => p0["orderStatus"] == status).toList();
  }

  void fetchDriverPositionSctream(int driverId) {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      dynamic response = await RestApi().getDriver(driverId);
      dynamic d = Map<String, dynamic>.from(response);
      if (d["success"]) {
        markerRotation.value = double.parse(d["data"][0]["heading"]);
        driverPosition.value = LatLng(double.parse(d["data"][0]["latitude"]),
            double.parse(d["data"][0]["longitude"]));
      }
      CameraPosition currentCameraPosition = CameraPosition(
        bearing: 0,
        target: driverPosition.value,
        zoom: 16,
      );
      addDriverMarker();
      final GoogleMapController controller = await mapController.value.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition));
    });
  }

  void addDriverMarker() async {
    BitmapDescriptor iconBitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/png/app/driver.png",
    );
    MarkerId markerId = const MarkerId("driver");
    Marker marker = Marker(
      markerId: markerId,
      position: driverPosition.value,
      icon: iconBitmap,
      rotation: markerRotation.value,
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

  void onMapCreated(GoogleMapController controller) async {
    mapController.value.complete(controller);
    Future.delayed(const Duration(seconds: 1), () async {
      GoogleMapController controller = await mapController.value.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: driverPosition.value,
            zoom: 17.0,
          ),
        ),
      );
      addDriverMarker();
    });
  }

  void updateOrder(int id, dynamic body) async {
    dynamic response = await RestApi().updateOrder(id, body);
    dynamic d = Map<String, dynamic>.from(response);
    log(d.toString());
  }

  void userNotifications(action, payload) {
    if (action == "payment_success") {
      createCustomNotification(
        payload,
        isVisible: true,
        customSound: false,
        body: "Захиалгын төлбөр амжилттай төлөгдлөө",
      );
    } else if (action == "sent") {
      createCustomNotification(
        payload,
        isVisible: false,
        customSound: false,
        body: "Захиалгыг хүлээн авлаа",
      );
    } else if (action == "received") {
      createCustomNotification(
        payload,
        isVisible: true,
        customSound: false,
        body: "Таны захиалгыг хүлээн авлаа",
      );
    } else if (action == "preparing") {
      createCustomNotification(
        payload,
        isVisible: true,
        customSound: false,
        body: "Таны захиалгыг бэлтгэж эхэллээ",
      );
    } else if (action == "delivering") {
      createCustomNotification(
        payload,
        isVisible: true,
        customSound: false,
        body: "Таны захиалга хүргэлтэнд гарлаа",
      );
    } else if (action == "delivered") {
      createCustomNotification(
        payload,
        isVisible: true,
        customSound: false,
        body:
            "Таны захиалга амжилттай хүргэгдлээ. Манайхаар үйлчилүүлсэнд баярлалаа",
      );
    } else {
      log(payload.toString());
    }
  }

  void userActiveOrderChangeView(int activeStep) {
    activeOrderStep.value = activeStep;
    activeOrderPageController.value.animateToPage(
      activeOrderStep.value,
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceInOut,
    );
  }

  void userNotificationDataHandler(action, payload) {
    if (action == "payment_success") {
      successOrderModal(
        MyApp.navigatorKey.currentContext,
        () async {
          var body = {"orderStatus": "sent"};
          updateOrder(payload["id"], body);
          RestApiHelper.saveOrderId(payload["id"]);
          Get.off(() => const UserOrderActiveScreen());
        },
      );
    } else if (action == "sent") {
      log(payload.toString());
    } else if (action == "received") {
      userActiveOrderChangeView(1);
    } else if (action == "preparing") {
      userActiveOrderChangeView(2);
    } else if (action == "delivering") {
      userActiveOrderChangeView(3);
      var jsonData = json.decode(payload);
      fetchDriverPositionSctream(int.parse(jsonData["deliveryDriverId"]));
    } else if (action == "delivered") {
      Get.to(() => const UserHomeScreen());
      RestApiHelper.saveOrderId(0);
    } else {}
  }
}
