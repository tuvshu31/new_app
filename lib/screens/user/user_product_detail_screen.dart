import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';

class UserProductDetailScreen extends StatefulWidget {
  const UserProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<UserProductDetailScreen> createState() =>
      _UserProductDetailScreenState();
}

class _UserProductDetailScreenState extends State<UserProductDetailScreen> {
  final _incoming = Get.arguments;
  dynamic _data = [];
  bool _isSaved = false;
  int scrollIndex = 1;
  List<int> list = [1];
  String ports = "";
  String orts = "";
  String descriptions = "";
  final _cartCtrl = Get.put(CartController());
  final _navCtrl = Get.put(NavigationController());

//Cart Animation-tai holbootoi
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  final GlobalKey widgetKey = GlobalKey();
  late Function(GlobalKey) runAddToCartAnimation;
  var _cartQuantityItems = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _data = _incoming["data"];
      _isSaved = _cartCtrl.savedList.contains(_data["id"]);
      List otherInfo = _data["otherInfo"] ?? [];
      if (otherInfo.isNotEmpty) {
        for (Map element in otherInfo) {
          var key = removeBracket(element.keys.toString());
          log(key.toString());
        }
      }
    });
    imgCount();
  }

  void imgCount() async {
    dynamic response = await RestApi().getProductImgCount(_data["id"]);
    dynamic d = Map<String, dynamic>.from(response);
    setState(() {
      list = List<int>.generate(d["data"], (i) => i + 1);
    });
  }

  void listClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
    await cartKey.currentState!
        .runCartAnimation((++_cartQuantityItems).toString());
  }

  @override
  Widget build(BuildContext context) {
    return AddToCartAnimation(
      cartKey: cartKey,
      height: 30,
      width: 30,
      opacity: 0.85,
      dragAnimation: const DragToCartAnimationOptions(
          rotation: false, duration: Duration(milliseconds: 500)),
      jumpAnimation: const JumpAnimationOptions(),
      createAddToCartAnimation: (runAddToCartAnimation) {
        this.runAddToCartAnimation = runAddToCartAnimation;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    key: widgetKey,
                    child: Hero(
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
                              .map((item) => CachedImage(
                                  image:
                                      "${URL.AWS}/products/${_data["id"]}/large/$item.png"))
                              .toList()),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          color: MyColors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(25)),
                      child: CustomText(
                        text: "$scrollIndex/${list.length}",
                        color: MyColors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).viewPadding.top + 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      width: Get.width,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _topButton(
                            () => Get.back(),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                IconlyLight.arrow_left,
                                size: 20,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              _topButton(
                                () {
                                  Get.back();
                                },
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    IconlyBold.star,
                                    size: 20,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              SizedBox(width: Get.width * .05),
                              AddToCartIcon(
                                key: cartKey,
                                icon: CustomInkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    Get.back();
                                    Get.back();
                                    _navCtrl.onItemTapped(2);
                                  },
                                  child: Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(50),
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
                                              child: Obx(
                                                () => AnimatedDigitWidget(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  value: _cartCtrl
                                                      .cartItemCount.value,
                                                  animateAutoSize: true,
                                                  autoSize: true,
                                                  textStyle: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                badgeOptions: const BadgeOptions(
                                  active: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomImage(
                          width: 24,
                          height: 24,
                          url: "${URL.AWS}/users/${_data["store"]}/small/1.png",
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          text: "${_data["storeName"]}",
                          fontSize: 15,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Icon(
                                IconlyLight.arrow_right_2,
                                size: 20,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    CustomText(
                      text: "${_data["name"]}",
                      isUpperCase: true,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text: convertToCurrencyFormat(
                          double.parse("${_data["price"]}"),
                          toInt: true,
                          locatedAtTheEnd: true),
                      fontSize: 14,
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                    otherInfoWidget()
                  ],
                ),
              )
            ],
          ),
        ),
        bottomSheet: Container(
          width: Get.width,
          height: Get.height * .09,
          color: MyColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: CustomButton(
              onPressed: () {
                listClick(widgetKey);
                Future.delayed(const Duration(milliseconds: 1700), () {
                  _cartCtrl.addProduct(_data, context);
                  setState(() {});
                });
              },
              text: "Сагсанд нэмэх",
              textColor: MyColors.white,
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _topButton(dynamic onClick, Widget child) {
    return Material(
      borderRadius: BorderRadius.circular(50),
      elevation: 2,
      child: CustomInkWell(
        onTap: onClick,
        child: Container(
          decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget otherInfoWidget() {
    return Column(
      children: [
        Row(
          children: [
            ports.isNotEmpty ? Text("Ports") : Container(),
            orts.isNotEmpty ? Text("Orts") : Container(),
          ],
        ),
        descriptions.isNotEmpty
            ? CustomText(
                textAlign: TextAlign.justify,
                color: MyColors.gray,
                fontSize: 12,
                text: descriptions,
              )
            : Container()
      ],
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
