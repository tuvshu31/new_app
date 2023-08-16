import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/slide_button.dart';
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
  final _driverCtx = Get.put(DriverController());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomInkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _driverCtx.cancelOrder,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: MyColors.fadedGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("Цуцлах"),
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
                    "${URL.AWS}/users/${_driverCtx.newOrderInfo["storeId1"]}/small/1.png",
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
                onComplete: _driverCtx.cancelOrder,
              ),
            ],
          ),
          SizedBox(height: Get.height * .03),
          Text(
            _driverCtx.newOrderInfo["storeName"] ?? "No data",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            _driverCtx.newOrderInfo["storeAddress"] ?? "No data",
            style: const TextStyle(
              fontSize: 12,
              color: MyColors.gray,
            ),
          ),
          SizedBox(height: Get.height * .03),
          Text(
            convertToCurrencyFormat(
              int.parse(_driverCtx.newOrderInfo["deliveryPrice"] ?? "3000"),
            ),
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
              Text(_driverCtx.newOrderInfo["address"] ?? "No data"),
            ],
          ),
          SizedBox(height: Get.height * .05),
          CustomSlideButton(
            text: "Зөвшөөрөх",
            onSubmit: _driverCtx.acceptOrder,
          )
        ],
      ),
    );
  }
}
