import 'dart:developer';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:badges/badges.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/widgets/products.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/controller/product_controller.dart';
import 'package:iconly/iconly.dart';

class UserCategoryProductScreen extends StatefulWidget {
  const UserCategoryProductScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserCategoryProductScreen> createState() =>
      _UserCategoryProductScreenState();
}

class _UserCategoryProductScreenState extends State<UserCategoryProductScreen> {
  final _prodCtrl = Get.put(ProductController());
  final _cartCtrl = Get.put(CartController());
  final _incoming = Get.arguments;
  final _navCtrl = Get.put(NavigationController());
  dynamic _tabItems = [];

  @override
  void initState() {
    super.initState();
    callCategories();
    _prodCtrl.data.clear();
    _prodCtrl.onScrollShowHide.value = false;
    _prodCtrl.page.value = 1;
    _prodCtrl.typeId.value = int.parse(_incoming["parentId"]);
    _prodCtrl.categoryId.value = 0;
    _prodCtrl.search.value = 0;
    _prodCtrl.storeId.value = 0;
    _prodCtrl.storeName.value = "";
    _prodCtrl.callProducts();
  }

  void callCategories() async {
    dynamic response =
        await RestApi().getCategories({"parentId": _incoming["parentId"]});
    dynamic data = Map<String, dynamic>.from(response)['data'];
    var items = [
      {"id": null, "name": "Бүх"},
    ];
    setState(() {
      _tabItems = [...items, ...data];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DefaultTabController(
        initialIndex: 0,
        length: _tabItems.length,
        child: CustomHeader(
          // customActions: IconButton(
          //   icon: Badge(
          //     badgeAnimation: BadgeAnimation.rotation(),
          //     position: BadgePosition.custom(top: -12, end: -8),
          //     badgeContent: CustomText(
          //       text: _cartCtrl.cartList.length.toString(),
          //       color: MyColors.white,
          //     ),
          //     child: Icon(
          //       IconlyLight.buy,
          //       color: MyColors.black,
          //       size: 20,
          //     ),
          //   ),
          //   onPressed: () {
          //     Get.back();
          //     _navCtrl.onItemTapped(2);
          //   },
          // ),
          title: _incoming["name"],
          subtitle:
              subtitle(_prodCtrl.loading.value, _prodCtrl.total.value, "бараа"),
          tabBar: !_prodCtrl.onScrollShowHide.value
              ? PreferredSize(
                  preferredSize: const Size(double.infinity, kToolbarHeight),
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 16, right: 12, left: 12),
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      onTap: (index) {
                        _prodCtrl.changeTab(_tabItems[index]["id"] ?? 0);
                        log(_tabItems[index].toString());
                      },
                      isScrollable: true,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: MyColors.fadedGrey,
                      ),
                      labelColor: MyColors.primary,
                      unselectedLabelColor: Colors.black,
                      tabs: _tabItems.map<Widget>((e) {
                        return Tab(text: e["name"]);
                      }).toList(),
                    ),
                  ),
                )
              : null,
          body: const CustomData(),
        ),
      ),
    );
  }
}
