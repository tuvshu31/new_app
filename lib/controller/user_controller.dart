import 'dart:async';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/screens/user/user_orders_detail_screen.dart';

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
  Completer<GoogleMapController> googleMapController =
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

  void refreshOrders() {
    orders.clear();
    loading.value = false;
    pagination.value = {};
    hasMore.value = false;
    getUserOrders();
  }

  Future<void> getDriverPositionStream(int orderId) async {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (!bottomSheetOpened.value) {
        timer.cancel();
      }
      dynamic getDriverPositionStream =
          await UserApi().getDriverPositionStream(orderId);
      if (getDriverPositionStream != null) {
        dynamic response = Map<String, dynamic>.from(getDriverPositionStream);
        if (response["success"]) {
          String heading = response["data"]["heading"] ?? "0";
          String latitude =
              response["data"]["latitude"] ?? "49.02780344669333;";
          String longitude =
              response["data"]["longitude"] ?? "104.04736389691942";
          markerRotation.value = double.parse(heading);
          markerPosition.value =
              LatLng(double.parse(latitude), double.parse(longitude));
          final GoogleMapController controller =
              await googleMapController.future;
          await controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                bearing: markerRotation.value,
                target: markerPosition.value,
                zoom: 14.4746,
              ),
            ),
          );
        }
      }
    });
  }

  void handleSocketActions(Map payload) async {
    if (Get.currentRoute == userHomeScreenRoute &&
        _navCtx.currentIndex.value == 3) {
      if (bottomSheetOpened.value) {
        Get.back();
      }
      refreshOrders();
      showOrderDetailsBottomSheet(payload);
    }
    if (Get.currentRoute == userPaymentScreenRoute) {
      CustomDialogs().showLoadingDialog();
      dynamic checkQpayPayment = await UserApi().checkQpayPayment();
      Get.back();
      if (checkQpayPayment != null) {
        dynamic response = Map<String, dynamic>.from(checkQpayPayment);
        if (response["success"]) {
          if (response["isPaid"]) {
            Get.back();
            Get.back();
            _navCtx.onItemTapped(3);
          }
        }
      }
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

  void checkQpayPayment() async {
    final navCtx = Get.put(NavigationController());
    CustomDialogs().showLoadingDialog();
    dynamic checkQpayPayment = await UserApi().checkQpayPayment();
    Get.back();
    if (checkQpayPayment != null) {
      dynamic response = Map<String, dynamic>.from(checkQpayPayment);
      if (response["success"]) {
        if (response["isPaid"]) {
          Get.back();
          Get.back();
          navCtx.currentIndex.value = 3;
          Get.offNamed(userHomeScreenRoute);
        }
      }
    }
  }
}
