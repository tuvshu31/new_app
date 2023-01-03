import 'dart:developer';

import 'package:Erdenet24/widgets/separator.dart';
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';

class ProductScreenNew extends StatefulWidget {
  const ProductScreenNew({Key? key}) : super(key: key);

  @override
  State<ProductScreenNew> createState() => _ProductScreenNewState();
}

class _ProductScreenNewState extends State<ProductScreenNew> {
  final _incoming = Get.arguments;
  dynamic _data = [];
  bool _isSaved = false;
  int scrollIndex = 1;
  List<int> list = [1, 2, 3, 4, 5];
  final _cartCtrl = Get.put(CartController());
  final _navCtrl = Get.put(NavigationController());
  @override
  void initState() {
    super.initState();
    setState(() {
      _data = _incoming["data"];
      _isSaved = _cartCtrl.savedList.contains(_data["id"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomHeader(
        customActions: IconButton(
          icon: Badge(
            animationType: BadgeAnimationType.scale,
            position: const BadgePosition(top: -12, end: -8),
            badgeContent: CustomText(
              text: _cartCtrl.cartList.length.toString(),
              color: MyColors.white,
            ),
            child: Icon(
              IconlyLight.buy,
              color: MyColors.black,
              size: 20,
            ),
          ),
          onPressed: () {
            Get.back();
            Get.back();
            _navCtrl.onItemTapped(2);
          },
        ),
        title: "Бүтээгдэхүүн",
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    transitionOnUserGestures: true,
                    tag: _data,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        enableInfiniteScroll: false,
                        initialPage: 0,
                        aspectRatio: 1,
                        viewportFraction: 1,
                        scrollPhysics: const BouncingScrollPhysics(),
                        onPageChanged: (index, reason) {
                          setState(() {
                            scrollIndex = index + 1;
                          });
                        },
                      ),
                      items: list
                          .map(
                            (item) => CachedImage(
                              image: "${URL.AWS}/products/$item.png",
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          color: MyColors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4)),
                      child: CustomText(
                        text: "$scrollIndex/${list.length}",
                        color: MyColors.white,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "${_data["name"]}",
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: convertToCurrencyFormat(
                          double.parse("${_data["price"]}"),
                          toInt: true,
                          locatedAtTheEnd: true),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 24),
                    const MySeparator(color: MyColors.grey),
                    const SizedBox(height: 24),
                    CustomText(text: "Порц:"),
                    SizedBox(height: 12),
                    CustomText(text: "Орц:")
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          width: Get.width,
          height: Get.height * .09,
          color: MyColors.white,
          padding: EdgeInsets.symmetric(horizontal: Get.width * .03),
          child: Row(
            children: [
              Expanded(
                child: CustomButton(
                  isActive: !_isSaved,
                  onPressed: () {
                    _cartCtrl.saveProduct(_data, context);
                    _isSaved = !_isSaved;
                    setState(() {});
                  },
                  text: _isSaved ? "Хадгалсан" : "Хадгалах",
                  textColor: MyColors.primary,
                  elevation: 0,
                  bgColor: MyColors.fadedGrey,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  onPressed: () {
                    _cartCtrl.addProduct(_data, context);
                  },
                  text: "Сагсанд нэмэх",
                  textColor: MyColors.white,
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CachedImage extends StatelessWidget {
  final String image;
  final double width;
  final double height;
  const CachedImage({
    required this.image,
    this.width = 0,
    this.height = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      progressIndicatorBuilder: (context, url, downloadProgress) => SizedBox(
        width: width,
        height: height,
        child: Shimmer.fromColors(
          baseColor: MyColors.fadedGrey,
          highlightColor: MyColors.fadedGrey,
          child: Container(
            width: Get.width * .3,
            height: Get.width * .3,
            color: Colors.white,
          ),
        ),
      ),
      errorWidget: (context, url, error) =>
          const Image(image: AssetImage("assets/images/png/no_image.png")),
    );
  }
}
