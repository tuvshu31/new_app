import 'dart:developer';
import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/custom_loading_widget.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class DriverDeliveriesScreen extends StatefulWidget {
  const DriverDeliveriesScreen({super.key});

  @override
  State<DriverDeliveriesScreen> createState() => _DriverDeliveriesScreenState();
}

class _DriverDeliveriesScreenState extends State<DriverDeliveriesScreen> {
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
    dynamic getDriverDeliveries = await DriverApi().getDriverDeliveries();
    if (getDriverDeliveries != null) {
      dynamic response = Map<String, dynamic>.from(getDriverDeliveries);
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
      body: loading && deliveryList.isEmpty
          ? listShimmerWidget()
          : !loading && deliveryList.isEmpty
              ? customEmptyWidget("Хүргэлт байхгүй байна")
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return Container(height: 7, color: MyColors.fadedGrey);
                  },
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: loading ? 8 : deliveryList.length,
                  itemBuilder: (context, index) {
                    var item = deliveryList[index];
                    return CustomInkWell(
                      borderRadius: BorderRadius.zero,
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: MyColors.white,
                          context: Get.context!,
                          isScrollControlled: true,
                          builder: (context) {
                            return DriverDeliveryDetailView(
                              date: item["date"],
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: Get.width * .04),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(item["date"] ?? "n/a",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(
                                    "Хүргэлтийн тоо:  ${item["deliveryCount"] ?? 0}"),
                                const SizedBox(height: 8),
                                Text(
                                    "Хүргэлтийн төлбөр: ${convertToCurrencyFormat(item["totalAmount"] ?? 0)}")
                              ],
                            ),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(
                                  IconlyLight.arrow_right_2,
                                  size: 20,
                                ),
                              ],
                            )),
                            SizedBox(width: Get.width * .04),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

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
    getDriverDeliveryDetails();
  }

  Future<void> getDriverDeliveryDetails() async {
    loading = true;
    dynamic getDriverDeliveryDetails =
        await DriverApi().getDriverDeliveryDetails(widget.date);
    if (getDriverDeliveryDetails != null) {
      dynamic response = Map<String, dynamic>.from(getDriverDeliveryDetails);
      if (response["success"]) {
        deliveryList = response["data"];
      }
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
          body: loading && deliveryList.isEmpty
              ? listShimmerWidget()
              : !loading && deliveryList.isEmpty
                  ? customEmptyWidget("Захиалга байхгүй байна")
                  : ListView.separated(
                      separatorBuilder: (context, index) {
                        return Container(height: 7, color: MyColors.fadedGrey);
                      },
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: deliveryList.length,
                      itemBuilder: (context, index) {
                        var item = deliveryList[index];
                        return CustomInkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Get.width * .03,
                                horizontal: Get.width * .04),
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
                                                IconlyLight.bag,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 12),
                                              Text(item["storeName"] ??
                                                  "No Data"),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Row(
                                            children: [
                                              const Icon(
                                                IconlyLight.location,
                                                size: 18,
                                              ),
                                              const SizedBox(width: 12),
                                              SizedBox(
                                                width: Get.width * .6,
                                                child: Text(
                                                  "${item["address"] ?? "NO data"}",
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Text(convertToCurrencyFormat(
                                    item["deliveryPrice"])),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
