import 'dart:async';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/notifications.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/screens/user/user_cart_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_screen.dart';
import 'package:Erdenet24/screens/user/user_navigation_drawer_screen.dart';
import 'package:Erdenet24/screens/user/user_saved_screen.dart';
import 'package:Erdenet24/screens/user/user_search_screen.dart';
import 'package:Erdenet24/screens/user/user_store_list_screen.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _navCtrl = Get.put(NavigationController());
  final _cartCtrl = Get.put(CartController());
  final _userCtx = Get.put(UserController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _cartCtrl.getUserProducts();
    saveUserToken();
    _userCtx.getOrders();
  }

  void saveUserToken() async {
    await FirebaseMessaging.instance.deleteToken();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    var body = {"mapToken": fcmToken};
    await RestApi().updateUser(RestApiHelper.getUserId(), body);
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      var body = {"mapToken": newToken};
      await RestApi().updateUser(RestApiHelper.getUserId(), body);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _body = [
      UserSearchScreen(leadingOnTap: _scaffoldKey),
      const UserStoreListScreen(),
      const UserCartScreen(),
      const UserSavedScreen(),
      const UserProfileScreen()
    ];

    return Obx(
      () => Container(
        color: MyColors.white,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => {
              FocusManager.instance.primaryFocus?.unfocus(),
            },
            child: Scaffold(
              key: _scaffoldKey,
              drawer: const UserNavigationDrawerScreen(),
              resizeToAvoidBottomInset: false,
              backgroundColor: MyColors.black,
              body: _body[_navCtrl.currentIndex.value],
              bottomNavigationBar: _bottomNavigationBar(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomNavigationBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: MyColors.white,
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.search),
            label: 'Хайх',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.bag),
            label: 'Дэлгүүр',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.buy),
            label: 'Сагс',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.star),
            label: 'Хадгалсан',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.profile),
            label: 'Профайл',
          ),
        ],
        currentIndex: _navCtrl.currentIndex.value,
        selectedItemColor: MyColors.primary,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        iconSize: 20,
        unselectedItemColor: MyColors.black,
        elevation: 0,
        onTap: (index) => _navCtrl.onItemTapped(index),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
