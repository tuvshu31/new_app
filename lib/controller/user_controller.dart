import 'dart:async';
import 'dart:developer';

import 'package:Erdenet24/api/local_notification.dart';
import 'package:Erdenet24/api/socket_instance.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/screens/user/user_orders_detail_screen.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final _navCtx = Get.put(NavigationController());

class UserController extends GetxController {
  RxInt tab = 0.obs;
  RxInt page = 1.obs;
  RxList orders = [].obs;
  RxBool hasMore = true.obs;
  RxMap pagination = {}.obs;
  RxBool loading = false.obs;
  RxMap userInfo = {}.obs;
  List categories = [].obs;
  Map selectedOrder = {}.obs;
  RxBool bottomSheetOpened = false.obs;
  RxDouble markerRotation = 0.0.obs;
  Rx<LatLng> markerPosition = LatLng(49.02780344669333, 104.04736389691942).obs;
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();

  void getUserOrders() async {
    loading.value = true;
    var query = {"page": page.value, "status": tab.value};
    dynamic getUserOrders = await UserApi().getUserOrders(query);
    loading.value = false;
    if (getUserOrders != null) {
      dynamic response = Map<String, dynamic>.from(getUserOrders);
      if (response["success"]) {
        orders = orders + response["data"];
      }
      pagination.value = response["pagination"];
      if (pagination["pageCount"] > page.value) {
        hasMore.value = true;
      } else {
        hasMore.value = false;
      }
    }
  }

  void handleSentAction(Map payload) {
    LocalNotification.showSimpleNotification(
      id: payload["id"],
      title: payload["storeName"],
      body: "Таны захиалга баталгаажлаа",
    );
    Get.back();
    Get.back();
    _navCtx.onItemTapped(3);
    showOrderDetailsBottomSheet(payload);
    tab.value = 0;
    page.value = 1;
    orders.clear();
    hasMore.value = true;
    pagination.value = {};
    loading.value = false;
    getUserOrders();
  }

  void handlePreparingAction(Map payload) {
    LocalNotification.showSimpleNotification(
      id: payload["id"],
      title: payload["store"],
      body: "Таны захиалгыг бэлдэж эхэллээ",
    );
    int index = orders.indexWhere((element) => element["id"] == payload["id"]);
    orders[index]["orderStatus"] = "preparing";
    orders[index]["prepDuration"] = payload["prepDuration"];
    orders[index]["updatedTime"] = payload["updatedTime"];
    orders.refresh();
    if (bottomSheetOpened.value) {
      Get.back();
      showOrderDetailsBottomSheet(orders[index]);
    }
  }

  void handleDeliveringAction(Map payload) {
    LocalNotification.showSimpleNotification(
      id: payload["id"],
      title: payload["store"],
      body: "Таны захиалга хүргэлтэнд гарлаа",
    );
    int index = orders.indexWhere((element) => element["id"] == payload["id"]);
    orders[index]["orderStatus"] = "delivering";
    orders[index]["updatedTime"] = payload["updatedTime"];
    orders.refresh();
    if (bottomSheetOpened.value) {
      Get.back();
      showOrderDetailsBottomSheet(orders[index]);
    }
  }

  Future<void> handleTrackingAction(Map payload) async {
    markerRotation.value = payload["heading"] ?? 0;
    double latitude = payload["latitude"] ?? 49.02780344669333;
    double longitude = payload["longitude"] ?? 104.04736389691942;
    markerPosition.value = LatLng(latitude, longitude);
    final GoogleMapController controller = await googleMapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 192.8334901395799,
          target: markerPosition.value,
          zoom: 14.4746,
        ),
      ),
    );
  }

  void handleDeliveredAction(Map payload) {
    LocalNotification.showSimpleNotification(
      id: payload["id"],
      title: "Erdenet24",
      body: "Таны захиалга амжилттай хүргэгдлээ",
    );
    int index = orders.indexWhere((e) => e["id"] == payload["id"]);
    orders.removeAt(index);
    if (bottomSheetOpened.value) {
      Get.back();
    }
  }

  void handleSocketActions(Map payload) async {
    String action = payload["action"];
    if (action == "sent") {
      handleSentAction(payload);
    }
    if (action == "preparing") {
      handlePreparingAction(payload);
    }
    if (action == "delivering") {
      handleDeliveringAction(payload);
    }
    if (action == "tracking") {
      handleTrackingAction(payload);
    }
    if (action == "delivered") {
      handleDeliveredAction(payload);
    }
  }

  void getMainCategories() async {
    dynamic getMainCategories = await UserApi().getMainCategories();
    dynamic response = Map<String, dynamic>.from(getMainCategories);
    if (response["success"]) {
      categories = response["data"];
    }
  }

  void getUserInfoDetails() async {
    dynamic getUserInfoDetails = await UserApi().getUserInfoDetails();
    if (getUserInfoDetails != null) {
      dynamic response = Map<String, dynamic>.from(getUserInfoDetails);
      if (response["success"]) {
        userInfo.value = response["data"];
        log(userInfo.toString());
      }
    }
  }

  void checkUserSocketConnection() async {
    dynamic checkUserSocketConnection =
        await UserApi().checkUserSocketConnection();
    if (checkUserSocketConnection != null) {
      dynamic response = Map<String, dynamic>.from(checkUserSocketConnection);
      if (response["success"]) {
        if (response["connect"]) {
          SocketClient().connect();
        } else {
          SocketClient().disconnect();
        }
      }
    }
  }

  Future<void> showOrderDetailsBottomSheet(Map item) {
    bottomSheetOpened.value = true;
    return Get.bottomSheet(
      UserOrdersDetailScreen(item: item),
      backgroundColor: MyColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      enableDrag: false,
    );
  }
}
