import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/separator.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverDeliverListPage extends StatefulWidget {
  const DriverDeliverListPage({super.key});

  @override
  State<DriverDeliverListPage> createState() => _DriverDeliverListPageState();
}

class _DriverDeliverListPageState extends State<DriverDeliverListPage> {
  List deliveryList = [
    {
      "storeName": "Asia restaurant",
      "duration": "13:24",
      "date": "2023-02-04",
      "cost": "3000"
    },
    {
      "storeName": "Хаан бууз",
      "duration": "13:24",
      "date": "2023-02-04",
      "cost": "3000"
    },
    {
      "storeName": "Баялаг ресторан",
      "duration": "13:24",
      "date": "2023-02-04",
      "cost": "3000"
    },
    {
      "storeName": "Монсүү ХХК",
      "duration": "13:24",
      "date": "2023-02-04",
      "cost": "3000"
    }
  ];
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Хүргэлтүүд",
      customActions: Container(),
      body: Stack(
        children: [
          ListView.builder(
              physics: const BouncingScrollPhysics(),
              // padding: const EdgeInsets.symmetric(horizontal: 12),
              shrinkWrap: true,
              itemCount: deliveryList.length,
              itemBuilder: (context, index) {
                var data = deliveryList[index];
                return ListTile(
                  title: CustomText(text: data["storeName"]),
                  subtitle: Row(
                    children: [
                      CustomText(text: data["date"]),
                      const SizedBox(width: 24),
                      CustomText(text: "${data["duration"]} минут"),
                    ],
                  ),
                  trailing: CustomText(
                      text: convertToCurrencyFormat(
                    double.parse(data["cost"]),
                    toInt: true,
                    locatedAtTheEnd: true,
                  )),
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: Get.height * .14,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const MySeparator(color: MyColors.grey),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: "Нийт хүргэлтийн тоо:"),
                        CustomText(
                          text: "123",
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: "Нийт ашиг:"),
                        CustomText(
                          text: convertToCurrencyFormat(
                            double.parse("50000"),
                            locatedAtTheEnd: true,
                            toInt: true,
                          ),
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
