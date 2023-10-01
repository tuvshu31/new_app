import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:shimmer/shimmer.dart';

class UserProductsScreen extends StatefulWidget {
  final int typeId;
  final int storeId;
  final String title;
  int categoryId;
  final int visibility;
  final bool isFromSeachBar;
  final dynamic searchObject;
  final NavType navType;

  UserProductsScreen({
    Key? key,
    this.typeId = 0,
    this.storeId = 0,
    this.isFromSeachBar = false,
    this.searchObject,
    required this.navType,
    this.categoryId = 0,
    this.visibility = 1,
    required this.title,
  }) : super(key: key);

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  int _scrolledProducts = 0;
  int totalProducts = 0;
  int page = 1;
  bool hasMoreProducts = true;
  bool fetchingProducts = false;
  bool scrollShowHide = false;
  List products = [];
  List tabItems = [];
  List closedStoreList = [];
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callCategories();
    callProducts();
    handleScroller();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void handleScroller() {
    scrollController.addListener(() {
      if (scrollController.offset >= 300) {
        scrollShowHide = true;
      } else {
        scrollShowHide = false;
      }
    });
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
            scrollController.offset) {
          page++;
          callProducts();
        }
      },
    );
    setState(() {});
  }

  void _scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.elasticInOut);
  }

  void callProducts() async {
    fetchingProducts = true;
    String searchName = "";
    int searchId = 0;
    int storeId = widget.storeId;
    if (widget.isFromSeachBar) {
      var searchType = widget.searchObject["type"];
      if (searchType == "word") {
        searchName = widget.searchObject["name"];
      }
      if (searchType == "product") {
        searchId = widget.searchObject["id"];
      }
      if (searchType == "store") {
        storeId = widget.searchObject["id"];
      }
    }
    var query = {
      "page": page,
      "typeId": widget.typeId,
      "categoryId": widget.categoryId,
      "store": storeId,
      "visibility": widget.visibility,
      "searchName": searchName.isNotEmpty ? searchName : 0,
      "searchId": searchId,
      "limit": 9
    };

    query.removeWhere((key, value) => value == 0);
    dynamic response = await RestApi().getProducts(query);
    dynamic productResponse = Map<String, dynamic>.from(response);

    products = products + productResponse["data"];
    closedStoreList = productResponse["closed"];
    if (productResponse["data"].length <
        productResponse["pagination"]["limit"]) {
      hasMoreProducts = false;
    }
    totalProducts = productResponse["pagination"]["total"];
    fetchingProducts = false;
    setState(() {});
  }

  void callCategories() async {
    if (widget.navType != NavType.none) {
      dynamic response;
      if (widget.navType == NavType.category) {
        response = await RestApi().getCategories({"parentId": widget.typeId});
      } else if (widget.navType == NavType.store) {
        response = await RestApi().getStoreCategories(widget.storeId);
      }
      dynamic data = Map<String, dynamic>.from(response)['data'];
      var items = [
        {"id": null, "name": "Бүх"}
      ];
      tabItems = [...items, ...data];
      setState(() {});
    }
  }

  Future<void> searchProducts(searchObect) async {
    fetchingProducts = true;
    var type = searchObect["type"];
    var body = {"type": type};
    if (type == "word") {
      body["keyWord"] = searchObect["name"];
    } else if (type == "product") {
      body["productId"] = searchObect["id"];
    } else if (type == "store") {
      body["storeId"] = searchObect["id"];
    }
    log(body.toString());
    dynamic response = await RestApi().getSearchResults(body);
    dynamic productResponse = Map<String, dynamic>.from(response);
    products = products + productResponse["products"];
    hasMoreProducts = false;
    fetchingProducts = false;
    setState(() {});
  }

  void changeTab(int index) {
    page = 1;
    hasMoreProducts = true;
    widget.categoryId = index == 0 ? 0 : tabItems[index]["id"];
    products.clear();
    setState(() {});
    callProducts();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: tabItems.length,
      child: CustomHeader(
        customActions: Container(),
        title: widget.title,
        // subtitle: subtitle(fetchingProducts, totalProducts, "бараа"),
        tabBar: TabBar(
          onTap: (index) {
            changeTab(index);
          },
          isScrollable: true,
          // indicator: BoxDecoration(
          //   borderRadius: BorderRadius.circular(25),
          //   color: MyColors.fadedGrey,
          // ),
          indicatorColor: MyColors.primary,
          labelColor: MyColors.primary,
          unselectedLabelColor: Colors.black,
          tabs: tabItems.map<Widget>((e) {
            return Tab(text: e["name"]);
          }).toList(),
        ),
        body: _productsGridView(hasMoreProducts, products),
      ),
    );
  }

  PreferredSize? tabBar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 12, left: 12),
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: tabItems.isEmpty
            ? _tabShimmer()
            : TabBar(
                onTap: (index) {
                  changeTab(index);
                },
                isScrollable: true,
                // indicator: BoxDecoration(
                //   borderRadius: BorderRadius.circular(25),
                //   color: MyColors.fadedGrey,
                // ),
                indicatorColor: MyColors.primary,
                labelColor: MyColors.primary,
                unselectedLabelColor: Colors.black,
                tabs: tabItems.map<Widget>((e) {
                  return Tab(text: e["name"]);
                }).toList(),
              ),
      ),
    );
  }

  Widget _productsGridView(bool hasMoreProducts, dynamic products) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            var height = notification.metrics.maxScrollExtent / products.length;
            var position = ((notification.metrics.maxScrollExtent -
                        notification.metrics.extentAfter) /
                    height)
                .round();
            _scrolledProducts = position;
            setState(() {});

            return true;
          },
          child: !hasMoreProducts && products.isEmpty
              ? Container(
                  color: MyColors.white,
                  child:
                      const CustomLoadingIndicator(text: "Бараа байхгүй байна"))
              : GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: hasMoreProducts && products.isEmpty
                      ? products.length + 6
                      : hasMoreProducts
                          ? products.length + 3
                          : products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
                    if (index < products.length) {
                      var data = products[index];
                      return _product(data);
                    } else if (hasMoreProducts) {
                      return _shimmer();
                    } else {
                      return Container();
                    }
                  },
                ),
        ),
        _backToTop(scrollShowHide, totalProducts)
      ],
    );
  }

  Widget _product(data) {
    return Column(
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
          child: Hero(
            transitionOnUserGestures: true,
            tag: data,
            child: Stack(
              children: [
                Image.network(
                  "${URL.AWS}/products/${data["id"]}/large/1.png",
                  width: (Get.width - 36) / 3,
                  height: (Get.width - 36) / 3,
                ),
                data["withSale"]
                    ? _productSaleFlag(data["salePercent"])
                    : Container(),
              ],
            ),
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
    );
  }

  Widget _tabShimmer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomShimmer(
          width: Get.width * .15,
          height: 46,
          borderRadius: 50,
        ),
        CustomShimmer(
          width: Get.width * .2,
          height: 46,
          borderRadius: 50,
        ),
        CustomShimmer(
          width: Get.width * .2,
          height: 46,
          borderRadius: 50,
        ),
        CustomShimmer(
          width: Get.width * .2,
          height: 46,
          borderRadius: 50,
        ),
      ],
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

  Widget _shimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Shimmer.fromColors(
          baseColor: MyColors.fadedGrey,
          highlightColor: MyColors.grey.withOpacity(0.3),
          child: Container(
            width: (Get.width - 36) / 3,
            height: (Get.width - 36) / 3,
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

  Widget _backToTop(bool show, int totalProducts) {
    return show
        ? Positioned(
            bottom: Get.height * .01,
            right: Get.width * .33,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _scrollToTop,
                      child: Card(
                        color: MyColors.gray.withOpacity(0.1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              const Icon(
                                IconlyLight.arrow_up,
                                size: 20,
                                color: MyColors.primary,
                              ),
                              const SizedBox(width: 8),
                              CustomText(
                                text: "$_scrolledProducts / $totalProducts",
                                color: MyColors.black,
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}

Widget subtitle(bool loading, int total, String type) {
  return !loading
      ? CustomText(
          text: "$total $type",
          fontSize: MyFontSizes.small,
          color: MyColors.gray,
        )
      : CustomShimmer(
          width: Get.width * .15,
          height: 16,
        );
}