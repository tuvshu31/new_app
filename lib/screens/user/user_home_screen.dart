import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/screens/user/user_cart_screen.dart';
import 'package:Erdenet24/screens/user/user_orders_screen.dart';
import 'package:Erdenet24/screens/user/user_navigation_drawer_screen.dart';
import 'package:Erdenet24/screens/user/user_saved_screen.dart';
import 'package:Erdenet24/screens/user/user_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen>
    with WidgetsBindingObserver {
  final _navCtrl = Get.put(NavigationController());
  final _loginCtx = Get.put(LoginController());
  final _userCtx = Get.put(UserController());
  final _storeCtx = Get.put(StoreController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loginCtx.saveUserToken();
    _userCtx.getUserInfoDetails();
    _loginCtx.checkUserDeviceInfo();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (socket.disconnected) {
        socket.connect();
        _userCtx.refreshOrders();
      }
    }
    if (state == AppLifecycleState.paused) {
      if (socket.connected) {
        socket.disconnect();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [
      const UserSearchScreen(),
      const UserSavedScreen(),
      const UserCartScreen(),
      const UserOrdersScreen(),
    ];

    return Obx(
      () => SafeArea(
        top: false,
        bottom: false,
        maintainBottomViewPadding: false,
        child: GestureDetector(
          onTap: () => {
            FocusManager.instance.primaryFocus?.unfocus(),
          },
          child: Scaffold(
            key: _navCtrl.scaffoldKey,
            drawer: const UserNavigationDrawerScreen(),
            resizeToAvoidBottomInset: false,
            body: widgets[_navCtrl.currentIndex.value],
            bottomNavigationBar: _bottomNavigationBar(),
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.search),
            label: 'Хайх',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.star),
            label: 'Хадгалсан',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.buy),
            label: "Сагс",
          ),
          BottomNavigationBarItem(
            icon: Icon(IconlyLight.bag_2),
            label: 'Захиалгууд',
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
