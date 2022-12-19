import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class OrderHistoryView extends StatefulWidget {
  const OrderHistoryView({super.key});

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  dynamic _data = [];
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  void getOrders() async {
    var body = {"userId": RestApiHelper.getUserId(), "orderStatus": "received"};
    dynamic response = await RestApi().getOrders(body);
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      setState(() {
        _data = d["data"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _data.isNotEmpty
        ? ListView.separated(
            separatorBuilder: (context, index) {
              return Container(height: 8);
            },
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (() {
                  Get.bottomSheet(
                    SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                                color: MyColors.white,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: CustomText(text: "Хаах"),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                            child: CustomButton(
                                          bgColor: MyColors.fadedGreen,
                                          onPressed: (() {}),
                                          prefix: Icon(
                                            IconlyLight.play,
                                            color: MyColors.green,
                                          ),
                                          text: "Жолооч дуудах",
                                          textColor: MyColors.green,
                                        )),
                                      ],
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    isScrollControlled: true,
                    ignoreSafeArea: false,
                  );
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
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: MyColors.primary,
                            ),
                            SizedBox(width: 4),
                            CustomText(
                              text: "Шинэ",
                              color: MyColors.primary,
                              fontSize: 12,
                            )
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: "№1212121212"),
                            CustomText(
                              text: "5 минутын өмнө",
                              color: MyColors.warning,
                              fontSize: 12,
                            )
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Утас:",
                              color: MyColors.gray,
                              fontSize: 12,
                            ),
                            CustomText(
                              text: "99921312",
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
                              text: "Гок гарден 48-7",
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
                                double.parse("295000"),
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
        : CustomLoadingIndicator(text: "Захиалга байхгүй байна");
  }
}
