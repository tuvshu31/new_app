import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt currentIndex = 0.obs;
  Rx<PageController> searchViewController = PageController().obs;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  RxString title = "".obs;
  RxInt typeId = 0.obs;

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  void onItemTapped(int index) {
    currentIndex.value = index;
  }
}
