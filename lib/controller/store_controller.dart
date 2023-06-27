import 'dart:async';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/screens/store/store_orders_bottom_sheets.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  RxList storeOrderList = [].obs;
  RxMap storeInfo = {}.obs;
  RxList filteredOrderList = [].obs;
  RxBool fetching = false.obs;
  RxString orderStatus = "".obs;
  RxInt prepDuration = 0.obs;
  Timer? countdownTimer;
  RxList prepDurationList = [].obs;
  RxBool driverAccepted = false.obs;

  final player = AudioPlayer();

  void playSound(type, {bool loop = false}) async {
    player.play(AssetSource("sounds/$type.wav"), volume: 100);
    if (loop) {
      player.onPlayerComplete.listen((event) {
        player.play(
          AssetSource("sounds/$type.wav"),
        );
      });
    }
  }

  void stopSound() async {
    player.stop();
  }

  void startTimer(Duration i) {
    prepDurationList.add(i);
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      const reduceSecondsBy = 1;
      final seconds = prepDurationList.last.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        prepDurationList.last = Duration(seconds: seconds);
      }
    });
  }

  void fetchStoreInfo() async {
    fetching.value = true;
    dynamic res1 = await RestApi().getUser(RestApiHelper.getUserId());
    dynamic data1 = Map<String, dynamic>.from(res1);
    if (data1["success"]) {
      storeInfo.value = data1["data"];
    }

    dynamic res2 =
        await RestApi().getStoreOrders(RestApiHelper.getUserId(), {});
    dynamic data2 = Map<String, dynamic>.from(res2);
    if (data2["success"]) {
      storeOrderList.value = reversedArray(data2["data"]);
    }
    fetching.value = false;
  }

  void updateStoreInfo(body, context, successMsg, errorMsg) async {
    dynamic user = await RestApi().updateUser(RestApiHelper.getUserId(), body);
    dynamic data = Map<String, dynamic>.from(user);
    if (data["success"]) {
      successSnackBar(successMsg, 2, context);
    } else {
      errorSnackBar(errorMsg, 2, context);
    }
  }

  void filterOrders(int value) {
    filteredOrderList.clear();
    if (value == 0) {
      filteredOrderList.value = storeOrderList
          .where((p0) =>
              p0["orderStatus"] == "received" ||
              p0["orderStatus"] == "preparing")
          .toList();
    }
    if (value == 1) {
      filteredOrderList.value = storeOrderList
          .where((p0) => p0["orderStatus"] == "delivering")
          .toList();
    }
    if (value == 2) {
      filteredOrderList.value = storeOrderList
          .where((p0) => p0["orderStatus"] == "delivered")
          .toList();
    }
  }

  void updateOrder(int id, dynamic body) async {
    await RestApi().updateOrder(id, body);
  }

  void storeActionHandler(action, payload) {
    if (action == "payment_success") {
    } else if (action == "sent") {
      saveIcomingOrder(navigatorKey.currentContext, payload);
      showIncomingOrderDialog(navigatorKey.currentContext);
    } else if (action == "received") {
    } else if (action == "driverAccepted") {
      Get.back();
      driverAccepted.value = true;
    } else if (action == "preparing") {
    } else if (action == "delivering") {
      for (dynamic i in storeOrderList) {
        if (i["id"] == payload["id"]) {
          i["orderStatus"] = "delivering";
        }
      }
      filterOrders(0);
    } else if (action == "delivered") {
      driverAccepted.value = false;
      for (dynamic i in storeOrderList) {
        if (i["id"] == payload["id"]) {
          i["orderStatus"] = "delivered";
        }
      }
      filterOrders(0);
    } else if (action == "canceled") {
      driverAccepted.value = false;
    } else {}
  }
}
