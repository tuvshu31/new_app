import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/product_controller.dart';
import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/products.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:iconly/iconly.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  dynamic _tabItems = [];
  bool loading = false;
  dynamic storeList = [];
  int categoryId = 0;
  final _prodCtrl = Get.put(ProductController());
  @override
  void initState() {
    super.initState();
    callCategories();
    getStores();
  }

  Future<void> callCategories() async {
    String response =
        await rootBundle.loadString('assets/json/categories.json');
    dynamic data = await json.decode(response);

    var items = [
      {"id": null, "name": "Бүх"},
    ];
    setState(() {
      _tabItems = [...items, ...data];
    });
  }

  void getStores() async {
    loading = true;
    var query = {"role": "store", "category": categoryId, "isOpen": 1};
    query.removeWhere((key, value) => value == 0);
    dynamic response = await RestApi().getUsers(query);
    dynamic d = Map<String, dynamic>.from(response);
    loading = false;
    if (d["success"]) {
      log(d["data"].toString());
      storeList = d["data"].where((x) => x["isOpen"] == true).toList();
    }

    setState(() {});
  }

  void changeStoreTab(int index) {
    setState(() {
      storeList.clear();
      categoryId = index;
    });
    getStores();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: _tabItems.length,
      child: CustomHeader(
        isMainPage: true,
        title: "Дэлгүүр",
        customActions: Container(),
        subtitle: subtitle(loading, storeList.length, "дэлгүүр"),
        tabBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16, right: 12, left: 12),
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              onTap: (index) {
                changeStoreTab(index);
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
        ),
        body: !loading && storeList.isEmpty
            ? const CustomLoadingIndicator(text: "Дэлгүүр байхгүй байна")
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: storeList.isEmpty ? 6 : storeList.length,
                itemBuilder: (context, index) {
                  if (storeList.isEmpty) {
                    return MyShimmers().listView();
                  } else {
                    var data = storeList[index];
                    return Container(
                      margin: EdgeInsets.all(Get.width * .03),
                      height: Get.height * .13,
                      child: CustomInkWell(
                        onTap: () {
                          Get.toNamed(
                            "/CategoryNoTabbar",
                            arguments: storeList[index],
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: Get.width * .25,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12)),
                                child: CachedImage(
                                    image:
                                        "${URL.AWS}/users/${data["id"]}.png")),
                            SizedBox(width: Get.width * .045),
                            Expanded(
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: data["name"],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    // CustomText(
                                    //   text:
                                    //       "Нийт ${data["product_count"]} бараа",
                                    //   fontSize: 12,
                                    //   color: MyColors.gray,
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * .1,
                              child: Center(
                                child: Icon(
                                  IconlyLight.arrow_right_2,
                                  size: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                }),
      ),
    );
  }
}
