import 'package:Erdenet24/api/local_notification.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/screens/user/user_orders_detail_screen.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({Key? key}) : super(key: key);

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  final _userCtx = Get.put(UserController());
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _userCtx.tab.value = 0;
    _userCtx.page.value = 1;
    _userCtx.orders.clear();
    _userCtx.getUserOrders();
    scrollHandler();
  }

  void scrollHandler() {
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
                scrollController.offset &&
            _userCtx.hasMore.value) {
          _userCtx.page.value++;
          setState(() {});
          _userCtx.getUserOrders();
        }
      },
    );
  }

  void onTap(int val) {
    _userCtx.tab.value = val;
    _userCtx.page.value = 1;
    _userCtx.orders.clear();
    _userCtx.getUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        initialIndex: _userCtx.tab.value,
        length: 3,
        child: CustomHeader(
            isMainPage: true,
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
                  Tab(text: "Цуцалсан")
                ]),
            body: _userCtx.loading.value && _userCtx.orders.isEmpty
                ? listShimmerWidget()
                : !_userCtx.loading.value && _userCtx.orders.isEmpty
                    ? customEmptyWidget("Захиалга байхгүй байна")
                    : RefreshIndicator(
                        onRefresh: () async {},
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
                          physics: const BouncingScrollPhysics(),
                          itemCount: _userCtx.hasMore.value
                              ? _userCtx.orders.length + 1
                              : _userCtx.orders.length,
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            if (index < _userCtx.orders.length) {
                              var item = _userCtx.orders[index];
                              return listItemWidget(item, () {}, () {});
                            } else if (_userCtx.hasMore.value) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: itemShimmer(),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      )),
      ),
    );
  }

  //  var item = _userCtx.filteredOrderList[index];
  Widget listItemWidget(
      Map item, VoidCallback onClicked1, VoidCallback onClicked2) {
    return CustomInkWell(
      onTap: () {
        Get.bottomSheet(
          UserOrdersDetailScreen(
            id: item["id"],
            orderId: item["orderId"],
          ),
          backgroundColor: MyColors.white,
          isScrollControlled: true,
        );
      },
      child: Container(
        height: Get.height * .08,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: Get.width * .04),
            Stack(
              children: [
                customImage(Get.width * .15, item["image"], isCircle: true)
              ],
            ),
            SizedBox(width: Get.width * .04),
            SizedBox(
              width: Get.width * .4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: item["orderId"],
                    fontSize: 13,
                    color: MyColors.gray,
                  ),
                  CustomText(
                    text: item["storeName"],
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(convertToCurrencyFormat(item["totalAmount"])),
                ],
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  text: item["date"],
                  fontSize: 13,
                  color: MyColors.gray,
                ),
                const Spacer(),
                CustomText(
                  textAlign: TextAlign.end,
                  text: item["orderStatusMNG"],
                  fontSize: 12,
                  color: _userCtx.tab.value == 0
                      ? Colors.amber
                      : _userCtx.tab.value == 1
                          ? Colors.green
                          : Colors.red,
                ),
              ],
            )),
            SizedBox(width: Get.width * .04),
          ],
        ),
      ),
    );
  }
}

Widget customTextButton(VoidCallback onPressed, IconData icon, String text,
    {bool isActive = true}) {
  return ElevatedButton(
    style: ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      elevation: const MaterialStatePropertyAll<double>(0),
      backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
      overlayColor: MaterialStatePropertyAll<Color>(
        Colors.black.withOpacity(0.1),
      ),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
    ),
    onPressed: isActive ? onPressed : null,
    child: Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isActive ? MyColors.black : MyColors.background,
        ),
        const SizedBox(width: 8),
        CustomText(
          text: text,
          fontSize: 12,
          color: isActive ? MyColors.black : MyColors.background,
        ),
      ],
    ),
  );
}
