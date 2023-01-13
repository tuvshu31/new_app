import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/screens/store/edit_products/edit_product_info.dart';
import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/bottom_sheet.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class EditProducts extends StatefulWidget {
  const EditProducts({super.key});

  @override
  State<EditProducts> createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  dynamic _products = {};
  dynamic _selected = {};
  bool loading = false;
  TextEditingController leftOverController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserProducts();
  }

  Future<void> getUserProducts() async {
    loading = true;
    var query = {"store": RestApiHelper.getUserId()};
    dynamic products = await RestApi().getProducts(query);
    dynamic data = Map<String, dynamic>.from(products);
    loading = false;
    if (data["success"]) {
      _products = data["data"];
    }
    setState(() {});
  }

  void productUpdateHelper(dynamic body) async {
    loadingDialog(context);
    dynamic product = await RestApi().updateProduct(body["id"], body);
    dynamic data = Map<String, dynamic>.from(product);
    Get.back();
    if (data["success"]) {
      successSnackBar("Амжилттай засагдлаа", 2, context);
    } else {
      errorSnackBar("Үл мэдэгдэх алдаа гарлаа", 2, context);
    }
  }

  void productDeleteHelper(dynamic body) async {
    loadingDialog(context);
    dynamic product = await RestApi().deleteProduct(body["id"]);
    dynamic data = Map<String, dynamic>.from(product);
    Get.back();
    if (product != null) {
      if (data["success"]) {
        successSnackBar("Амжилттай устгалаа", 2, context);
      } else {
        errorSnackBar("Үл мэдэгдэх алдаа гарлаа", 2, context);
      }
    } else {
      errorSnackBar(
          "Уучлаарай энэ бараа захиалагдсан тул устгах боломжгүй байна",
          3,
          context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return !loading && _products.isEmpty
        ? const CustomLoadingIndicator(text: "Хадгалсан бараа байхгүй байна")
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _products.isEmpty ? 8 : _products.length,
            itemBuilder: (context, index) {
              var data = _products[index];
              List ontap = [
                () {
                  Get.back();
                  Get.to(() => const EditProductInfo(), arguments: data);
                },
                () {
                  Get.back();
                  setState(() {
                    data["visibility"] = !data["visibility"];
                  });
                  productUpdateHelper(
                      {...data, "visibility": data["visibility"]});
                },
                () {
                  Get.back();
                  changeLeftOverCount(
                      context, _products[index], leftOverController, () {
                    loadingDialog(context);
                    if (leftOverController.text.isEmpty) {
                      Get.back();
                    } else {
                      Get.back();
                      Get.back();
                      setState(() {
                        _products[index]["available"] = leftOverController.text;
                      });
                      productUpdateHelper({
                        ..._products[index],
                        "available": leftOverController.text
                      });
                    }
                  });
                },
                () {
                  Get.back();
                  deleteProduct(context, data, () {
                    Get.back();
                    productDeleteHelper(_products[index]);
                    setState(() {
                      _products.remove(_products[index]);
                    });
                  });
                }
              ];
              if (_products.isEmpty) {
                return MyShimmers().listView();
              } else {
                return Container(
                  margin: EdgeInsets.all(Get.width * .03),
                  height: Get.height * .13,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: Get.width * .25,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: _products[index]["visibility"]
                            ? CachedImage(
                                image:
                                    "${URL.AWS}/products/${data["id"]}/small/1.png")
                            : Stack(
                                children: [
                                  CachedImage(
                                      image:
                                          "${URL.AWS}/products/${data["id"]}/small/1.png"),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color:
                                              MyColors.black.withOpacity(0.5)),
                                      child: Icon(
                                        IconlyLight.hide,
                                        size: Get.width * .1,
                                        color: MyColors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      SizedBox(width: Get.width * .045),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomText(
                              text: data["name"],
                              overflow: TextOverflow.ellipsis,
                            ),
                            CustomText(
                                fontSize: 12,
                                text: "Үнэ: ${convertToCurrencyFormat(
                                  double.parse(data["price"]),
                                  toInt: true,
                                  locatedAtTheEnd: true,
                                )}"),
                            CustomText(
                                fontSize: 12,
                                text: "Үлдэгдэл: ${data["available"]}")
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Get.width * .15,
                        child: Center(
                            child: CustomInkWell(
                          onTap: (() {
                            editProductBottomSheet(ontap, data["visibility"]);
                          }),
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: MyColors.fadedGrey,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              IconlyLight.edit,
                              size: 18,
                            ),
                          ),
                        )),
                      ),
                    ],
                  ),
                );
              }
            });
  }
}
