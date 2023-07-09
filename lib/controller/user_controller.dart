import 'dart:async';
import 'dart:developer';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final _cartCtx = Get.put(CartController());
final _navCtx = Get.put(NavigationController());

class UserController extends GetxController {
  Rx<bool> isAppBackground = false.obs;
  Rx<AppLifecycleState> appStatus = AppLifecycleState.paused.obs;
  Rx<PageController> activeOrderPageController = PageController().obs;
  RxList userOrderList = [].obs;
  RxList filteredOrderList = [].obs;
  RxInt prepDuration = 1.obs;
  RxBool loading = false.obs;
  RxDouble markerRotation = 0.0.obs;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  Rx<LatLng> driverPosition = LatLng(49.02821126030273, 104.04634376483777).obs;
  Rx<Completer<GoogleMapController>> mapController =
      Completer<GoogleMapController>().obs;
  RxInt activeStep = 0.obs;

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
        await getBytesFromAsset('assets/images/png/app/driver.png', 100);
    Marker marker = Marker(
      markerId: markerId,
      position: driverPosition.value,
      icon: BitmapDescriptor.fromBytes(markerIcon),
      rotation: markerRotation.value,
    );
    markers[markerId] = marker;
  }

  String statusText(int step) {
    return step == 1
        ? "Хүлээн авсан"
        : step == 2
            ? "Бэлдэж байна"
            : step == 3
                ? "Хүргэж байна"
                : step == 4
                    ? "Хүргэсэн"
                    : "";
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

  void userActiveOrderChangeView() {
    activeOrderPageController.value.animateToPage(
      activeStep.value,
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceInOut,
    );
  }

  void userActionHandler(action, payload) {
    if (action == "payment_success") {
      var body = {"orderStatus": "sent"};
      updateOrder(payload["id"], body);
      // saveActiveOrderIdAndNavigate(payload["id"], userOrdersActiveScreenRoute);
      _cartCtx.cartList.clear();
    } else if (action == "sent") {
    } else if (action == "received") {
      activeStep.value = 0;
      userActiveOrderChangeView();
    } else if (action == "preparing") {
      activeStep.value = 2;
      userActiveOrderChangeView();
      prepDuration.value = int.parse(payload["prepDuration"]);
      log(prepDuration.value.toString());
    } else if (action == "delivering") {
      activeStep.value = 3;
      userActiveOrderChangeView();
      fetchDriverPositionSctream(int.parse(payload["deliveryDriverId"]));
    } else if (action == "delivered") {
      userActiveOrderChangeView();
      _navCtx.onItemTapped(0);
    } else {}
  }
}
