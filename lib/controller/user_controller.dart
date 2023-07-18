import 'dart:async';
import 'dart:developer';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/screens/user/user_profile_orders_detail_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_orders_screen.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_controller.dart';
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
  RxBool fetchingOrderList = false.obs;
  RxInt prepDuration = 1.obs;
  RxDouble markerRotation = 0.0.obs;
  RxMap selectedOrder = {}.obs;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  Rx<LatLng> driverPosition = LatLng(49.02821126030273, 104.04634376483777).obs;
  Rx<Completer<GoogleMapController>> mapController =
      Completer<GoogleMapController>().obs;

  void getOrders() async {
    fetchingOrderList.value = true;
    var body = {"userId": RestApiHelper.getUserId()};
    dynamic response = await RestApi().getOrders(body);
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      userOrderList.value = d["data"];
      userOrderList.value = userOrderList.reversed.toList();
      filterOrders(0);
    }
    fetchingOrderList.value = false;
  }

  void filterOrders(int value) {
    if (value == 0) {
      filteredOrderList.value = userOrderList
          .where(
            (p0) =>
                p0["orderStatus"] != "delivered" &&
                p0["orderStatus"] != "canceled" &&
                p0["orderStatus"] != "notPaid",
          )
          .toList();
    } else if (value == 1) {
      filteredOrderList.value = userOrderList
          .where((p0) => p0["orderStatus"] == "delivered")
          .toList();
    } else if (value == 2) {
      filteredOrderList.value =
          userOrderList.where((p0) => p0["orderStatus"] == "canceled").toList();
    }
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

  void changeOrderStatus(Map payload) async {
    int id = payload["id"];
    String status = payload["orderStatus"];
    if (userOrderList.any((e) => e["id"] == id)) {
      int k = userOrderList.indexWhere((k) => k["id"] == id);
      userOrderList[k]["orderStatus"] = status;
    } else {
      userOrderList.add(payload);
    }
    if (filteredOrderList.any((e) => e["id"] == id)) {
      int i = filteredOrderList.indexWhere((e) => e["id"] == id);
      filteredOrderList[i]["orderStatus"] = status;
    } else {
      filteredOrderList.add(payload);
    }
    if (selectedOrder.isNotEmpty && selectedOrder["id"] == id) {
      selectedOrder["orderStatus"] = status;
    }
    userOrderList.refresh();
    filteredOrderList.refresh();
  }

  void userActionHandler(action, payload) {
    log(payload.toString());
    if (action == "sent") {
      _cartCtx.cartList.clear();
      _cartCtx.cartItemCount.value = 0;
      _navCtx.onItemTapped(4);
      Get.offNamed(userProfileOrdersScreenRoute);
      changeOrderStatus(payload);
      selectedOrder.value = payload;
      showOrderDetails();
    } else if (action == "received") {
      changeOrderStatus(payload);
    } else if (action == "preparing") {
      prepDuration.value = int.parse(payload["prepDuration"]);
      changeOrderStatus(payload);
    } else if (action == "delivering") {
      changeOrderStatus(payload);
      fetchDriverPositionSctream(int.parse(payload["deliveryDriverId"]));
    } else if (action == "delivered") {
      changeOrderStatus(payload);
    } else {}
  }

  void showOrderDetails() {
    showModalBottomSheet(
      backgroundColor: MyColors.white,
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) {
        return const UserProfileOrdersDetailScreen();
      },
    );
  }
}
