import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/screens/store/store_orders_bottom_sheets.dart';

class StoreOrdersScreen extends StatefulWidget {
  const StoreOrdersScreen({super.key});

  @override
  State<StoreOrdersScreen> createState() => _StoreOrdersScreenState();
}

class _StoreOrdersScreenState extends State<StoreOrdersScreen> {
  PageController pageController = PageController();
  final _storeCtx = Get.put(StoreController());
  @override
  void initState() {
    super.initState();
    _storeCtx.filterOrders(0);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
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
            length: 3,
            initialIndex: 0,
            child: TabBar(
              onTap: ((value) {
                _storeCtx.filterOrders(value);
                pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.bounceInOut,
                );
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
              children: [
                _storeOdersListView(),
                _storeOdersListView(),
                _storeOdersListView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeOdersListView() {
    return Obx(
      () => _storeCtx.filteredOrderList.isEmpty
          ? const CustomLoadingIndicator(text: "Захиалга байхгүй байна")
          : ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 7);
              },
              physics: const BouncingScrollPhysics(),
              itemCount: _storeCtx.filteredOrderList.length,
              itemBuilder: (context, index) {
                var data = _storeCtx.filteredOrderList[index];
                return GestureDetector(
                  onTap: (() {
                    storeOrdersToDeliveryView(context, data);
                  }),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListTile(
                      title: CustomText(
                        text: "${data["orderId"]}",
                        fontSize: 14,
                      ),
                      subtitle: CustomText(
                        text: data["orderTime"],
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
