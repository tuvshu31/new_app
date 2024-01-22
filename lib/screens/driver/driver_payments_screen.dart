import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';

class DriverPaymentsScreen extends StatefulWidget {
  const DriverPaymentsScreen({super.key});

  @override
  State<DriverPaymentsScreen> createState() => _DriverPaymentsScreenState();
}

class _DriverPaymentsScreenState extends State<DriverPaymentsScreen> {
  PageController pageController = PageController();
  bool loading = false;
  List paymentList = [];
  @override
  void initState() {
    super.initState();
    getDriverPaymentsByWeeks();
  }

  // Future<void> getDriverBonusInfo() async {
  //   loading = true;
  //   paymentList.clear();
  //   int driverId = RestApiHelper.getUserId();
  //   dynamic response = await RestApi().getDriverBonus(driverId);
  //   if (response != null) {
  //     dynamic res = Map<String, dynamic>.from(response);
  //     paymentList = [res];
  //     log(res.toString());
  //   }
  //   loading = false;
  //   setState(() {});
  // }

  Future<void> getDriverPaymentsByWeeks() async {
    loading = true;
    paymentList.clear();
    dynamic getDriverPaymentsByWeeks =
        await DriverApi().getDriverPaymentsByWeeks();
    if (getDriverPaymentsByWeeks != null) {
      dynamic response = Map<String, dynamic>.from(getDriverPaymentsByWeeks);
      paymentList = response["data"];
      log(paymentList.toString());
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Төлбөр",
      customActions: Container(),
      body: loading && paymentList.isEmpty
          ? listShimmerWidget()
          : !loading && paymentList.isEmpty
              ? customEmptyWidget("Хадгалсан бараа байхгүй байна")
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return Container(height: 7, color: MyColors.fadedGrey);
                  },
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: loading ? 8 : paymentList.length,
                  itemBuilder: (context, index) {
                    var item = paymentList[index];
                    return CustomInkWell(
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(Get.width * .03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 12),
                            Text(
                              "${item["firstDay1"] ?? "0000"} - ${item["lastDay1"] ?? "0000"}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                                "Хүргэлтийн тоо: ${item["deliveryCount"] ?? 0}"),
                            const SizedBox(height: 8),
                            Text(
                                "Хүргэлтийн төлбөр: ${convertToCurrencyFormat(item["totalDeliveryPrice"] ?? 0)}"),
                            const SizedBox(height: 8),
                            Text(
                                "Урамшуулал:  ${convertToCurrencyFormat(item["bonus"] ?? 0)} (${item["bonusNum"] ?? 0} ширхэг)"),
                            const SizedBox(height: 8),
                            Text(
                                "Нийт төлбөр:  ${convertToCurrencyFormat(item["totalPrice"] ?? 0)}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget listItemShimmer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: MyColors.background,
        ),
      ),
      padding: const EdgeInsets.all(12),
      height: Get.height * .1,
      width: Get.width * .5,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Get.width * .5,
            child: Row(
              children: [
                CustomShimmer(
                  width: Get.width * .1,
                  height: Get.width * .1,
                  borderRadius: 50,
                ),
                const SizedBox(width: 12),
                CustomShimmer(
                  width: Get.width * .3,
                  height: 14,
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomShimmer(
                  width: Get.width * .3,
                  height: 14,
                ),
                CustomShimmer(
                  width: Get.width * .3,
                  height: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
