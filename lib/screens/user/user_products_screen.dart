import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
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
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.isFromSeachBar) {
      searchProducts(widget.searchObject);
    } else {
      callCategories();
      callProducts();
    }
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
    var query = {
      "page": page,
      "typeId": widget.typeId,
      "categoryId": widget.categoryId,
      "store": widget.storeId,
      "visibility": widget.visibility,
    };
    query.removeWhere((key, value) => value == 0 || value == "");
    dynamic response = await RestApi().getProducts(query);
    dynamic productResponse = Map<String, dynamic>.from(response);
    products = products + productResponse["data"];
    if (productResponse["data"].length <
        productResponse["pagination"]["limit"]) {
      hasMoreProducts = false;
    }
    totalProducts = productResponse["pagination"]["count"];
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

  void searchProducts(searchObect) {
    log(searchObect["type"].toString());
    var searchType= searchObect["type"];
    if(searchObect["type"]=="word"){
      fetchWordProducts();
    }
    else if(searchObect["type"]=="product"){
      fetch
    }
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
        title: widget.title,
        subtitle: subtitle(fetchingProducts, totalProducts, "бараа"),
        tabBar: widget.navType != NavType.none ? tabBar() : null,
        body: _productsGridView(hasMoreProducts, products),
      ),
    );
  }

  PreferredSize? tabBar() {
    return !scrollShowHide
        ? PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: Container(
              margin: const EdgeInsets.only(bottom: 16, right: 12, left: 12),
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                onTap: (index) {
                  changeTab(index);
                },
                isScrollable: true,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: MyColors.fadedGrey,
                ),
                labelColor: MyColors.primary,
                unselectedLabelColor: Colors.black,
                tabs: tabItems.map<Widget>((e) {
                  return Tab(text: e["name"]);
                }).toList(),
              ),
            ),
          )
        : null;
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
            setState(() {
              _scrolledProducts = position;
            });

            return true;
          },
          child: !hasMoreProducts && products.isEmpty
              ? Container(
                  color: MyColors.white,
                  child:
                      const CustomLoadingIndicator(text: "Бараа байхгүй байна"))
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  physics: const BouncingScrollPhysics(),
                  controller: scrollController,
                  itemCount: hasMoreProducts && products.isEmpty
                      ? products.length + 6
                      : hasMoreProducts
                          ? products.length + 2
                          : products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.74,
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
    return Container(
      color: MyColors.white,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Container(
                      width: (Get.width - 36) / 2,
                      height: (Get.width - 36) / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Image.network(
                        "${URL.AWS}/products/${data["id"]}/large/1.png",
                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox(
                            width: (Get.width - 36) / 2,
                            height: (Get.width - 36) / 2,
                            child: const Image(
                              image:
                                  AssetImage("assets/images/png/no_image.png"),
                            ),
                          );
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Container(
                            width: (Get.width - 36) / 2,
                            height: (Get.width - 36) / 2,
                            decoration: BoxDecoration(
                              color: MyColors.fadedGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const CupertinoActivityIndicator(),
                          );
                        },
                      ),
                    )),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: data['name'],
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      text: convertToCurrencyFormat(double.parse(data['price']),
                          toInt: true, locatedAtTheEnd: true),
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 12,
            top: 12,
            child: Row(
              children: [
                Container(
                  width: Get.width * .07,
                  height: Get.width * .07,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    "${URL.AWS}/users/${data["store"]}/small/1.png",
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Shimmer.fromColors(
                        baseColor: MyColors.fadedGrey,
                        highlightColor: MyColors.grey.withOpacity(0.3),
                        child: Container(
                          width: Get.width * .07,
                          height: Get.width * .07,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: MyColors.fadedGrey,
          highlightColor: MyColors.grey.withOpacity(0.3),
          child: Container(
            width: (Get.width - 36) / 2,
            height: (Get.width - 36) / 2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: MyColors.fadedGrey,
                highlightColor: MyColors.grey.withOpacity(0.3),
                child: Container(
                  width: Get.width / 2 - 24,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: MyColors.fadedGrey,
                highlightColor: MyColors.grey.withOpacity(0.3),
                child: Container(
                  width: Get.width / 3,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
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
          isRoundedCircle: true,
        );
}
