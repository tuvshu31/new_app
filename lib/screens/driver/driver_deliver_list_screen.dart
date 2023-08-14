import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/loading.dart';
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

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomHeader(
        title: "Хүргэлтүүд",
        customActions: Container(),
        body: _driverCtx.orderList.isEmpty
            ? CustomLoadingIndicator(
                text: "Хүргэлт байхгүй байна",
              )
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
                itemCount: _driverCtx.orderList.length,
                itemBuilder: (context, index) {
                  var data = _driverCtx.orderList[index];
                  return _item(data);
                },
              ),
      ),
    );
  }

  Widget _item(data) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      color: MyColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: data["storeName"] ?? "empty",
                ),
                CustomText(
                  text: data["orderTime"] ?? "empty",
                  fontSize: 12,
                  color: MyColors.gray,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  text: convertToCurrencyFormat(
                    double.parse(data["deliveryPrice"] ?? "3000"),
                  ),
                ),
                CustomText(
                  text: formatedTime(
                      timeInSecond: int.parse(data["deliveryDuration"] ?? "0")),
                  color: MyColors.gray,
                  fontSize: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
