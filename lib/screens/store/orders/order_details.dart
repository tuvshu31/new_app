import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  dynamic _products = {};
  Future<void> getUserProducts() async {
    var query = {"categoryId": "1"};
    dynamic products = await RestApi().getProducts(query);
    dynamic data = Map<String, dynamic>.from(products);
    if (data["success"]) {
      setState(() {
        _products = data["data"];
      });
      print(_products);
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
      customActions: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.print,
          color: MyColors.black,
        ),
      ),
      title: "Захиалга",
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomText(text: "Захиалгын дугаар:"),
                      SizedBox(width: 4),
                      CustomText(text: "Gok garden jfkd;s")
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(text: "Хаяг:"),
                      SizedBox(width: 4),
                      CustomText(text: "Gok garden jfkd;s")
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(text: "Утас:"),
                      SizedBox(width: 4),
                      CustomText(text: "Gok garden jfkd;s")
                    ],
                  ),
                  Row(
                    children: [
                      CustomText(text: "Нийт үнэ:"),
                      SizedBox(width: 4),
                      CustomText(
                        text: convertToCurrencyFormat(
                          double.parse("200000"),
                          toInt: true,
                          locatedAtTheEnd: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: MyColors.fadedGrey),
              child: ListView.separated(
                  separatorBuilder: (context, index) => Container(
                        height: 8,
                        width: double.infinity,
                      ),
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _products.length > 0 ? _products.length : 8,
                  itemBuilder: (context, index) {
                    if (_products.length == 0) {
                      return MyShimmers().listView();
                    } else {
                      var data = _products[index];
                      return Container(
                          height: Get.height * .14,
                          color: MyColors.white,
                          child: Row(
                            children: [
                              CachedImage(
                                image: "${URL.AWS}/products/${data["_id"]}",
                              ),
                              SizedBox(width: Get.width * .03),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: "${data["name"]}",
                                  ),
                                  Row(
                                    children: [
                                      CustomText(text: "Нэгж үнэ:"),
                                      SizedBox(width: 8),
                                      CustomText(
                                        text: convertToCurrencyFormat(
                                          double.parse(data["price"]),
                                          toInt: true,
                                          locatedAtTheEnd: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(text: "Захиалсан тоо:"),
                                      SizedBox(width: 8),
                                      CustomText(
                                        text: convertToCurrencyFormat(
                                          double.parse(data["price"]),
                                          toInt: true,
                                          locatedAtTheEnd: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomText(text: "Нийт үнэ:"),
                                      SizedBox(width: 8),
                                      CustomText(
                                        text: convertToCurrencyFormat(
                                          double.parse(data["price"]),
                                          toInt: true,
                                          locatedAtTheEnd: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ));
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
