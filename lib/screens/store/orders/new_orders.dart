import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:get/get.dart';

class NewOrdersView extends StatefulWidget {
  const NewOrdersView({super.key});

  @override
  State<NewOrdersView> createState() => _NewOrdersViewState();
}

class _NewOrdersViewState extends State<NewOrdersView> {
  dynamic _data = [];
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  void getOrders() async {
    dynamic response =
        await RestApi().getStoreOrders(RestApiHelper.getUserId(), {});
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      setState(() {
        _data = d["data"];
      });
    }
  }

  void orderUpdateHelper(int id, dynamic body) async {
    loadingDialog(context);
    dynamic product = await RestApi().updateOrder(id, body);
    dynamic data = Map<String, dynamic>.from(product);
    Get.back();
    if (data["success"]) {
      successSnackBar("Амжилттай илгээлээ", 2, context);
    } else {
      errorSnackBar("Үл мэдэгдэх алдаа гарлаа", 2, context);
    }
  }

  String timeDiffCalctr(time) {
    var difference = DateTime.now().difference(DateTime.parse(time)).inMinutes;
    return difference.toString();
  }

  Color colorChanger(String status) {
    return status == "sent"
        ? MyColors.primary
        : status == "preparing"
            ? MyColors.warning
            : status == "delivering"
                ? MyColors.green
                : MyColors.black;
  }

  String statusChanger(String status) {
    return status == "sent"
        ? "preparing"
        : status == "preparing"
            ? "delivering"
            : status == "delivering"
                ? "received"
                : "";
  }

  String buttonTextChanger(String status) {
    return status == "sent"
        ? "Хүргэлтэнд бэлдэх"
        : status == "preparing"
            ? "Хүргэлтэнд гаргах"
            : "";
  }

  void _showOrderDetauls(int int) {
    var products = _data[int]["products"];

    Get.bottomSheet(
      SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            color: MyColors.white,
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: Get.back,
                        child: Container(
                            decoration: BoxDecoration(
                              color: MyColors.fadedGrey,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.close,
                              size: 20,
                            )),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          CustomText(text: "Хаяг:"),
                          SizedBox(width: 8),
                          CustomText(text: _data[int]["address"])
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(text: "Утас:"),
                          SizedBox(width: 8),
                          CustomText(text: _data[int]["phone"])
                        ],
                      ),
                      Row(
                        children: [
                          CustomText(text: "Нийт үнэ:"),
                          SizedBox(width: 8),
                          CustomText(
                            text: convertToCurrencyFormat(
                              double.parse(_data[int]["totalAmount"]),
                              toInt: true,
                              locatedAtTheEnd: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * .05),
                  ListView.separated(
                      separatorBuilder: (context, index) {
                        return Container(height: 8);
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            child: CachedImage(
                                image:
                                    "${URL.AWS}/products/${products[index]["id"]}.png"),
                          ),
                          title: CustomText(
                            text: products[index]["name"],
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: convertToCurrencyFormat(
                                  double.parse(products[index]["price"]),
                                  toInt: true,
                                  locatedAtTheEnd: true,
                                ),
                              ),
                              CustomText(
                                text: "Баялаг ресторан",
                                fontSize: 12,
                                color: MyColors.gray,
                              )
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: MyColors.fadedGrey,
                                  shape: BoxShape.circle,
                                ),
                                child: CustomText(
                                  text: products[index]["quantity"].toString(),
                                  fontSize: 14,
                                  isLowerCase: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(height: Get.height * .1),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: "Хэвлэх",
                        ),
                      ),
                      _data[int]["orderStatus"] != "delivering"
                          ? Expanded(
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomButton(
                                      bgColor: colorChanger(
                                          _data[int]["orderStatus"]),
                                      onPressed: (() {
                                        orderUpdateHelper(_data[int]["id"], {
                                          "orderStatus": statusChanger(
                                              _data[int]["orderStatus"])
                                        });
                                        setState(() {
                                          _data[int]["orderStatus"] =
                                              statusChanger(
                                                  _data[int]["orderStatus"]);
                                        });
                                        Get.back();
                                      }),
                                      text: buttonTextChanger(
                                          _data[int]["orderStatus"]),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container()
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _data.length > 0
        ? ListView.separated(
            separatorBuilder: (context, index) {
              return Container(height: 8);
            },
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _data.length,
            itemBuilder: (context, index) {
              var status = _data[index]["orderStatus"];
              return GestureDetector(
                onTap: (() {
                  _showOrderDetauls(index);
                }),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.circle,
                                size: 8, color: colorChanger(status)),
                            const SizedBox(width: 4),
                            CustomText(
                              text: status == "sent"
                                  ? "Шинэ"
                                  : status == "preparing"
                                      ? "Хүргэлтэнд бэлдэж байгаа"
                                      : status == "delivering"
                                          ? "Хүргэлтэнд гарсан"
                                          : "",
                              color: colorChanger(status),
                              fontSize: 12,
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                                text: _data[index]["orderId"].toString()),
                            CustomText(
                              text:
                                  "${timeDiffCalctr(_data[index]["orderTime"])} минутын өмнө",
                              color: MyColors.warning,
                              fontSize: 12,
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Утас:",
                              color: MyColors.gray,
                              fontSize: 12,
                            ),
                            CustomText(
                              text: _data[index]["phone"],
                              fontSize: 12,
                              color: MyColors.gray,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Хаяг",
                              fontSize: 12,
                              color: MyColors.gray,
                            ),
                            CustomText(
                              text: _data[index]["address"],
                              fontSize: 12,
                              color: MyColors.gray,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: "Захиалгын дүн:"),
                            CustomText(
                              text: convertToCurrencyFormat(
                                double.parse(_data[index]["totalAmount"]),
                                toInt: true,
                                locatedAtTheEnd: true,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            })
        : CustomLoadingIndicator(text: "Шинэ захиалга байхгүй байна");
  }
}
