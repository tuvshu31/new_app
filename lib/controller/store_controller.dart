import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/api/local_notification.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/screens/store/store_bottom_sheet_views.dart';
import 'package:Erdenet24/screens/store/store_order_details_screen.dart';

class StoreController extends GetxController with GetTickerProviderStateMixin {
  RxInt page = 1.obs;
  RxBool loading = false.obs;
  RxList orders = [].obs;
  RxBool hasMore = true.obs;
  RxBool isOpen = false.obs;
  RxMap pagination = {}.obs;
  RxInt tab = 0.obs;
  RxInt selectedTime = 0.obs;
  RxBool bottomSheetOpened = false.obs;
  RxBool tappingNotification = false.obs;
  late AnimationController animationController;
  Rx<AudioPlayer> player = AudioPlayer().obs;

  void getStoreOrders() async {
    loading.value = true;
    var query = {"page": page, "status": tab};
    dynamic getUserOrders = await StoreApi().getStoreOrders(query);
    loading.value = false;
    if (getUserOrders != null) {
      dynamic response = Map<String, dynamic>.from(getUserOrders);
      if (response["success"]) {
        List newOrders = response["data"];
        orders = orders + newOrders;
      }
      pagination.value = response["pagination"];
      if (pagination["pageCount"] > page.value) {
        hasMore.value = true;
      } else {
        hasMore.value = false;
      }
    }
  }

  Future<void> refreshOrders() async {
    loading.value = false;
    pagination.clear();
    page.value = 1;
    orders.clear();
    getStoreOrders();
  }

  void showNewOrderAlert(int id) {
    player.value.play(AssetSource("sounds/incoming.wav"));
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return showIncomingOrderDialogBody(() {
          LocalNotification.cancelLocalNotification(id: id);
          Get.back();
          Get.toNamed(storeOrdersScreenRoute);
          player.value.stop();
        });
      },
    );
  }

  Future<void> checkStoreNewOrders() async {
    dynamic checkStoreNewOrders = await StoreApi().checkStoreNewOrders();
    if (checkStoreNewOrders != null) {
      dynamic response = Map<String, dynamic>.from(checkStoreNewOrders);
      if (response["success"] && response["data"]) {
        tappingNotification.value = false;
        showNewOrderAlert(0);
      }
    }
  }

  void handleSocketActions(Map payload) async {
    String action = payload["action"];
    if (action == "delivering") {
      int index = orders.indexWhere((e) => e["id"] == payload["id"]);
      if (index > -1) {
        orders[index]["orderStatus"] = "delivering";
        orders.refresh();
      }
    } else if (action == "delivered") {
      int index = orders.indexWhere((e) => e["id"] == payload["id"]);
      if (index > -1) {
        orders[index]["orderStatus"] = "delivered";
        orders.removeAt(index);
        orders.refresh();
      }
    } else {
      refreshOrders();
      checkStoreNewOrders();
    }
  }

  Future<void> showOrderBottomSheet(Map item) {
    bottomSheetOpened.value = true;
    return Get.bottomSheet(
      StoreOrdersDetailScreen(item: item),
      backgroundColor: MyColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }

  void startPreparingOrder(Map item, int pickedTime) async {
    CustomDialogs().showLoadingDialog();
    dynamic startPreparingOrder =
        await StoreApi().startPreparingOrder(item["id"], pickedTime);
    Get.back();
    if (startPreparingOrder != null) {
      dynamic response = Map<String, dynamic>.from(startPreparingOrder);
      if (response["success"]) {
        refreshOrders();
      }
    }
  }

  void setToDelivery(Map item) async {
    CustomDialogs().showLoadingDialog();
    dynamic setToDelivery = await StoreApi().setToDelivery(item["id"]);
    Get.back();
    if (setToDelivery != null) {
      dynamic response = Map<String, dynamic>.from(setToDelivery);
      if (response["success"]) {
        refreshOrders();
      }
    } else {
      customSnackbar(ActionType.error, "Алдаа гарлаа", 3);
    }
  }
}
