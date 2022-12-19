import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/screens/store/orders/delivered_orders.dart';
import 'package:Erdenet24/screens/store/orders/new_orders.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/controller/product_controller.dart';

class StoreOrders extends StatefulWidget {
  const StoreOrders({super.key});

  @override
  State<StoreOrders> createState() => _StoreOrdersState();
}

class _StoreOrdersState extends State<StoreOrders> {
  dynamic _products = {};
  final _prodCtrl = Get.put(ProductController());
  void getOrders() async {
    dynamic response =
        await RestApi().getOrders({"userId": RestApiHelper.getUserId()});
    dynamic d = Map<String, dynamic>.from(response);
    print(d);
  }

  @override
  void initState() {
    super.initState();
    getOrders();
    print(_prodCtrl.orders);
  }

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
            length: 3,
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
                  text: "Шинэ",
                ),
                Tab(
                  text: "Хүргэгдсэн",
                ),
                Tab(
                  text: "Цуцлагдсан",
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: const [
                NewOrdersView(),
                DeliveredOrdersView(),
                DeliveredOrdersView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
