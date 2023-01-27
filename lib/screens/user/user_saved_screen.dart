import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/product_controller.dart';
import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/products.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:iconly/iconly.dart';

class UserSavedScreen extends StatefulWidget {
  const UserSavedScreen({Key? key}) : super(key: key);

  @override
  State<UserSavedScreen> createState() => _UserSavedScreenState();
}

class _UserSavedScreenState extends State<UserSavedScreen> {
  bool loading = false;
  int page = 1;
  dynamic saved = [];
  bool hasMore = true;
  dynamic closedStoreList = [];
  final _cartCtrl = Get.put(CartController());

  void getUserProducts() async {
    loading = true;
    dynamic response =
        await RestApi().getUserProducts(RestApiHelper.getUserId(), {"page": 1});
    dynamic d = Map<String, dynamic>.from(response);
    saved = saved + d['data'];
    closedStoreList = d["closedStoreList"];
    if (d["data"].length < d["pagination"]["limit"]) {
      hasMore = false;
    }
    loading = false;
    setState(() {});
  }

  void deleteProduct(dynamic data, context) async {
    loadingDialog(context);
    dynamic res = await RestApi().deleteUserProduct(
        {"userId": RestApiHelper.getUserId(), "productId": data['id']});
    Get.back();
    if (res != null) {
      dynamic delete = Map<String, dynamic>.from(res);
      if (delete["success"]) {
        setState(() {
          saved.remove(data);
          _cartCtrl.savedList.remove(data["id"]);
        });
      } else {
        errorSnackBar("Барааг устгахад алдаа гарлаа", 2, context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserProducts();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
        isMainPage: true,
        title: "Таны хадгалсан",
        customActions: Container(),
        subtitle: subtitle(loading, saved.length, "бараа"),
        body: !loading && saved.isEmpty
            ? const CustomLoadingIndicator(
                text: "Хадгалсан бараа байхгүй байна")
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: saved.length == 0 ? 8 : saved.length,
                itemBuilder: (context, index) {
                  if (saved.length == 0) {
                    return MyShimmers().listView();
                  } else {
                    bool storeClosed = closedStoreList
                        .any((el) => el == int.parse(saved[index]["store"]));
                    bool notVisible = !saved[index]["visibility"];
                    return Container(
                      margin: EdgeInsets.all(Get.width * .03),
                      height: Get.height * .13,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              storeClosed || notVisible
                                  ? null
                                  : Get.toNamed(
                                      '/ProductsRoute',
                                      arguments: {
                                        "data": saved[index],
                                      },
                                    );
                            },
                            child: Hero(
                              tag: saved[index],
                              transitionOnUserGestures: true,
                              child: Container(
                                width: Get.width * .25,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: _imageHandler(storeClosed, notVisible,
                                    saved[index]["id"]),
                                // child: CachedImage(
                                //     image:
                                //         "${URL.AWS}/products/${saved[index]["id"]}/small/1.png"),
                              ),
                            ),
                          ),
                          SizedBox(width: Get.width * .045),
                          Expanded(
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomText(
                                    text: storeClosed
                                        ? "Store closed"
                                        : saved[index]["name"],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  CustomText(
                                    text: saved[index]["storeName"],
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
                                        double.parse(saved[index]["price"]),
                                        toInt: true,
                                        locatedAtTheEnd: true,
                                      ))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: MyColors.background,
                                      ),
                                      Row(
                                        children: [
                                          TextButton.icon(
                                            style: TextButton.styleFrom(
                                                splashFactory:
                                                    NoSplash.splashFactory,
                                                foregroundColor: MyColors.black,
                                                padding: EdgeInsets.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                alignment:
                                                    Alignment.centerLeft),
                                            onPressed: () {
                                              storeClosed || notVisible
                                                  ? null
                                                  : _cartCtrl.addProduct(
                                                      saved[index], context);
                                            },
                                            icon: Icon(
                                              IconlyLight.buy,
                                              size: 16,
                                              color: storeClosed || notVisible
                                                  ? MyColors.gray
                                                  : MyColors.black,
                                            ),
                                            label: CustomText(
                                              text: "Сагслах",
                                              fontSize: 12,
                                              color: storeClosed || notVisible
                                                  ? MyColors.gray
                                                  : MyColors.black,
                                            ),
                                          ),
                                          SizedBox(width: Get.width * .03),
                                          Container(
                                            width: 1,
                                            height: 16,
                                            color: MyColors.black,
                                          ),
                                          SizedBox(width: Get.width * .03),
                                          TextButton.icon(
                                            style: TextButton.styleFrom(
                                                splashFactory:
                                                    NoSplash.splashFactory,
                                                foregroundColor: MyColors.black,
                                                padding: EdgeInsets.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                                alignment:
                                                    Alignment.centerLeft),
                                            onPressed: () {
                                              deleteProduct(
                                                  saved[index], context);
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
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: Get.width * .045),
                        ],
                      ),
                    );
                  }
                }));
  }

  Widget _imageHandler(bool storeClosed, bool notVisible, int id) {
    if (storeClosed) {
      return Stack(
        children: [
          Image.network(errorBuilder: (context, error, stackTrace) {
            return const Image(
                image: AssetImage("assets/images/png/no_image.png"));
          }, "${URL.AWS}/products/$id/small/1.png"),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: MyColors.black.withOpacity(0.5)),
              child: Center(
                  child: CustomText(
                text: "Дэлгүүр \ хаасан",
                textAlign: TextAlign.center,
                color: MyColors.white,
                fontSize: 14,
              )),
            ),
          ),
        ],
      );
    } else if (notVisible) {
      return Stack(
        children: [
          Image.network(errorBuilder: (context, error, stackTrace) {
            return const Image(
                image: AssetImage("assets/images/png/no_image.png"));
          }, "${URL.AWS}/products/$id/small/1.png"),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: MyColors.black.withOpacity(0.5)),
              child: Center(
                  child: CustomText(
                text: "Дууссан",
                textAlign: TextAlign.center,
                color: MyColors.white,
                fontSize: 14,
              )),
            ),
          ),
        ],
      );
    } else {
      return Image.network(errorBuilder: (context, error, stackTrace) {
        return const Image(image: AssetImage("assets/images/png/no_image.png"));
      }, "${URL.AWS}/products/$id/small/1.png");
    }
  }
}
