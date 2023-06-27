import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/product_controller.dart';
import 'package:Erdenet24/screens/user/user_product_detail_screen.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/screens/user/user_products_screen.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:iconly/iconly.dart';

class UserStoreListScreen extends StatefulWidget {
  const UserStoreListScreen({Key? key}) : super(key: key);

  @override
  State<UserStoreListScreen> createState() => _UserStoreListScreenState();
}

class _UserStoreListScreenState extends State<UserStoreListScreen> {
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
    var query = {"role": "store", "category": categoryId};
    query.removeWhere((key, value) => value == 0);
    dynamic response = await RestApi().getUsers(query);
    dynamic d = Map<String, dynamic>.from(response);
    loading = false;
    if (d["success"]) {
      storeList = d["data"].where((x) => x["name"] != "Тест").toList();
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
                          Get.to(UserProductsScreen(
                            title: data["name"],
                            typeId: data["category"],
                            storeId: data["id"],
                            navType: NavType.store,
                          ));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                CustomImage(
                                  width: Get.width * .25,
                                  height: Get.width * .25,
                                  url:
                                      "${URL.AWS}/users/${data["id"]}/small/1.png",
                                ),
                                !data["isOpen"]
                                    ? Container(
                                        width: Get.width * .25,
                                        height: Get.width * .25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.black.withOpacity(0.6),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Хаалттай",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            SizedBox(width: Get.width * .045),
                            Expanded(
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(height: 4),
                                    CustomText(
                                      text: data["name"],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    CustomText(
                                      text: data["description"] ?? data["name"],
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                      color: MyColors.gray,
                                    ),
                                    CustomText(
                                      text:
                                          "${data["registered_date"]} - с хойш",
                                      fontSize: 12,
                                      color: MyColors.gray,
                                    ),
                                    const SizedBox(height: 4),
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
