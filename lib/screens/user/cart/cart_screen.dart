import 'dart:developer';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/screens/user/order/order.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/separator.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:iconly/iconly.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int userId = RestApiHelper.getUserId();
  final _cartCtrl = Get.put(CartController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomHeader(
        customActions: Container(),
        isMainPage: true,
        title: "Таны сагсанд",
        subtitle: CustomText(
          text: "${_cartCtrl.cartList.length} бараа",
          fontSize: MyFontSizes.small,
          color: MyColors.gray,
        ),
        bottomSheet: _cartCtrl.cartList.isNotEmpty ? _bottomSheet() : null,
        body: _cartCtrl.cartList.isEmpty
            ? const CustomLoadingIndicator(text: "Таны сагс хоосон байна")
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _cartCtrl.cartList.length,
                        itemBuilder: (context, index) {
                          var data = _cartCtrl.cartList[index];
                          return Container(
                            margin: EdgeInsets.all(Get.width * .03),
                            height: Get.height * .13,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.toNamed(
                                    '/ProductsRoute',
                                    arguments: {
                                      "data": data,
                                    },
                                  ),
                                  child: Hero(
                                    tag: data,
                                    transitionOnUserGestures: true,
                                    child: Container(
                                      width: Get.width * .25,
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: CachedImage(
                                          image:
                                              "${URL.AWS}/products/${data["id"]}.png"),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Get.width * .045),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: data["name"],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      CustomText(
                                        text: data["storeName"],
                                        fontSize: 12,
                                        color: MyColors.gray,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const CustomText(
                                            text: "Нийт үнэ: ",
                                            fontSize: 12,
                                          ),
                                          CustomText(
                                              text: convertToCurrencyFormat(
                                            _cartCtrl.productSubtotal[index],
                                            toInt: true,
                                            locatedAtTheEnd: true,
                                          ))
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 1,
                                            width: double.infinity,
                                            color: MyColors.background,
                                          ),
                                          Obx(
                                            () => Row(
                                              children: [
                                                TextButton.icon(
                                                  style: TextButton.styleFrom(
                                                      splashFactory: NoSplash
                                                          .splashFactory,
                                                      foregroundColor:
                                                          MyColors.black,
                                                      padding: EdgeInsets.zero,
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      alignment:
                                                          Alignment.centerLeft),
                                                  onPressed: () {
                                                    _cartCtrl.saveProduct(
                                                        data, context);
                                                  },
                                                  icon: _cartCtrl.savedList
                                                          .contains(data["id"])
                                                      ? const Icon(
                                                          IconlyBold.star,
                                                          size: 16,
                                                          color:
                                                              MyColors.warning,
                                                        )
                                                      : const Icon(
                                                          IconlyLight.star,
                                                          size: 16,
                                                        ),
                                                  label: CustomText(
                                                    text: _cartCtrl.savedList
                                                            .contains(
                                                                data["id"])
                                                        ? "Хадгалсан"
                                                        : "Хадгалах",
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: Get.width * .03),
                                                Container(
                                                  width: 1,
                                                  height: 16,
                                                  color: MyColors.black,
                                                ),
                                                SizedBox(
                                                    width: Get.width * .03),
                                                TextButton.icon(
                                                  style: TextButton.styleFrom(
                                                      splashFactory: NoSplash
                                                          .splashFactory,
                                                      foregroundColor:
                                                          MyColors.black,
                                                      padding: EdgeInsets.zero,
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      alignment:
                                                          Alignment.centerLeft),
                                                  onPressed: () {
                                                    _cartCtrl.removeProduct(
                                                        data, context);
                                                  },
                                                  icon: const Icon(
                                                    IconlyLight.delete,
                                                    size: 16,
                                                  ),
                                                  label: const CustomText(
                                                    text: "Устгах",
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: Get.width * .045),
                                Container(
                                  width: 38,
                                  decoration: BoxDecoration(
                                      color: MyColors.fadedGrey,
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: IconButton(
                                            splashColor: Colors.transparent,
                                            onPressed: () {
                                              data["quantity"] ==
                                                      int.parse(
                                                          data["available"])
                                                  ? null
                                                  : _cartCtrl.increaseQuantity(
                                                      data, context);
                                            },
                                            icon: Icon(
                                              Icons.add,
                                              size: 16,
                                              color: data["quantity"] ==
                                                      int.parse(
                                                          data["available"])
                                                  ? MyColors.gray
                                                  : MyColors.black,
                                            )),
                                      ),
                                      CustomText(
                                        text: data["quantity"].toString(),
                                      ),
                                      Expanded(
                                        child: IconButton(
                                            splashColor: Colors.transparent,
                                            onPressed: (() {
                                              data["quantity"] == 1
                                                  ? null
                                                  : _cartCtrl
                                                      .decreaseQuantity(data);
                                            }),
                                            icon: Icon(
                                              Icons.remove,
                                              size: 16,
                                              color: data["quantity"] == 1
                                                  ? MyColors.grey
                                                  : MyColors.black,
                                            )),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                  SizedBox(height: Get.height * .09)
                ],
              ),
      ),
    );
  }

  Widget _bottomSheet() {
    return Container(
      width: Get.width,
      height: Get.height * .09,
      color: MyColors.white,
      padding: EdgeInsets.symmetric(horizontal: Get.width * .03),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _showPriceDetails,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: convertToCurrencyFormat(_cartCtrl.total,
                        toInt: true, locatedAtTheEnd: true),
                  ),
                  CustomText(
                    text: "Дэлгэрэнгүй",
                    fontSize: 12,
                    color: MyColors.gray,
                    isUnderLined: true,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: CustomButton(
              onPressed: () {
                Get.to(() => Order());
              },
              isFullWidth: false,
              text: "Төлбөр төлөх",
              textColor: MyColors.white,
              cornerRadius: 25,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  void _showPriceDetails() {
    Get.bottomSheet(Container(
      height: Get.height * .2,
      decoration: const BoxDecoration(
        color: MyColors.white,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Get.width * .03),
        padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "Барааны үнэ:"),
                CustomText(
                    text: convertToCurrencyFormat(
                  _cartCtrl.subTotal,
                  toInt: true,
                  locatedAtTheEnd: true,
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "Хүргэлтийн төлбөр:"),
                CustomText(
                    text: convertToCurrencyFormat(
                  _cartCtrl.deliveryCost,
                  toInt: true,
                  locatedAtTheEnd: true,
                ))
              ],
            ),
            MySeparator(color: MyColors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: "Нийт үнэ:"),
                CustomText(
                  text: convertToCurrencyFormat(
                    _cartCtrl.total,
                    toInt: true,
                    locatedAtTheEnd: true,
                  ),
                  color: MyColors.black,
                  fontWeight: FontWeight.bold,
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
