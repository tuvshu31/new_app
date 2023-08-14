import 'dart:developer';

import 'package:Erdenet24/utils/helpers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
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
  final _storeCtx = Get.put(StoreController());
  PageController pageController = PageController();
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
      body: Align(
        alignment: Alignment.center,
        child: Column(
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
      ),
    );
  }

  Widget _storeOdersListView() {
    return Obx(
      () => _storeCtx.filteredOrderList.isEmpty
          ? const CustomLoadingIndicator(text: "Захиалга байхгүй байна")
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              separatorBuilder: (context, index) {
                return const SizedBox(height: 7);
              },
              physics: const BouncingScrollPhysics(),
              itemCount: _storeCtx.filteredOrderList.length,
              itemBuilder: (context, index) {
                var data = _storeCtx.filteredOrderList[index];
                return data["orderStatus"] == "received"
                    ? _newOrder(data)
                    : data["orderStatus"] == "preparing"
                        ? _preparing(data)
                        : _noTrailing(data);
              },
            ),
    );
  }

  Widget _newOrder(data) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: (() {
        showOrdersSetTimeView(context, data);
      }),
      child: Stack(
        children: [
          Card(
            elevation: 1,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: CustomText(
                text: "Захиалга: #${data["orderId"]}",
                fontSize: 12,
              ),
              subtitle: CustomText(
                text: data["orderTime"],
                fontSize: 12,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: convertToCurrencyFormat(
                      double.parse(data["storeTotalAmount"]),
                    ),
                    fontSize: 16,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: MyColors.primary.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              child: const Center(
                child: Text(
                  "Шинэ захиалга",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _preparing(data) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: (() {
        storeOrdersToDelivery(context, data);
      }),
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: CustomText(
            text: "Захиалга: #${data["orderId"]}",
            fontSize: 12,
          ),
          subtitle: CustomText(
            text: data["orderTime"],
            fontSize: 12,
          ),
          trailing: CircularCountDownTimer(
            width: 40,
            height: 40,
            duration: int.parse(data["prepDuration"]) * 60,
            timeFormatterFunction: (defaultFormatterFunction, duration) {
              if (duration.inSeconds == 0) {
                return "0";
              } else {
                return Function.apply(defaultFormatterFunction, [duration]);
              }
            },
            fillColor: MyColors.primary,
            ringColor: MyColors.black,
            strokeCap: StrokeCap.round,
            textStyle: const TextStyle(
              fontSize: 10.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _noTrailing(data) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: (() {
        storeOrdersToDelivery(context, data);
      }),
      child: Card(
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          title: CustomText(
            text: "Захиалга: #${data["orderId"]}",
            fontSize: 12,
          ),
          subtitle: CustomText(
            text: data["orderTime"],
            fontSize: 12,
          ),
          trailing: CustomText(
            text: convertToCurrencyFormat(
              double.parse(data["storeTotalAmount"]),
            ),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
