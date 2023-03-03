import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/screens/store/orders/store_orders_new_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:get/get.dart';

class StoreOrdersMainScreen extends StatefulWidget {
  const StoreOrdersMainScreen({super.key});

  @override
  State<StoreOrdersMainScreen> createState() => _StoreOrdersMainScreenState();
}

class _StoreOrdersMainScreenState extends State<StoreOrdersMainScreen> {
  PageController pageController = PageController();
  final _storeCtx = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      withTabBar: true,
      title: "Захиалгууд",
      customActions: Container(),
      body: Column(
        children: [
          DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: TabBar(
              onTap: ((value) {
                pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.bounceInOut,
                );
                _storeCtx.filterOrders(value);
              }),
              labelColor: MyColors.primary,
              unselectedLabelColor: MyColors.black,
              indicatorColor: MyColors.primary,
              tabs: const [
                Tab(text: "Шинэ"),
                Tab(text: "Хүргэлтэнд"),
                Tab(text: "Хүргэсэн"),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: const [
                StoreOrdersNewOrdersScreen(),
                StoreOrdersNewOrdersScreen(),
                StoreOrdersNewOrdersScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
