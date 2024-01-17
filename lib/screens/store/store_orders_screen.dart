import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/main.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';

class StoreOrdersScreen extends StatefulWidget {
  const StoreOrdersScreen({Key? key}) : super(key: key);

  @override
  State<StoreOrdersScreen> createState() => _StoreOrdersScreenState();
}

class _StoreOrdersScreenState extends State<StoreOrdersScreen> {
  bool updating = false;
  final _storeCtx = Get.put(StoreController());
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _storeCtx.refreshOrders();
    scrollHandler();
  }

  void scrollHandler() {
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
                scrollController.offset &&
            _storeCtx.hasMore.value) {
          _storeCtx.page.value++;
          setState(() {});
          _storeCtx.getStoreOrders();
        }
      },
    );
  }

  void onTap(int val) {
    _storeCtx.orders.clear();
    _storeCtx.tab.value = val;
    _storeCtx.page.value = 1;
    _storeCtx.getStoreOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        initialIndex: _storeCtx.tab.value,
        length: 2,
        child: CustomHeader(
          title: "Захиалгууд",
          customActions: Container(),
          tabBar: TabBar(
              onTap: (val) => onTap(val),
              indicatorColor: MyColors.primary,
              labelColor: MyColors.primary,
              unselectedLabelColor: Colors.black,
              tabs: const [
                Tab(text: "Шинэ"),
                Tab(text: "Хүргэсэн"),
              ]),
          body: _storeCtx.loading.value && _storeCtx.orders.isEmpty
              ? listShimmerWidget()
              : !_storeCtx.loading.value && _storeCtx.orders.isEmpty
                  ? customEmptyWidget("Захиалга байхгүй байна")
                  : RefreshIndicator(
                      color: MyColors.primary,
                      onRefresh: () async {
                        await Future.delayed(const Duration(milliseconds: 600));
                        _storeCtx.refreshOrders();
                        if (socket.disconnected) {
                          socket.connect();
                        }
                      },
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            width: double.infinity,
                            height: Get.height * .008,
                            decoration:
                                BoxDecoration(color: MyColors.fadedGrey),
                          );
                        },
                        padding: const EdgeInsets.only(top: 12),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _storeCtx.hasMore.value
                            ? _storeCtx.orders.length + 1
                            : _storeCtx.orders.length,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          if (index < _storeCtx.orders.length) {
                            var item = _storeCtx.orders[index];
                            String orderStatus =
                                _storeCtx.orders[index]["orderStatus"];
                            return CustomInkWell(
                              borderRadius: BorderRadius.zero,
                              onTap: () {
                                // Get.bottomSheet(
                                //   StoreOrdersDetailScreen(
                                //     id: item["id"],
                                //     orderId: item["orderId"],
                                //   ),
                                //   backgroundColor: MyColors.white,
                                //   isScrollControlled: true,
                                // );
                                _storeCtx.showOrderBottomSheet(item);
                              },
                              child: Container(
                                height: Get.height * .07,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(width: Get.width * .04),
                                    SizedBox(
                                      width: Get.width * .4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            text: "ID: ${item["orderId"]}",
                                            fontSize: 13,
                                            color: MyColors.gray,
                                          ),
                                          Text(convertToCurrencyFormat(
                                              item["totalAmount"])),
                                        ],
                                      ),
                                    ),
                                    _actions(item),
                                    SizedBox(width: Get.width * .04),
                                  ],
                                ),
                              ),
                            );
                          } else if (_storeCtx.hasMore.value) {
                            return listItemShimmer();
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _actions(Map item) {
    return Expanded(
      child: item["orderStatus"] == "sent"
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    "Шинэ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            )
          : item["orderStatus"] == "preparing"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircularCountDownTimer(
                      width: Get.height * .06,
                      height: Get.height * .06,
                      duration: item["prepDuration"],
                      initialDuration: item["initialDuration"],
                      fillColor: MyColors.background,
                      isReverse: true,
                      ringColor: Colors.red,
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: item["updatedTime"],
                      fontSize: 13,
                      color: MyColors.gray,
                    ),
                    status(item["orderStatus"])
                  ],
                ),
    );
  }

  Widget listItemShimmer() {
    return SizedBox(
      height: Get.width * .2 + 16,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: Get.width * .04),
            Stack(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Get.width * 0.15,
                    maxHeight: Get.width * 0.15,
                  ),
                  child: CustomShimmer(
                    width: Get.width * .15,
                    height: Get.width * .15,
                    borderRadius: 50,
                  ),
                ),
              ],
            ),
            SizedBox(width: Get.width * .04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomShimmer(width: Get.width * .7, height: 16),
                  CustomShimmer(width: Get.width * .7, height: 16),
                  CustomShimmer(width: Get.width * .7, height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
