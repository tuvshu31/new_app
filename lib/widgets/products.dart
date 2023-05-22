import 'dart:developer';

import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/controller/product_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class CustomData extends StatefulWidget {
  final dynamic data;

  const CustomData({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  _CustomDataState createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {
  int _scrolledProducts = 0;
  final _prodCtrl = Get.put(ProductController());
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _prodCtrl.hasMore.value = true;
    scrollController.addListener(() {
      setState(() {
        if (scrollController.offset >= 300) {
          _prodCtrl.onScrollShowHide.value = true;
        } else {
          _prodCtrl.onScrollShowHide.value = false;
        }
      });
    });
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
            scrollController.offset) {
          _prodCtrl.page++;
          _prodCtrl.callProducts();
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.elasticInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          _productsGridView(_prodCtrl.hasMore.value, _prodCtrl.data),
          _backToTop(_prodCtrl.onScrollShowHide.value, _prodCtrl.total.value)
        ],
      ),
    );
  }

  Widget _productsGridView(bool hasMore, dynamic products) {
    return Container(
      // color: MyColors.fadedGrey,
      child: NotificationListener<ScrollNotification>(
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
        child: !hasMore && products.isEmpty
            ? Container(
                color: MyColors.white,
                child:
                    const CustomLoadingIndicator(text: "Бараа байхгүй байна"))
            : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                itemCount: hasMore && products.isEmpty
                    ? products.length + 6
                    : hasMore
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
                  } else if (_prodCtrl.hasMore.value) {
                    return _shimmer();
                  } else {
                    return Container();
                  }
                },
              ),
      ),
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
                  userProductScreenRoute,
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
                // const SizedBox(width: 8),
                // CustomText(
                //   text: data['storeName'],
                //   overflow: TextOverflow.ellipsis,
                //   color: MyColors.gray,
                //   fontSize: 12,
                // ),
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
