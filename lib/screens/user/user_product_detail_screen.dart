import 'dart:developer';

import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/custom_dialogs.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/button.dart';

class UserProductDetailScreen extends StatefulWidget {
  const UserProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<UserProductDetailScreen> createState() =>
      _UserProductDetailScreenState();
}

class _UserProductDetailScreenState extends State<UserProductDetailScreen> {
  final _arguments = Get.arguments;
  bool loading = false;
  bool loadingInfo = false;
  bool isStoreOpen = false;
  int cartCount = 0;
  Map data = {};
  Map info = {};
  List<Widget> images = [];
  int scrolledImage = 1;
  final _navCtx = Get.put(NavigationController());

//Cart Animation-tai holbootoi
  GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
  final GlobalKey widgetKey = GlobalKey();
  late Function(GlobalKey) runAddToCartAnimation;

  @override
  void initState() {
    super.initState();
    getProductDetails();
    getProductAvailableInfo();
  }

  void listClick(GlobalKey widgetKey) async {
    await runAddToCartAnimation(widgetKey);
    await cartKey.currentState!.runCartAnimation();
  }

  void getProductDetails() async {
    loading = true;
    dynamic getProductDetails =
        await UserApi().getProductDetails(_arguments["id"]);
    if (getProductDetails != null) {
      log("getProductDetails: $getProductDetails");
      dynamic response = Map<String, dynamic>.from(getProductDetails);
      if (response["success"]) {
        data = response["data"];
        images.add(Image.network(data["image"]));
      }
    }
    loading = false;
    setState(() {});
  }

  void getProductAvailableInfo() async {
    loadingInfo = true;
    dynamic getProductAvailableInfo = await UserApi()
        .getProductAvailableInfo(_arguments["store"], _arguments["id"]);
    loadingInfo = false;
    if (getProductAvailableInfo != null) {
      dynamic response = Map<String, dynamic>.from(getProductAvailableInfo);
      if (response["success"]) {
        info = response["data"];
        cartCount = info["inCart"];
        isStoreOpen = info["isOpen"];
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void addToCart(int productId, int storeId) async {
    CustomDialogs().showLoadingDialog();
    dynamic addToCart = await UserApi().addToCart(productId, storeId);
    Get.back();
    if (addToCart != null) {
      dynamic response = Map<String, dynamic>.from(addToCart);
      if (response["success"]) {
        listClick(widgetKey);
        Future.delayed(const Duration(milliseconds: 1600), () {
          cartCount++;
          setState(() {});
        });
      } else {
        handleAddCartError(
          response["errorType"],
          response["errorText"],
          productId,
          storeId,
        );
      }
    }
    setState(() {});
  }

  void handleAddCartError(
      String errorType, String errorText, int productId, int storeId) {
    if (errorType == "same_store") {
      showMyCustomDialog(
        true,
        ActionType.warning,
        errorText,
        () async {
          Get.back();
          dynamic emptyAndAddToCart =
              await UserApi().emptyAndAddToCart(productId, storeId);
          if (emptyAndAddToCart != null) {
            dynamic response = Map<String, dynamic>.from(emptyAndAddToCart);
            if (response["success"]) {
              listClick(widgetKey);
              Future.delayed(const Duration(milliseconds: 1600), () {
                cartCount = 1;
                setState(() {});
              });
            } else {
              customSnackbar(ActionType.error, "Алдаа гарлаа", 2);
            }
          }
        },
        Container(),
        okText: "Нэмэх",
        cancelText: "Хаах",
      );
    }
    if (errorType == "not_enough") {
      customSnackbar(ActionType.error, "Барааны үлдэгдэл хүрэлцэхгүй байна", 2);
    }
  }

  void addToSaved(int productId) async {
    dynamic addToSaved = await UserApi().addToSaved(productId);
    if (addToSaved != null) {
      dynamic response = Map<String, dynamic>.from(addToSaved);
      if (response["success"]) {
        info["isSaved"] = response["isSaved"];
        setState(() {});
      } else {
        customSnackbar(ActionType.error, "Алдаа гарлаа", 2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? _shimmerScreenWidget()
        : AddToCartAnimation(
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
                            tag: _arguments["id"],
                            child: customImage(Get.width, data["image"],
                                isSquare: true),
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
                              text: "$scrolledImage/${images.length}",
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
                                _backButton(),
                                Row(
                                  children: [
                                    _saveButton(),
                                    SizedBox(width: Get.width * .05),
                                    AddToCartIcon(
                                      key: cartKey,
                                      icon: CustomInkWell(
                                        borderRadius: BorderRadius.circular(50),
                                        onTap: () {
                                          Get.back();
                                          Get.back();
                                          _navCtx.onItemTapped(2);
                                        },
                                        child: Material(
                                          elevation: 2,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Stack(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: Icon(
                                                    IconlyLight.buy,
                                                    size: 20,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 4,
                                                  right: 4,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: MyColors.primary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: AnimatedDigitWidget(
                                                      duration: const Duration(
                                                          milliseconds: 200),
                                                      value: cartCount,
                                                      animateAutoSize: true,
                                                      autoSize: true,
                                                      textStyle:
                                                          const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
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
                      padding: const EdgeInsets.only(
                          right: 24, left: 24, bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Get.width * .7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 12),
                                    CustomText(
                                      text: data["name"],
                                      isUpperCase: true,
                                    ),
                                    const SizedBox(height: 8),
                                    CustomText(
                                      text: convertToCurrencyFormat(
                                          data["price"]),
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                              ),
                              data["salePercent"] > 0
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            "- ${data["salePercent"]}%",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          convertToCurrencyFormat(
                                              data["oldPrice"]),
                                          style: const TextStyle(
                                            color: MyColors.gray,
                                            fontSize: 13,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          data["otherInfo"].isNotEmpty
                              ? ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 12);
                                  },
                                  padding: const EdgeInsets.only(top: 8),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data["otherInfo"].length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var item = Map<String, dynamic>.from(
                                        data["otherInfo"][index]);
                                    var key =
                                        removeBracket(item.keys.toString());
                                    var value =
                                        removeBracket(item.values.toString());
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: "$key:",
                                        ),
                                        const SizedBox(height: 2),
                                        CustomText(
                                          text: value,
                                          color: MyColors.gray,
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : Container(),
                          SizedBox(height: Get.height * .1),
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
                      if (isStoreOpen) {
                        addToCart(_arguments["id"], _arguments["store"]);
                      } else {
                        customSnackbar(
                          ActionType.error,
                          "Байгууллага хаалттай байна",
                          3,
                        );
                      }
                    },
                    text: "Сагсанд нэмэх",
                    textColor: MyColors.white,
                    elevation: 0,
                    bgColor: !loadingInfo && isStoreOpen
                        ? MyColors.primary
                        : MyColors.background,
                  ),
                ),
              ),
            ),
          );
  }

  Widget _shimmerScreenWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CustomShimmer(
                  width: Get.width,
                  height: Get.width,
                  borderRadius: 0,
                ),
                Positioned(
                  left: 24,
                  top: MediaQuery.of(context).viewPadding.top + 12,
                  child: _backButton(),
                )
              ],
            ),
            const SizedBox(height: 12),
            CustomShimmer(width: Get.width * .9, height: 16),
            const SizedBox(height: 12),
            CustomShimmer(width: Get.width * .9, height: 16),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            CustomShimmer(width: Get.width * .9, height: 16),
            const SizedBox(height: 12),
            CustomShimmer(width: Get.width * .9, height: 16),
            const SizedBox(height: 12),
            CustomShimmer(width: Get.width * .9, height: 16),
            const SizedBox(height: 12),
            CustomShimmer(width: Get.width * .9, height: 16),
          ],
        ),
      ),
      bottomSheet: Container(
        width: Get.width,
        height: Get.height * .09,
        color: MyColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Center(
          child: CustomButton(
            text: "Сагсанд нэмэх",
            textColor: MyColors.white,
            elevation: 0,
            bgColor: MyColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return Material(
      borderRadius: BorderRadius.circular(50),
      elevation: 2,
      child: CustomInkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () => Get.back(),
        child: Container(
          decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(
              IconlyLight.arrow_left,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return Material(
      borderRadius: BorderRadius.circular(50),
      elevation: 2,
      child: CustomInkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () => addToSaved(_arguments["id"]),
        child: Container(
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: info.isEmpty
                  ? const Icon(
                      IconlyLight.star,
                      size: 20,
                      color: MyColors.gray,
                    )
                  : !info["isSaved"]
                      ? const Icon(
                          IconlyLight.star,
                          size: 20,
                          color: MyColors.black,
                        )
                      : const Icon(
                          IconlyBold.star,
                          size: 20,
                          color: Colors.amber,
                        ),
            )),
      ),
    );
  }
}
