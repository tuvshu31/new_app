import 'package:get/get.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/screens/user/user_products_screen.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({super.key});

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  int selectedTab = 0;
  final _userCtx = Get.put(UserController());
  PageController pageController = PageController();
  // bool loading = false;
  // List orderList = [];

  @override
  void initState() {
    super.initState();
    _userCtx.getOrders(selectedTab);
  }

  void changeTab(int index) {
    _userCtx.filteredOrderList.clear();
    selectedTab = index;
    _userCtx.getOrders(selectedTab);
    setState(() {});
  }

  String orderStatus(int tab) {
    if (tab == 0) {
      return "preparing,sent";
    } else if (tab == 1) {
      return "delivered";
    } else {
      return "canceled";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: CustomHeader(
          isMainPage: true,
          customActions: Container(),
          title: "Захиалга",
          subtitle: subtitle(_userCtx.fetchingOrderList.value,
              _userCtx.filteredOrderList.length, "захиалга"),
          tabBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16, right: 12, left: 12),
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                  onTap: changeTab,
                  isScrollable: true,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: MyColors.fadedGrey,
                  ),
                  labelColor: MyColors.primary,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(text: "Шинэ"),
                    Tab(text: "Хүргэсэн"),
                    Tab(text: "Цуцалсан"),
                  ]),
            ),
          ),
          body: !_userCtx.fetchingOrderList.value &&
                  _userCtx.filteredOrderList.isEmpty
              ? const CustomLoadingIndicator(text: "Захиалга байхгүй байна")
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return Container(height: 12);
                  },
                  padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _userCtx.fetchingOrderList.value
                      ? 8
                      : _userCtx.filteredOrderList.length,
                  itemBuilder: (context, index) {
                    if (_userCtx.fetchingOrderList.value) {
                      return _listItemShimmer();
                    } else {
                      var item = _userCtx.filteredOrderList[index];
                      return CustomInkWell(
                        onTap: () {
                          _userCtx.selectedOrder.value = item;
                          _userCtx.showOrderDetails();
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: 1,
                                  color: MyColors.background,
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              height: Get.height * .1,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: Get.width * .5,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomImage(
                                          width: Get.width * .1,
                                          height: Get.width * .1,
                                          url:
                                              "${URL.AWS}/users/${item["storeId1"]}/small/1.png",
                                          radius: 50,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            item["storeName"] ?? "",
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          item["orderTime"],
                                          style: const TextStyle(
                                            color: MyColors.gray,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          convertToCurrencyFormat(
                                            int.parse(item["totalAmount"]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 18,
                                    color: MyColors.black,
                                  ),
                                ],
                              ),
                            ),
                            selectedTab == 0
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 2),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8)),
                                    ),
                                    child: Text(
                                      statusInfo(item["orderStatus"])["text"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }

  Widget _listItemShimmer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: MyColors.background,
        ),
      ),
      padding: const EdgeInsets.all(12),
      height: Get.height * .1,
      width: Get.width * .5,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Get.width * .5,
            child: Row(
              children: [
                CustomShimmer(
                  width: Get.width * .1,
                  height: Get.width * .1,
                  borderRadius: 50,
                ),
                const SizedBox(width: 12),
                CustomShimmer(
                  width: Get.width * .3,
                  height: 14,
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomShimmer(
                  width: Get.width * .3,
                  height: 14,
                ),
                CustomShimmer(
                  width: Get.width * .3,
                  height: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
