import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';

class UserProductsSearchScreen extends StatefulWidget {
  const UserProductsSearchScreen({super.key});

  @override
  State<UserProductsSearchScreen> createState() =>
      _UserProductsSearchScreenState();
}

class _UserProductsSearchScreenState extends State<UserProductsSearchScreen> {
  bool isSearching = false;
  bool fetchinSuggestions = false;
  List searchHistory = [];
  int totalProducts = 0;
  List searchSuggestions = [];
  int _scrolledProducts = 0;
  bool scrollShowHide = false;
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  bool loading = false;
  List products = [];
  Map pagination = {};
  bool hasMoreProducts = false;
  int page = 1;
  final _incoming = Get.arguments;
  @override
  void initState() {
    super.initState();
    searchHistory = RestApiHelper.getSearchHistory();
    setState(() {});
  }

  void callProducts(String text) async {
    loading = true;
    var query = {"searchName": text, "store": _incoming["storeId"]};
    dynamic res = await RestApi().getProducts(query);
    dynamic response = Map<String, dynamic>.from(res);
    products.clear();
    products = response["data"];
    pagination = response["pagination"];
    if (pagination["pageCount"] > page) {
      hasMoreProducts = true;
    } else {
      hasMoreProducts = false;
    }
    loading = false;
    setState(() {});
  }

  void _scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.elasticInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.white,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: MyColors.white,
            appBar: AppBar(
              actions: const [SizedBox(width: 24)],
              elevation: 0,
              leadingWidth: 56,
              leading: CustomInkWell(
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
              backgroundColor: MyColors.white,
              centerTitle: true,
              titleSpacing: 0,
              title: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: MyColors.fadedGrey,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: const Center(
                        child: Icon(
                          IconlyLight.search,
                          color: MyColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                          textInputAction: TextInputAction.search,
                          onChanged: callProducts,
                          autofocus: true,
                          controller: searchController,
                          decoration: const InputDecoration(
                            counterText: '',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                            hintText: "Бүтээгдэхүүн хайх...",
                            hintStyle: TextStyle(
                              fontSize: MyFontSizes.normal,
                              color: MyColors.grey,
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
                          cursorWidth: 1,
                          onSubmitted: (value) {}),
                    ),
                    isSearching
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              isSearching = false;
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
        ),
      ),
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
                CustomImage(
                  width: (Get.width - 36) / 3,
                  height: (Get.width - 36) / 3,
                  url: data["smallImg"],
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
