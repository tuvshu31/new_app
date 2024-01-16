import 'dart:developer';

import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:get/get.dart';

class LifeCycleController extends SuperController {
  final _navCtx = Get.put(NavigationController());
  final _userCtx = Get.put(UserController());
  String role = RestApiHelper.getUserRole();
  @override
  void onDetached() {
    log("OnDetached!");
  }

  @override
  void onInactive() {
    log("OnIcactive!");
  }

  @override
  void onPaused() {
    if (socket.connected) {
      socket.disconnect();
    }
  }

  @override
  void onResumed() {
    if (socket.disconnected) {
      socket.connect();
    }
    if (role == "user") {
      if (Get.currentRoute == userHomeScreenRoute &&
          _navCtx.currentIndex.value == 3) {
        _userCtx.refreshOrders();
      }
    }
    if (role == "store") {}
  }
}
