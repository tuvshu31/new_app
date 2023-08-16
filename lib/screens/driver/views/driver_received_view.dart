import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/slide_button.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_countdown/slide_countdown.dart';

class DriverReceivedView extends StatefulWidget {
  const DriverReceivedView({super.key});

  @override
  State<DriverReceivedView> createState() => _DriverReceivedViewState();
}

class _DriverReceivedViewState extends State<DriverReceivedView> {
  final _driverCtx = Get.put(DriverController());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomText(
            text: "Баталгаажуулах код:",
            color: MyColors.gray,
          ),
          const SizedBox(height: 12),
          CustomText(
            text: "${_driverCtx.newOrderInfo["orderId"] ?? 0}",
            fontSize: 24,
          ),
          const SizedBox(height: 12),
          SlideCountdownSeparated(
            duration: const Duration(minutes: 15),
            onDone: () {},
            width: 40,
            height: 40,
            textStyle: const TextStyle(color: Colors.white),
            decoration: BoxDecoration(
              color: MyColors.primary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1,
                color: MyColors.primary,
              ),
            ),
          ),
          SizedBox(height: Get.height * .05),
          CustomSlideButton(
            text: "Хүлээн авсан",
            onSubmit: _driverCtx.received,
          )
        ],
      ),
    );
  }
}
