import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

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
    getDriverBonusInfo();
  }

  Future<void> getDriverBonusInfo() async {
    loading = true;
    paymentList.clear();
    int driverId = RestApiHelper.getUserId();
    dynamic response = await RestApi().getDriverBonus(driverId);
    if (response != null) {
      dynamic res = Map<String, dynamic>.from(response);
      paymentList = [res];
      log(res.toString());
    }
    loading = false;
    setState(() {});
  }

  Future<void> driverPaymentsByWeeks() async {
    loading = true;
    paymentList.clear();
    int driverId = RestApiHelper.getUserId();
    dynamic response = await RestApi().driverPaymentsByWeeks(driverId);
    if (response != null) {
      dynamic res = Map<String, dynamic>.from(response);
      paymentList = res["data"];
      log(paymentList.toString());
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Төлбөр тооцоо",
      customActions: Container(),
      body: Column(
        children: [
          DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: TabBar(
              onTap: ((value) {
                loading = true;
                paymentList.clear();
                setState(() {});
                value == 0 ? getDriverBonusInfo() : driverPaymentsByWeeks();
              }),
              labelColor: MyColors.primary,
              unselectedLabelColor: MyColors.black,
              indicatorColor: MyColors.primary,
              tabs: const [
                Tab(
                  text: "Энэ 7 хоног",
                ),
                Tab(
                  text: "Өмнөх 7 хоногууд",
                ),
              ],
            ),
          ),
          !loading && paymentList.isEmpty
              ? const CustomLoadingIndicator(text: "Хүргэлт байхгүй байна")
              : Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return Container(height: 12);
                    },
                    padding:
                        const EdgeInsets.only(top: 12, right: 12, left: 12),
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: loading ? 8 : paymentList.length,
                    itemBuilder: (context, index) {
                      if (loading) {
                        return listItemShimmer();
                      } else {
                        var item = paymentList[index];
                        return CustomInkWell(
                          onTap: () {},
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    width: 1,
                                    color: MyColors.background,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                // height: Get.height * .12,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: Get.width * .7,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const SizedBox(width: 12),
                                              Text(
                                                "${item["firstDay1"] ?? "0000"} - ${item["lastDay1"] ?? "0000"}",
                                                style: const TextStyle(
                                                  fontSize: 12,
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
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                )
        ],
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
