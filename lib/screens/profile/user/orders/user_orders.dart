import 'package:Erdenet24/screens/profile/user/orders/going_orders.dart';
import 'package:Erdenet24/screens/profile/user/orders/order_history.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({super.key});

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  PageController pageController = PageController();

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
              }),
              labelColor: MyColors.primary,
              unselectedLabelColor: MyColors.black,
              indicatorColor: MyColors.primary,
              tabs: [
                Tab(
                  text: "Хүргэгдэж буй",
                ),
                Tab(
                  text: "Хүргэгдсэн",
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: const [
                GoingOrdersView(),
                OrderHistoryView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
