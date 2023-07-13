import 'dart:developer';

import 'package:Erdenet24/screens/user/user_profile_orders_detail_screen.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/controller/user_controller.dart';

class UserProfileOrdersScreen extends StatefulWidget {
  const UserProfileOrdersScreen({super.key});

  @override
  State<UserProfileOrdersScreen> createState() =>
      _UserProfileOrdersScreenState();
}

class _UserProfileOrdersScreenState extends State<UserProfileOrdersScreen> {
  int selectedTab = 0;
  final _userCtx = Get.put(UserController());
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    _userCtx.filterOrders(0);
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
                pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.bounceInOut,
                );
                _userCtx.filterOrders(value);
                selectedTab = value;
                setState(() {});
              }),
              labelColor: MyColors.primary,
              unselectedLabelColor: MyColors.black,
              indicatorColor: MyColors.primary,
              tabs: const [
                Tab(text: "Шинэ"),
                Tab(text: "Хүргэсэн"),
                Tab(text: "Цуцалсан"),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: [
                _userOrdersListWidget(),
                _userOrdersListWidget(),
                _userOrdersListWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userOrdersListWidget() {
    return Obx(
      () => !_userCtx.fetchingOrderList.value &&
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
                return _userCtx.fetchingOrderList.value
                    ? _listItemShimmer()
                    : CustomInkWell(
                        onTap: () {
                          showModalBottomSheet(
                            useSafeArea: true,
                            backgroundColor: MyColors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return UserProfileOrdersDetailScreen(
                                index: index,
                              );
                            },
                          );
                        },
                        child: Stack(
                          children: [
                            Card(
                              elevation: 1,
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Container(
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
                                                "${URL.AWS}/users/${_userCtx.filteredOrderList[index]["storeId1"]}/small/1.png",
                                            radius: 50,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              _userCtx.filteredOrderList[index]
                                                      ["storeName"] ??
                                                  "",
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
                                            convertToCurrencyFormat(
                                              int.parse(_userCtx
                                                      .filteredOrderList[index]
                                                  ["totalAmount"]),
                                              toInt: true,
                                              locatedAtTheEnd: true,
                                            ),
                                          ),
                                          Text(
                                            _userCtx.filteredOrderList[index]
                                                ["orderTime"],
                                            style: const TextStyle(
                                              color: MyColors.gray,
                                              fontSize: 10,
                                            ),
                                          )
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
                                      _userCtx.filteredOrderList[index]
                                              ["orderStatus"]
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      );
              },
            ),
    );
  }

  Widget _listItemShimmer() {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
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
      ),
    );
  }
}
