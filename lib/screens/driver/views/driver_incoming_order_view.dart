import 'dart:developer';

import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverIncomingOrderView extends StatefulWidget {
  const DriverIncomingOrderView({super.key});

  @override
  State<DriverIncomingOrderView> createState() =>
      _DriverIncomingOrderViewState();
}

class _DriverIncomingOrderViewState extends State<DriverIncomingOrderView> {
  bool loading = false;
  final _driverCtx = Get.put(DriverController());

  void driverAcceptOrder(int orderId) async {
    loading = true;
    dynamic driverAcceptOrder = await DriverApi().driverAcceptOrder(orderId);
    loading = false;
    if (driverAcceptOrder != null) {
      dynamic response = Map<String, dynamic>.from(driverAcceptOrder);
      if (response["success"]) {
        log("driverAcceptedResponse: $response");
        _driverCtx.driverStatus.value = DriverStatus.arrived;
      }
    }
    setState(() {});
  }

  void driverCancelOrder() async {
    _driverCtx.order.clear();
    _driverCtx.driverStatus.value = DriverStatus.withoutOrder;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomInkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: driverCancelOrder,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: MyColors.fadedGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.close_rounded,
                          size: 20,
                        ),
                        SizedBox(width: 4),
                        Text("Цуцлах"),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: Get.height * .03),
            Stack(
              children: [
                CustomImage(
                  width: Get.width * .25,
                  height: Get.width * .25,
                  url:
                      "${URL.AWS}/users/${_driverCtx.order["storeId"]}/small/1.png",
                  radius: 100,
                ),
                CircularCountDownTimer(
                  isReverseAnimation: true,
                  isReverse: true,
                  strokeWidth: 8,
                  width: Get.width * .25,
                  height: Get.width * .25,
                  duration: 30,
                  isTimerTextShown: false,
                  fillColor: MyColors.primary,
                  ringColor: Colors.white,
                  strokeCap: StrokeCap.round,
                  onComplete: driverCancelOrder,
                ),
              ],
            ),
            SizedBox(height: Get.height * .03),
            Text(
              _driverCtx.order["store"] ?? "No data",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _driverCtx.order["storeAddress"] ?? "No data",
              style: const TextStyle(
                fontSize: 12,
                color: MyColors.gray,
              ),
            ),
            SizedBox(height: Get.height * .03),
            Text(
              convertToCurrencyFormat(_driverCtx.order["deliveryPrice"]),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Get.height * .03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 16,
                  color: MyColors.primary,
                ),
                const SizedBox(width: 12),
                Text(_driverCtx.order["address"] ?? "No data"),
              ],
            ),
            SizedBox(height: Get.height * .05),
            CustomButton(
              text: "Зөвшөөрөх",
              isLoading: loading,
              onPressed: () {
                int orderId = _driverCtx.order["id"];
                driverAcceptOrder(orderId);
              },
            )
          ],
        ),
      ),
    );
  }
}
