import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
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
  List<dynamic> orderList = [];
  @override
  void initState() {
    super.initState();
    fetchDriverOrders();
  }

  void fetchDriverOrders() async {
    var query = {
      "deliveryDriverId": RestApiHelper.getUserId(),
      "orderStatus": "received",
    };
    dynamic res = await RestApi().getOrders(query);
    dynamic data = Map<String, dynamic>.from(res);
    if (data["success"]) {
      setState(() {
        orderList = data["data"];
      });
      log(orderList.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Хүргэлтүүд",
      customActions: Container(),
      body: orderList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(
              color: MyColors.primary,
            ))
          : ListView.separated(
              separatorBuilder: (context, index) {
                return Container(
                  height: 7,
                  color: MyColors.fadedGrey,
                );
              },
              physics: const BouncingScrollPhysics(),
              // padding: const EdgeInsets.symmetric(horizontal: 12),
              shrinkWrap: true,
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                var data = orderList[index];
                return _item(data);
              },
            ),
    );
  }

  Widget _item(data) {
    return Container(
      height: Get.height * .09,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: MyColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: "Restaurant",
                fontSize: 14,
              ),
              Row(
                children: [
                  CustomText(
                    text: data["orderTime"],
                    fontSize: 12,
                  ),
                  const SizedBox(width: 24),
                  CustomText(
                    text: "${data["deliveryDuration"]} ceкунт",
                    color: MyColors.gray,
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: CustomText(
              text: convertToCurrencyFormat(
                double.parse(data["deliveryPrice"]),
                toInt: true,
                locatedAtTheEnd: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
