import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/controller/product_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';

class CustomData extends StatefulWidget {
  const CustomData({Key? key}) : super(key: key);

  @override
  _CustomDataState createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {
  final _prodCtrl = Get.put(ProductController());
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _prodCtrl.hasMore.value = true;
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 300) {
            _prodCtrl.onScrollShowHide.value = true;
          } else {
            _prodCtrl.onScrollShowHide.value = false;
          }
        });
      });
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
          _prodCtrl.page++;
          _prodCtrl.callProducts();
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.elasticInOut);
  }

  int _scrolledItems = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Container(
            color: MyColors.fadedGrey,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                var height = notification.metrics.maxScrollExtent /
                    _prodCtrl.data.length;
                var position = ((notification.metrics.maxScrollExtent -
                            notification.metrics.extentAfter) /
                        height)
                    .round();
                setState(() {
                  _scrolledItems = position;
                });

                return true;
              },
              child: !_prodCtrl.hasMore.value && _prodCtrl.data.isEmpty
                  ? Container(
                      color: MyColors.white,
                      child: const CustomLoadingIndicator(
                          text: "Бараа байхгүй байна"))
                  : GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
                      itemCount:
                          _prodCtrl.hasMore.value && _prodCtrl.data.isEmpty
                              ? _prodCtrl.data.length + 6
                              : _prodCtrl.hasMore.value
                                  ? _prodCtrl.data.length + 2
                                  : _prodCtrl.data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        if (index < _prodCtrl.data.length) {
                          var data = _prodCtrl.data[index];

                          return Container(
                            color: MyColors.white,
                            margin: const EdgeInsets.all(4),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () => Get.toNamed(
                                          '/ProductsRoute',
                                          arguments: {
                                            "data": data,
                                          },
                                        ),
                                        child: Hero(
                                          transitionOnUserGestures: true,
                                          tag: data,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${URL.AWS}/products/${data["id"]}/large/1.png",
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: Get.width * .4,
                                              height: Get.width * .4,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                CustomShimmer(
                                              width: Get.width * .4,
                                              height: Get.width * .4,
                                            ),
                                            errorWidget: (context, url,
                                                    error) =>
                                                const Image(
                                                    image: AssetImage(
                                                        "assets/images/png/no_image.png")),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      CustomText(
                                        text: data['name'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      CustomText(
                                        text: data['storeName'],
                                        overflow: TextOverflow.ellipsis,
                                        color: MyColors.gray,
                                        fontSize: 12,
                                      ),
                                      const SizedBox(height: 4),
                                      CustomText(
                                        text: convertToCurrencyFormat(
                                            double.parse(data['price']),
                                            toInt: true,
                                            locatedAtTheEnd: true),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (_prodCtrl.hasMore.value) {
                          return _loadingCard();
                        } else {
                          return Container();
                        }
                      },
                    ),
            ),
          ),
          _prodCtrl.onScrollShowHide.value == true
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
                                          "$_scrolledItems / ${_prodCtrl.total}",
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
              : Container()
        ],
      ),
    );
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

Widget _loadingCard() {
  return Container(
    color: MyColors.white,
    margin: const EdgeInsets.all(4),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomShimmer(
            width: Get.width * .4,
            height: Get.width * .4,
          ),
          const SizedBox(height: 8),
          CustomShimmer(
            width: Get.width * .5,
            height: 14,
          ),
          const SizedBox(height: 8),
          CustomShimmer(
            width: Get.width * .25,
            height: 14,
          ),
        ],
      ),
    ),
  );
}
