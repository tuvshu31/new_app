import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class DriverDeliveryDetailView extends StatefulWidget {
  final String date;
  const DriverDeliveryDetailView({required this.date, super.key});

  @override
  State<DriverDeliveryDetailView> createState() =>
      _DriverDeliveryDetailViewState();
}

class _DriverDeliveryDetailViewState extends State<DriverDeliveryDetailView> {
  List deliveryList = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    getDriverDeliveriesDetails();
  }

  Future<void> getDriverDeliveriesDetails() async {
    loading = true;
    dynamic res = await RestApi()
        .driverDeliveriesDetails(RestApiHelper.getUserId(), widget.date);
    if (res != null) {
      dynamic response = Map<String, dynamic>.from(res);
      deliveryList = response["order"];
      log(deliveryList.toString());
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: SafeArea(
        child: CustomHeader(
          title: widget.date,
          centerTitle: false,
          leadingWidth: 24,
          customLeading: Container(),
          customActions: CustomInkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: Get.back,
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.fadedGrey,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.black,
              ),
            ),
          ),
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
                                            Row(
                                              children: [
                                                const Icon(
                                                  IconlyLight.location,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  item["storeName"] ??
                                                      "No Data",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 12),
                                            Row(
                                              children: [
                                                const Icon(IconlyLight.user,
                                                    size: 16),
                                                const SizedBox(width: 12),
                                                SizedBox(
                                                  width: Get.width * .6,
                                                  child: Text(
                                                    "${item["address"] ?? "NO data"}",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      convertToCurrencyFormat(
                                          int.parse(item["deliveryPrice"])),
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
        ),
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
