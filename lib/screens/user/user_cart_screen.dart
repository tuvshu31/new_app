import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/screens/user/user_saved_screen.dart';

class UserCartScreen extends StatefulWidget {
  const UserCartScreen({Key? key}) : super(key: key);

  @override
  State<UserCartScreen> createState() => _UserCartScreenState();
}

class _UserCartScreenState extends State<UserCartScreen> {
  List cart = [];
  Map amount = {};
  bool loading = false;
  int loadingId = 0;
  final _navCtx = Get.put(NavigationController());

  @override
  void initState() {
    super.initState();
    getUserCartProducts();
  }

  void addToCart(int productId, int storeId) async {
    loadingId = productId;
    dynamic addToCart = await UserApi().addToCart(productId, storeId);
    loadingId = 0;
    if (addToCart != null) {
      dynamic response = Map<String, dynamic>.from(addToCart);
      if (response["success"]) {
        Map product = cart.firstWhere((element) => element["id"] == productId);
        int index = cart.indexOf(product);
        cart[index]["quantity"] += 1;
        cart[index]["totalPrice"] += cart[index]["price"];
        amount["total"] += cart[index]["price"];
        amount["subTotal"] += cart[index]["price"];
      }
    }
    setState(() {});
  }

  void removeFromCart(int productId) async {
    loadingId = productId;
    dynamic addToCart = await UserApi().removeFromCart(productId);
    loadingId = 0;
    if (addToCart != null) {
      dynamic response = Map<String, dynamic>.from(addToCart);
      if (response["success"]) {
        Map product = cart.firstWhere((element) => element["id"] == productId);
        int index = cart.indexOf(product);
        cart[index]["quantity"] -= 1;
        cart[index]["totalPrice"] -= cart[index]["price"];
        amount["total"] -= cart[index]["price"];
        amount["subTotal"] -= cart[index]["price"];
      }
    }
    setState(() {});
  }

  void getUserCartProducts() async {
    loading = true;
    dynamic getUserCartProducts = await UserApi().getUserCartProducts();
    loading = false;
    if (getUserCartProducts != null) {
      dynamic response = Map<String, dynamic>.from(getUserCartProducts);
      if (response["success"]) {
        cart = response["data"];
        amount = response["amount"];
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void deleteFromCart(int productId) async {
    CustomDialogs().showLoadingDialog();
    dynamic deleteFromCart = await UserApi().deleteFromCart(productId);
    Get.back();
    if (deleteFromCart != null) {
      dynamic response = Map<String, dynamic>.from(deleteFromCart);
      if (response["success"]) {
        Map product = cart.firstWhere((element) => element["id"] == productId);
        amount["total"] -= product["totalPrice"];
        amount["subTotal"] -= product["totalPrice"];
        cart.removeWhere((element) => element["id"] == productId);
        setState(() {});
      } else {
        customSnackbar(ActionType.error, "Алдаа гарлаа", 2);
      }
    }
  }

  void emptyTheCart() async {
    showCustomDialog(
        ActionType.warning, "Та сагсаа хоослохдоо итгэлтэй байна уу?",
        () async {
      Get.back();
      CustomDialogs().showLoadingDialog();
      dynamic emptyTheCart = await UserApi().emptyTheCart();
      Get.back();
      if (emptyTheCart != null) {
        dynamic response = Map<String, dynamic>.from(emptyTheCart);
        if (response["success"]) {
          cart.clear();
          setState(() {});
        } else {
          customSnackbar(ActionType.error, "Алдаа гарлаа", 2);
        }
      }
    });
  }

  void addToSaved(int productId, int storeId) async {
    CustomDialogs().showLoadingDialog();
    dynamic addToSaved = await UserApi().addToSaved(productId);
    Get.back();
    if (addToSaved != null) {
      dynamic response = Map<String, dynamic>.from(addToSaved);
      if (response["success"]) {
        int index = cart.indexWhere((element) => element["id"] == productId);
        cart[index]["inSaved"] = true;
        setState(() {});
        customSnackbar(ActionType.success, "Амжилттай хадгаллаа", 2);
      } else {
        customSnackbar(ActionType.error, "Алдаа гарлаа", 2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navCtx.onItemTapped(0);
        return false;
      },
      child: CustomHeader(
          isMainPage: true,
          title: cart.isNotEmpty
              ? "Таны сагсанд (${cart.length})"
              : "Таны сагсанд",
          customActions: cart.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    customTextButton(
                      () => emptyTheCart(),
                      IconlyLight.delete,
                      "Хоослох",
                    ),
                    const SizedBox(
                      width: 16,
                    )
                  ],
                )
              : Container(),
          actionWidth: Get.width * .3,
          bottomSheet: cart.isNotEmpty ? _bottomSheet() : null,
          body: loading && cart.isEmpty
              ? listShimmerWidget()
              : !loading && cart.isEmpty
                  ? customEmptyWidget("Таны сагс хоосон байна")
                  : SizedBox(
                      height: Get.height * .73,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            width: double.infinity,
                            height: Get.height * .008,
                            decoration:
                                BoxDecoration(color: MyColors.fadedGrey),
                          );
                        },
                        physics: const BouncingScrollPhysics(),
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          Map item = cart[index];
                          return listItemWidget(item);
                        },
                      ),
                    )),
    );
  }

  Widget listItemWidget(Map item) {
    return SizedBox(
      height: Get.height * .13,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: Get.width * .04),
          GestureDetector(
              onTap: () {
                Get.toNamed(userProductDetailScreenRoute, arguments: {
                  "id": item["id"],
                  "store": item["store"],
                  "storeName": item["storeName"],
                });
              },
              child:
                  customImage(Get.width * .2, item["image"], isCircle: true)),
          SizedBox(width: Get.width * .04),
          SizedBox(
            width: Get.width * .5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                  text: item["name"],
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Get.height * .01),
                CustomText(
                  text: item["storeName"],
                  fontSize: 13,
                  color: MyColors.gray,
                ),
                const Spacer(),
                CustomText(
                  text:
                      "Нийт үнэ: ${convertToCurrencyFormat(item["totalPrice"])}",
                  fontSize: 13,
                ),
                Row(
                  children: [
                    customTextButton(
                      () => addToSaved(item["id"], item["store"]),
                      !item["inSaved"] ? IconlyLight.star : IconlyBold.star,
                      !item["inSaved"] ? "Хадгалах" : "Хадгалсан",
                      isActive: !item["inSaved"],
                    ),
                    SizedBox(width: Get.width * .04),
                    Container(
                      width: 1,
                      height: 16,
                      color: MyColors.grey,
                    ),
                    SizedBox(width: Get.width * .04),
                    customTextButton(
                      () => deleteFromCart(item["id"]),
                      IconlyLight.delete,
                      "Устгах",
                    )
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _controllerButton(
                () => addToCart(item["id"], item["store"]),
                Icons.add_rounded,
                item["quantity"] < item["available"],
              ),
              loadingId == item["id"]
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: MyColors.gray,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      "${item["quantity"] ?? "1"}",
                      style: const TextStyle(fontSize: 12),
                    ),
              _controllerButton(
                () => removeFromCart(item["id"]),
                Icons.remove_rounded,
                item["quantity"] > 1,
              ),
            ],
          ),
          SizedBox(width: Get.width * .01),
        ],
      ),
    );
  }

  Widget _controllerButton(
      VoidCallback onPressed, IconData icon, bool isActive) {
    return ElevatedButton(
      onPressed: isActive ? onPressed : null,
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        elevation: const MaterialStatePropertyAll<double>(0),
        backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
        overlayColor: MaterialStatePropertyAll<Color>(
          Colors.black.withOpacity(0.1),
        ),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.black : MyColors.grey,
        size: 20,
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
                    text: convertToCurrencyFormat(
                      amount["total"],
                    ),
                  ),
                  SizedBox(height: Get.height * .005),
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
                Get.toNamed(userCartAddressScreenRoute,
                    arguments: {"total": amount["total"]});
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
                  text: convertToCurrencyFormat(amount["subTotal"]),
                  color: MyColors.gray,
                )
              ],
            ),
            SizedBox(height: Get.height * .02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: "Хүргэлтийн төлбөр:",
                  color: MyColors.gray,
                ),
                CustomText(
                  text: convertToCurrencyFormat(amount["deliveryPrice"]),
                  color: MyColors.gray,
                )
              ],
            ),
            SizedBox(height: Get.height * .02),
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
            SizedBox(height: Get.height * .02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(text: "Нийт үнэ:"),
                CustomText(
                  text: convertToCurrencyFormat(amount["total"]),
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
