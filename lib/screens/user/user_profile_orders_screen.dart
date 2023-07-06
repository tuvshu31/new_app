import 'dart:developer';

import 'package:Erdenet24/screens/user/user_product_detail_screen.dart';
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
        body: Obx(
          () => _userCtx.filteredOrderList.isEmpty
              ? const CustomLoadingIndicator(text: "Захиалга байхгүй байна")
              : ListView.separated(
                  padding:
                      const EdgeInsets.only(right: 20, left: 20, bottom: 40),
                  separatorBuilder: (context, index) {
                    return Container(height: 12);
                  },
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _userCtx.filteredOrderList.length,
                  itemBuilder: (context, index) {
                    var data = _userCtx.filteredOrderList[index];
                    return _cardItem(data);
                  },
                ),
        ));
  }

  Widget _cardItem(data) {
    return CustomInkWell(
      onTap: () {
        userOrdersDetailView(data);
      },
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(0),
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 32, right: 12, left: 12, bottom: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width * .3,
                          child: const CustomText(
                            text: "Огноо",
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            text: data["orderTime"],
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width * .3,
                          child: const CustomText(
                            text: "Захиалгын код:",
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            text: data["orderId"].toString(),
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SizedBox(
                          width: Get.width * .3,
                          child: const CustomText(
                            text: "Нийт үнэ:",
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: CustomText(
                            text: convertToCurrencyFormat(
                              double.parse(data["totalAmount"]),
                              locatedAtTheEnd: true,
                              toInt: true,
                            ),
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                  ],
                )),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                "Хүргэсэн",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void userOrdersDetailView(data) {
  showModalBottomSheet(
    backgroundColor: MyColors.white,
    context: Get.context!,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 24),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomText(
                    text: "Захиалгын код:",
                    fontSize: 14,
                    color: MyColors.gray,
                  ),
                  CustomText(
                    text: data["orderId"].toString(),
                    fontSize: 16,
                    color: MyColors.black,
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 7,
                        color: MyColors.fadedGrey,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: data["products"].length,
                    itemBuilder: (context, index) {
                      var product = data["products"][index];
                      return Container(
                          height: Get.height * .09,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          color: MyColors.white,
                          child: Center(
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              minLeadingWidth: Get.width * .15,
                              leading: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12)),
                                child: CachedImage(
                                    image:
                                        "${URL.AWS}/products/${product["id"]}/small/1.png"),
                              ),
                              title: CustomText(
                                text: product["name"],
                                fontSize: 14,
                              ),
                              subtitle: CustomText(
                                  text: convertToCurrencyFormat(
                                int.parse(product["price"]),
                                toInt: true,
                                locatedAtTheEnd: true,
                              )),
                              trailing: CustomText(
                                  text: "${product["quantity"]} ширхэг"),
                            ),
                          ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
