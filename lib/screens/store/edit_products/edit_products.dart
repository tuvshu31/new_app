import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
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

  TextEditingController availableController = TextEditingController();

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
    return !loading && _products.length == 0
        ? const CustomLoadingIndicator(text: "Бараа байхгүй байна")
        : Column(
            children: [
              const SizedBox(height: 8),
              ListView.separated(
                separatorBuilder: (context, index) {
                  return Container(height: 8);
                },
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: _products.length == 0 ? 8 : _products.length,
                itemBuilder: (context, index) {
                  if (_products.length == 0) {
                    return MyShimmers().listView();
                  } else {
                    var data = _products[index];
                    List ontap = [
                      () {},
                      () {
                        Get.back();
                        setState(() {
                          _products[index]["visibility"] =
                              !_products[index]["visibility"];
                        });
                        productUpdateHelper({
                          ..._products[index],
                          "visibility": !_products[index]["visibility"]
                        });
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
                              _products[index]["available"] =
                                  leftOverController.text;
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
                    return CustomInkWell(
                      borderRadius: BorderRadius.zero,
                      onTap: () {
                        editProductBottomSheet(ontap, data["visibility"]);
                      },
                      child: ListTile(
                        leading: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            child: _products[index]["visibility"]
                                ? CachedImage(
                                    image:
                                        "${URL.AWS}/products/${data["id"]}.png")
                                : Stack(
                                    children: [
                                      CachedImage(
                                          image:
                                              "${URL.AWS}/products/${data["id"]}.png"),
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: MyColors.black
                                                  .withOpacity(0.5)),
                                          child: Icon(
                                            IconlyLight.hide,
                                            size: Get.width * .1,
                                            color:
                                                MyColors.white.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                        title: CustomText(
                          text: data["name"] ?? "",
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: convertToCurrencyFormat(
                                double.parse(data["price"]),
                                toInt: true,
                                locatedAtTheEnd: true,
                              ),
                            ),
                            Row(
                              children: [
                                const CustomText(
                                  text: "Үлдэгдэл:",
                                  fontSize: 12,
                                ),
                                const SizedBox(width: 8),
                                CustomText(text: data["available"])
                              ],
                            )
                          ],
                        ),
                        trailing: Icon(
                          IconlyLight.edit,
                          size: 16,
                          color: MyColors.black,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
  }
}
