import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';

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
      body: ListView.builder(
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
    );
  }
}
