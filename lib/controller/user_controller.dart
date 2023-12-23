import 'dart:developer';

import 'package:Erdenet24/api/local_notification.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/screens/user/user_orders_detail_screen.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:get/get.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';

final _navCtx = Get.put(NavigationController());

class UserController extends GetxController {
  RxInt tab = 0.obs;
  RxInt page = 1.obs;
  RxList orders = [].obs;
  RxBool hasMore = true.obs;
  RxMap pagination = {}.obs;
  RxBool loading = false.obs;
  RxMap userInfo = {}.obs;

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

  void showNotification(id, title, body) {}

  void handleSentAction(Map payload) {
    LocalNotification.showSimpleNotification(
      id: payload["id"],
      title: payload["store"],
      body: "Таны захиалга баталгаажлаа",
    );
    Get.back();
    Get.back();
    _navCtx.onItemTapped(3);
    Get.bottomSheet(
      UserOrdersDetailScreen(
        id: payload["id"],
        orderId: payload["orderId"],
      ),
      backgroundColor: MyColors.white,
      isScrollControlled: true,
    );
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
    tab.value = 0;
    page.value = 1;
    orders.clear();
    hasMore.value = true;
    pagination.value = {};
    loading.value = false;
    getUserOrders();
    int index = orders.indexWhere((element) => element["id"] == payload["id"]);
    orders[index]["orderStatus"] = "preparing";
  }

  void handleDeliveringAction(Map payload) {
    LocalNotification.showSimpleNotification(
      id: payload["id"],
      title: payload["store"],
      body: "Таны захиалга хүргэлтэнд гарлаа",
    );
    tab.value = 0;
    page.value = 1;
    orders.clear();
    hasMore.value = true;
    pagination.value = {};
    loading.value = false;
    getUserOrders();
    int index = orders.indexWhere((element) => element["id"] == payload["id"]);
    orders[index]["orderStatus"] = "delivering";
  }

  void handleDeliveredAction(Map payload) {
    LocalNotification.showSimpleNotification(
      id: payload["id"],
      title: "Erdenet24",
      body: "Таны захиалга хүргэгдлээ",
    );
    tab.value = 0;
    page.value = 1;
    orders.clear();
    hasMore.value = true;
    pagination.value = {};
    loading.value = false;
    getUserOrders();
    int index = orders.indexWhere((element) => element["id"] == payload["id"]);
    orders[index]["orderStatus"] = "delivered";
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
    if (action == "delivered") {
      handleDeliveredAction(payload);
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
}
