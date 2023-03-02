import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/screens/user/user_cart_screen.dart';
import 'package:Erdenet24/screens/user/home/navigation_drawer.dart';
import 'package:Erdenet24/screens/user/home/search.dart';
import 'package:Erdenet24/screens/profile/profile.dart';
import 'package:Erdenet24/screens/user/user_saved_screen.dart';
import 'package:Erdenet24/screens/user/user_store_list_screen.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _navCtrl = Get.put(NavigationController());
  final _cartCtrl = Get.put(CartController());
  final _userCtx = Get.put(UserController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _cartCtrl.getUserProducts();
    Timer(const Duration(seconds: 1), () => testingVersionModal(context));
    _userCtx.getToken();

    _userCtx.getOrders();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var data = message.data;
      var jsonData = json.decode(data["data"]);
      log(jsonData.toString());
      var dataType = data["type"];
      if (dataType == "sent") {
      } else if (dataType == "received") {
      } else if (dataType == "preparing") {
      } else if (dataType == "delivering") {
      } else if (dataType == "delivered") {
      } else {}
    });
  }

  // void getUserInfo() async {
  //   loadingDialog(context);
  //   var query = {"id": RestApiHelper.getUserId()};
  //   dynamic res = await RestApi().getUsers(query);
  //   dynamic data = Map<String, dynamic>.from(res);
  //   log(data.toString());
  //   // setState(() {
  //   //   _user = data["data"][0];
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _body = [
      HomeScreen(leadingOnTap: _scaffoldKey),
      const UserStoreListScreen(),
      const UserCartScreen(),
      const UserSavedScreen(),
      const ProfileScreen()
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
              drawer: NavigationDrawer(),
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
