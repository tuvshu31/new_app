import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
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
  bool loading = false;
  bool scrollShowHide = false;
  bool catLoading = false;
  List products = [];
  List tabItems = [];
  Map<String, dynamic> pagination = {};
  List closedStoreList = [];
  ScrollController scrollController = ScrollController();
  final _navCtrl = Get.put(NavigationController());
  final _cartCtrl = Get.put(CartController());

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
    loading = true;
    var query = {
      "page": page,
      "typeId": widget.typeId,
      "categoryId": widget.categoryId,
      "store": widget.storeId,
      "visibility": widget.visibility,
      "limit": 12
    };

    query.removeWhere((key, value) => value == 0);
    dynamic res = await RestApi().getProducts(query);
    dynamic response = Map<String, dynamic>.from(res);
    products = products + response["data"];
    closedStoreList = response["closed"];
    pagination = response["pagination"];
    if (pagination["pageCount"] > page) {
      hasMoreProducts = true;
    } else {
      hasMoreProducts = false;
    }
    loading = false;
    setState(() {});
  }

  void callCategories() async {
    if (widget.navType != NavType.none) {
      catLoading = true;
      dynamic response;
      if (widget.navType == NavType.category) {
        response = await RestApi().getCategories({"parentId": widget.typeId});
      } else if (widget.navType == NavType.store) {
        response = await RestApi().getStoreCategories(widget.storeId);
      }
      dynamic data = Map<String, dynamic>.from(response)['data'];
      var items = [
        {"id": 0, "name": "Бүх"}
      ];
      tabItems = [...items, ...data];
      catLoading = false;
      setState(() {});
    }
  }

  void changeTab(int index) {
    page = 1;
    widget.categoryId = tabItems[index]["id"];
    products.clear();
    setState(() {});
    callProducts();
    _scrollToTop();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: catLoading ? 4 : tabItems.length,
      child: CustomHeader(
        actionWidth: Get.width * .3,
        customActions: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              color: Colors.black,
              icon: const Icon(
                IconlyLight.search,
                size: 20,
              ),
              onPressed: () {
                Get.toNamed(userProductsSearchScreenRoute,
                    arguments: {"storeId": widget.storeId});
              },
            ),
            // IconButton(
            //   color: Colors.black,
            //   icon: const Icon(
            //     IconlyLight.buy,
            //     size: 20,
            //   ),
            //   onPressed: () {
            //     Get.toNamed(userProductsSearchScreenRoute,
            //         arguments: {"storeId": widget.storeId});
            //   },
            // ),
            CustomInkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                Get.back();
                Get.back();
                _navCtrl.onItemTapped(2);
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        IconlyLight.buy,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: MyColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Obx(() => Text(
                              _cartCtrl.cartItemCount.value.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        title: widget.title,
        tabBar: TabBar(
          onTap: changeTab,
          isScrollable: true,
          indicatorColor: catLoading ? Colors.transparent : MyColors.primary,
          labelColor: MyColors.primary,
          unselectedLabelColor: Colors.black,
          tabs: tabItems.isEmpty
              ? _tabShimmer()
              : tabItems.map<Widget>((e) {
                  return Tab(text: e["name"]);
                }).toList(),
        ),
        body: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                var height =
                    notification.metrics.maxScrollExtent / products.length;
                var position = ((notification.metrics.maxScrollExtent -
                            notification.metrics.extentAfter) /
                        height)
                    .round();
                _scrolledProducts = position;
                setState(() {});
                return true;
              },
              child: !loading && products.isEmpty
                  ? Container(
                      color: MyColors.white,
                      child: const CustomLoadingIndicator(
                          text: "Бараа байхгүй байна"),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 24),
                      physics: const BouncingScrollPhysics(),
                      controller: scrollController,
                      itemCount: products.isEmpty && hasMoreProducts
                          ? 18
                          : hasMoreProducts
                              ? products.length + 3
                              : products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
        ),
      ),
    );
  }

  Widget _product(data) {
    return Column(
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
            child: Stack(
              children: [
                CustomImage(
                  width: (Get.width - 36) / 3,
                  height: (Get.width - 36) / 3,
                  url: data["smallImg"],
                ),
                data["withSale"]
                    ? _productSaleFlag(data["salePercent"].toString())
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

  List<Widget> _tabShimmer() {
    return [
      CustomShimmer(width: Get.width * .2, height: 36),
      CustomShimmer(width: Get.width * .2, height: 36),
      CustomShimmer(width: Get.width * .2, height: 36),
      CustomShimmer(width: Get.width * .2, height: 36)
    ];
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
                                text:
                                    "$_scrolledProducts / ${pagination["total"]}",
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
