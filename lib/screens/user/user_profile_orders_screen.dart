import 'dart:developer';

import 'package:Erdenet24/screens/user/user_product_detail_screen.dart';
import 'package:Erdenet24/screens/user/user_profile_orders_detail_screen.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
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
  final _userCtx = Get.put(UserController());
  PageController pageController = PageController();

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
                Tab(text: "Хүргэж байгаа"),
                Tab(text: "Хүргэсэн"),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _userOrdersListWidget() {
    return Obx(
      () => _userCtx.filteredOrderList.isEmpty
          ? const CustomLoadingIndicator(text: "Захиалга байхгүй байна")
          : ListView.separated(
              separatorBuilder: (context, index) {
                return Container(height: 12);
              },
              padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _userCtx.filteredOrderList.length,
              itemBuilder: (context, index) {
                var data = _userCtx.filteredOrderList[index];
                return _listItem(data);
              },
            ),
    );
  }

  Widget _listItem(data) {
    log(data.toString());

    return CustomInkWell(
      onTap: () {
        showModalBottomSheet(
          useSafeArea: true,
          backgroundColor: MyColors.white,
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return UserProfileOrdersDetailScreen(
              data: data,
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
                  Expanded(
                    child: Row(
                      children: [
                        CustomImage(
                          width: Get.width * .1,
                          height: Get.width * .1,
                          url:
                              "${URL.AWS}/users/${data["storeId1"]}/small/1.png",
                          radius: 50,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          data["storeName"],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          convertToCurrencyFormat(
                            int.parse(data["totalAmount"]),
                            toInt: true,
                            locatedAtTheEnd: true,
                          ),
                        ),
                        Text(
                          data["orderTime"],
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
            ),
            child: const Text(
              "Хүлээн авсан",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
