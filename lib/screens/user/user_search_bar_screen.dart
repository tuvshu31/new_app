import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/screens/user/user_products_screen.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';

class UserSearchBarScreenRoute extends StatefulWidget {
  const UserSearchBarScreenRoute({super.key});

  @override
  State<UserSearchBarScreenRoute> createState() =>
      _UserSearchBarScreenRouteState();
}

class _UserSearchBarScreenRouteState extends State<UserSearchBarScreenRoute> {
  bool catLoading = false;
  List tabItems = [];
  bool loading = true;
  int page = 1;
  int typeId = 0;
  List products = [];
  List closedStoreList = [];
  String searchName = "";
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    callCategories();
  }

  void callProducts() async {
    loading = true;
    products.clear();
    var query = {
      "searchName": searchName,
      "merge": true,
      "typeId": typeId,
      "visibility": 1,
      "limit": 30
    };
    query.removeWhere((key, value) => value == 0);
    dynamic res = await RestApi().getProducts(query);
    dynamic response = Map<String, dynamic>.from(res);
    products = response["data"];
    closedStoreList = response["closed"];
    loading = false;
    setState(() {});
  }

  void callCategories() async {
    catLoading = true;
    dynamic response = await RestApi().getMainCategories();
    dynamic data = Map<String, dynamic>.from(response)['data'];
    var items = [
      {"id": 0, "name": "Бүх"}
    ];
    tabItems = [...items, ...data];
    catLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: catLoading ? 4 : tabItems.length,
      child: CustomHeader(
        customLeading: CustomInkWell(
          onTap: () {
            Get.back();
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
        customActions: Container(),
        actionWidth: 24,
        customTitle: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: MyColors.fadedGrey,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 12),
                child: Center(
                  child: loading && searchName.isNotEmpty
                      ? const CupertinoActivityIndicator()
                      : const Icon(
                          IconlyLight.search,
                          color: MyColors.primary,
                          size: 20,
                        ),
                ),
              ),
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  autofocus: true,
                  controller: searchController,
                  decoration: const InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    hintText: "Бүтээгдэхүүн хайх...",
                    hintStyle: TextStyle(
                      fontSize: MyFontSizes.normal,
                      color: MyColors.gray,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: MyDimentions.borderWidth,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: MyDimentions.borderWidth,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: MyDimentions.borderWidth,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: MyFontSizes.large,
                    color: MyColors.black,
                  ),
                  cursorColor: MyColors.primary,
                  cursorWidth: 1.5,
                  onSubmitted: (value) {},
                  onChanged: (value) {
                    searchName = value;
                    setState(() {});
                    callProducts();
                  },
                ),
              ),
              searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: MyColors.gray,
                        size: 18,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        tabBar: TabBar(
          onTap: (value) {
            typeId = value;
            setState(() {});
            callProducts();
          },
          isScrollable: true,
          indicatorColor: catLoading ? Colors.transparent : MyColors.primary,
          labelColor: MyColors.primary,
          unselectedLabelColor: Colors.black,
          tabs: catLoading
              ? _tabShimmer()
              : tabItems.map<Widget>((e) {
                  return Tab(text: e["name"]);
                }).toList(),
        ),
        body: searchController.text.isEmpty
            ? const CustomLoadingIndicator(text: "Хайх үгээ оруулна уу")
            : ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: products.length,
                separatorBuilder: (context, index) {
                  return Container(
                    height: 7,
                    width: double.infinity,
                    color: MyColors.background,
                  );
                },
                itemBuilder: (context, index) {
                  List item = products[index];
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List<Widget>.generate(
                        item.length,
                        (index) {
                          var data = item[index];
                          return _product(data);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  List<Widget> _tabShimmer() {
    return [
      CustomShimmer(width: Get.width * .2, height: 36),
      CustomShimmer(width: Get.width * .2, height: 36),
      CustomShimmer(width: Get.width * .2, height: 36),
      CustomShimmer(width: Get.width * .2, height: 36)
    ];
  }

  Widget _shimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Shimmer.fromColors(
          baseColor: MyColors.fadedGrey,
          highlightColor: MyColors.grey.withOpacity(0.3),
          child: Container(
            width: (Get.width - 36) / 4,
            height: (Get.width - 36) / 4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        CustomShimmer(
          width: Get.width * .2,
          height: 16,
          borderRadius: 12,
        ),
        CustomShimmer(
          width: Get.width * .2,
          height: 16,
          borderRadius: 12,
        ),
      ],
    );
  }

  Widget _product(data) {
    return Container(
      margin: const EdgeInsets.all(12),
      width: (Get.width - 36) / 4,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => Get.toNamed(
                  userProductDetailScreenRoute,
                  arguments: {
                    "data": data,
                  },
                ),
                child: Stack(
                  children: [
                    CustomImage(
                      width: (Get.width - 36) / 4,
                      height: (Get.width - 36) / 4,
                      url: data["smallImg"],
                    ),
                    data["withSale"]
                        ? _productSaleFlag(data["salePercent"])
                        : Container(),
                  ],
                ),
              ),
              Text(
                convertToCurrencyFormat(
                  double.parse(data['price']),
                ),
                style: TextStyle(
                  color: data["withSale"] ? Colors.green : Colors.black,
                ),
              ),
              data["withSale"]
                  ? Text(
                      convertToCurrencyFormat(
                        double.parse(data['beforeSalePrice']),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    )
                  : Container(),
              Text(
                data["name"] ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Positioned(
            left: 2,
            top: 2,
            child: CustomImage(
              radius: 50,
              width: Get.width * .06,
              height: Get.width * .06,
              url: "${URL.AWS}/users/${int.parse(data["store"])}/small/1.png",
            ),
          ),
        ],
      ),
    );
  }

  Widget _productSaleFlag(String salePercent) {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          "-$salePercent%",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
