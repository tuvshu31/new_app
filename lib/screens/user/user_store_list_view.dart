import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/screens/user/user_products_screen.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:iconly/iconly.dart';

class UserStoreListView extends StatefulWidget {
  final String title;
  final int typeId;

  const UserStoreListView({
    Key? key,
    this.title = "Байгууллага",
    this.typeId = 0,
  }) : super(key: key);

  @override
  State<UserStoreListView> createState() => _UserStoreListViewState();
}

class _UserStoreListViewState extends State<UserStoreListView> {
  bool loading = false;
  List storeList = [];
  @override
  void initState() {
    super.initState();
    getStores();
  }

  void getStores() async {
    loading = true;
    var query = {"categoryId": _navCtx.typeId.value};
    dynamic response = await RestApi().getStoreList(query);
    dynamic d = Map<String, dynamic>.from(response);
    loading = false;
    if (d["success"]) {
      storeList = d["data"];
    }
    setState(() {});
  }

  final _navCtx = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      customLeading: CustomInkWell(
        onTap: () {
          _navCtx.searchViewController.value.jumpToPage(0);
        },
        child: const SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Icon(
            IconlyLight.arrow_left,
            color: MyColors.black,
            size: 20,
          ),
        ),
      ),
      title: _navCtx.title.value,
      customActions: Container(),
      subtitle: subtitle(loading, storeList.length, "байгууллага"),
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
                          typeId: _navCtx.typeId.value,
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
                              data["isOpen"] == 0
                                  ? Container(
                                      width: Get.width * .25,
                                      height: Get.width * .25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: data["name"],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data["description"] != ""
                                        ? data["name"]
                                        : data["description"],
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                      color: MyColors.gray,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  RatingBar.builder(
                                    initialRating: 0,
                                    itemSize: 12,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    unratedColor: MyColors.background,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemBuilder: (context, _) => const Icon(
                                      IconlyBold.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  const SizedBox(height: 8),
                                  _saleFlag(data)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * .1,
                            child: const Center(
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
    );
  }

  Widget _saleFlag(dynamic data) {
    return !data["withSale"]
        ? Container()
        : Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.discount_outlined,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  data["saleText"] ?? "",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          );
  }
}
