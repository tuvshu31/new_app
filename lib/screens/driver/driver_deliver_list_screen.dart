import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/screens/driver/views/driver_delivery_detail_view.dart';
import 'package:Erdenet24/screens/user/user_orders_detail_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverDeliverListScreen extends StatefulWidget {
  const DriverDeliverListScreen({super.key});

  @override
  State<DriverDeliverListScreen> createState() =>
      _DriverDeliverListScreenState();
}

class _DriverDeliverListScreenState extends State<DriverDeliverListScreen> {
  final _driverCtx = Get.put(DriverController());
  List deliveryList = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getDriverDeliveries();
  }

  Future<void> getDriverDeliveries() async {
    loading = true;
    dynamic res = await RestApi().driverDeliveries(RestApiHelper.getUserId());
    if (res != null) {
      dynamic response = Map<String, dynamic>.from(res);
      deliveryList = response["deliveries"].reversed.toList();
      log(deliveryList.toString());
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Хүргэлтүүд",
      customActions: Container(),
      body: !loading && deliveryList.isEmpty
          ? customEmptyWidget("Хүргэлт байхгүй байна")
          : ListView.separated(
              separatorBuilder: (context, index) {
                return Container(height: 12);
              },
              padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: loading ? 8 : deliveryList.length,
              itemBuilder: (context, index) {
                if (loading) {
                  return listItemShimmer();
                } else {
                  var item = deliveryList[index];
                  return CustomInkWell(
                    onTap: () {
                      Get.bottomSheet(
                        DriverDeliveryDetailView(
                          date: item["date"],
                        ),
                        isScrollControlled: true,
                        backgroundColor: MyColors.white,
                      );
                    },
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
                          height: Get.height * .1,
                          child: Row(
                            children: [
                              SizedBox(
                                width: Get.width * .5,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            item["date"] ?? "No Data",
                                            style: const TextStyle(
                                              color: MyColors.gray,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                              "${item["deliveryCount"] ?? 0} хүргэлт"),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  convertToCurrencyFormat(
                                      item["totalAmount"] ?? 0),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                                color: MyColors.black,
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
