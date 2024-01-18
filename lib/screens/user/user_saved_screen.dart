import 'dart:developer';
import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/custom_dialogs.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';

import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';

class UserSavedScreen extends StatefulWidget {
  const UserSavedScreen({Key? key}) : super(key: key);

  @override
  State<UserSavedScreen> createState() => _UserSavedScreenState();
}

class _UserSavedScreenState extends State<UserSavedScreen> {
  int page = 1;
  bool loading = false;
  List saved = [];
  bool hasMore = true;
  Map pagination = {};
  int total = 0;
  final _navCtx = Get.put(NavigationController());
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getUserSavedProducts();
    scrollHandler();
  }

  Future<void> getUserSavedProducts() async {
    loading = true;
    var query = {"page": page};
    dynamic getUserSavedProducts = await UserApi().getUserSavedProducts(query);
    loading = false;
    if (getUserSavedProducts != null) {
      dynamic response = Map<String, dynamic>.from(getUserSavedProducts);
      if (response["success"]) {
        saved = saved + response["data"];
      }
      pagination = response["pagination"];
      total = pagination["total"];
      if (pagination["pageCount"] > page) {
        hasMore = true;
      } else {
        hasMore = false;
      }
    }
    if (mounted) {
      setState(() {
        // Your state change code goes here
      });
    }
  }

  void scrollHandler() {
    scrollController.addListener(
      () {
        if (scrollController.position.maxScrollExtent ==
                scrollController.offset &&
            hasMore) {
          page++;
          setState(() {});
          log(page.toString());
          getUserSavedProducts();
        }
      },
    );
  }

  Future<void> removeItem(Map item) async {
    CustomDialogs().showLoadingDialog();
    dynamic deleteUserSavedProduct =
        await UserApi().deleteUserSavedProduct(item["id"]);
    Get.back();
    if (deleteUserSavedProduct != null) {
      dynamic response = Map<String, dynamic>.from(deleteUserSavedProduct);
      if (response["success"]) {
        saved.remove(item);
        total -= 1;
        setState(() {});
      } else {
        customSnackbar(ActionType.error, "Алдаа гарлаа", 2);
      }
    }
  }

  void addToCart(int productId, int storeId) async {
    CustomDialogs().showLoadingDialog();
    dynamic addToCart = await UserApi().addToCart(productId, storeId);
    Get.back();
    if (addToCart != null) {
      dynamic response = Map<String, dynamic>.from(addToCart);
      if (response["success"]) {
        Map product = saved.firstWhere((element) => element["id"] == productId);
        int index = saved.indexOf(product);
        saved[index]["inCart"] = true;
        setState(() {});
        customSnackbar(ActionType.success, "Сагсанд нэмэгдлээ", 2);
      } else {
        handleAddCartError(
          response["errorType"],
          response["errorText"],
          productId,
          storeId,
        );
      }
    }
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
              customSnackbar(ActionType.success, "Сагсанд нэмэгдлээ", 2);
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
    if (errorType == "not_enought") {
      log("NOt enough!");
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
          title:
              saved.isNotEmpty ? "Таны хадгалсан ($total)" : "Таны хадгалсан",
          customActions: Container(),
          body: loading && saved.isEmpty
              ? listShimmerWidget()
              : !loading && saved.isEmpty
                  ? customEmptyWidget("Хадгалсан бараа байхгүй байна")
                  : RefreshIndicator(
                      color: MyColors.primary,
                      onRefresh: () async {
                        saved.clear();
                        page = 1;
                        await Future.delayed(const Duration(milliseconds: 600));
                        setState(() {});
                        getUserSavedProducts();
                      },
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            width: double.infinity,
                            height: Get.height * .008,
                            decoration:
                                BoxDecoration(color: MyColors.fadedGrey),
                          );
                        },
                        itemCount: hasMore ? saved.length + 1 : saved.length,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          if (index < saved.length) {
                            var item = saved[index];
                            return listItemWidget(item, () {
                              addToCart(item["id"], item["store"]);
                            }, () {
                              removeItem(item);
                            });
                          } else if (hasMore) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: itemShimmer(),
                            ));
                          } else {
                            return Container();
                          }
                        },
                      ),
                    )),
    );
  }

  Widget listItemWidget(
      Map item, VoidCallback onClicked1, VoidCallback onClicked2) {
    return SizedBox(
      height: Get.height * .11,
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
            width: Get.width * .6,
            height: Get.height * .11,
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
                Row(
                  children: [
                    Text(convertToCurrencyFormat(item["price"])),
                    SizedBox(width: Get.width * .04),
                    Container(
                      width: 1,
                      height: 16,
                      color: MyColors.grey,
                    ),
                    SizedBox(width: Get.width * .04),
                    customTextButton(
                      onClicked1,
                      IconlyLight.buy,
                      "Сагслах",
                      isActive: !item["inCart"],
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ElevatedButton(
              style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll<double>(0),
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.white)),
              onPressed: onClicked2,
              child: const Center(
                child: Icon(
                  IconlyLight.delete,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget customTextButton(VoidCallback onPressed, IconData icon, String text,
    {bool isActive = true}) {
  return ElevatedButton(
    style: ButtonStyle(
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      elevation: const MaterialStatePropertyAll<double>(0),
      backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
      overlayColor: MaterialStatePropertyAll<Color>(
        Colors.black.withOpacity(0.1),
      ),
      padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
    ),
    onPressed: isActive ? onPressed : null,
    child: Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isActive ? MyColors.black : MyColors.background,
        ),
        const SizedBox(width: 8),
        CustomText(
          text: text,
          fontSize: 12,
          color: isActive ? MyColors.black : MyColors.background,
        ),
      ],
    ),
  );
}
