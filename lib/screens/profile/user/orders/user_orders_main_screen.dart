import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/screens/profile/user/orders/user_orders_delivered_screen.dart';

class UserOrdersMainScreen extends StatefulWidget {
  const UserOrdersMainScreen({super.key});

  @override
  State<UserOrdersMainScreen> createState() => _UserOrdersMainScreenState();
}

class _UserOrdersMainScreenState extends State<UserOrdersMainScreen> {
  PageController pageController = PageController();
  final _userCtx = Get.put(UserController());
  @override
  void initState() {
    super.initState();
    _userCtx.filterOrders("delivered");
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      withTabBar: true,
      title: "Захиалгууд",
      customActions: Container(),
      body: Column(
        children: [
          DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: TabBar(
              onTap: ((value) {
                pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.bounceInOut,
                );
                var status = value == 0 ? "delivered" : "cancelled";
                _userCtx.filterOrders(status);
              }),
              labelColor: MyColors.primary,
              unselectedLabelColor: MyColors.black,
              indicatorColor: MyColors.primary,
              tabs: const [
                Tab(text: "Хүргэгдсэн"),
                Tab(text: "Цуцлагдсан"),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: const [
                UserOrdersListScreen(),
                UserOrdersListScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
