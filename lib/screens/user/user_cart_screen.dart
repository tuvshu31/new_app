import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/screens/user/user_cart_address_info_screen.dart';

class UserCartScreen extends StatefulWidget {
  const UserCartScreen({Key? key}) : super(key: key);

  @override
  State<UserCartScreen> createState() => _UserCartScreenState();
}

class _UserCartScreenState extends State<UserCartScreen> {
  int userId = RestApiHelper.getUserId();
  dynamic closedStoreList = [];
  bool productsAreOk = true;
  final _cartCtrl = Get.put(CartController());

  void getUserProducts() async {
    loadingDialog(context);
    dynamic response =
        await RestApi().getUserProducts(RestApiHelper.getUserId(), {"page": 1});
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      setState(() {
        closedStoreList = d["closedStoreList"];
      });
      if (closedStoreList.isNotEmpty) {
        for (var element in _cartCtrl.cartList) {
          closedStoreList.any((e) => e == int.parse(element["store"]))
              ? element["storeClosed"] = true
              : element["storeClosed"] = false;
        }
      }
      // productsAreOk = !_cartCtrl.cartList.any((element) =>
      //     element["storeOpen"] == false || element["visibility"] == false);
      // if (productsAreOk) {
      //   Get.to(() => const Order());
      // } else {
      //   errorSnackBar("Худалдан авах боломжгүй бараанууд байна", 4, context);
      // }
    }
    var query = {"id": []};
    dynamic products = await RestApi().getProducts(query);
    dynamic productResponse = Map<String, dynamic>.from(products);
    Get.back();
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
                                  // onTap: () => Get.toNamed(
                                  //   // userProductScreenRoute,
                                  //   arguments: {
                                  //     "data": data,
                                  //   },
                                  // ),
                                  child: Hero(
                                    tag: data,
                                    transitionOnUserGestures: true,
                                    child: CustomImage(
                                      width: Get.width * .25,
                                      height: Get.width * .25,
                                      url:
                                          "${URL.AWS}/products/${data["id"]}/small/1.png",
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
                  const CustomText(
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
                // getUserProducts();
                Get.to(() => const UserCartAddressInfoScreen());
              },
              isFullWidth: false,
              text: "Төлбөр төлөх",
              textColor: MyColors.white,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  void _showPriceDetails() {
    Get.bottomSheet(SafeArea(
      bottom: true,
      maintainBottomViewPadding: true,
      child: Container(
        padding: EdgeInsets.all(Get.width * .06),
        decoration: const BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Барааны үнэ:",
                  color: MyColors.gray,
                ),
                CustomText(
                  text: convertToCurrencyFormat(
                    _cartCtrl.subTotal,
                    toInt: true,
                    locatedAtTheEnd: true,
                  ),
                  color: MyColors.gray,
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Хүргэлтийн төлбөр:",
                  color: MyColors.gray,
                ),
                CustomText(
                  text: convertToCurrencyFormat(
                    _cartCtrl.deliveryCost,
                    toInt: true,
                    locatedAtTheEnd: true,
                  ),
                  color: MyColors.gray,
                )
              ],
            ),
            const SizedBox(height: 12),
            const DottedLine(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: MyColors.grey,
              dashRadius: 0.0,
              dashGapLength: 4.0,
              dashGapColor: Colors.transparent,
              dashGapRadius: 0.0,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(text: "Нийт үнэ:"),
                CustomText(
                  text: convertToCurrencyFormat(
                    _cartCtrl.total,
                    toInt: true,
                    locatedAtTheEnd: true,
                  ),
                  color: MyColors.black,
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
