import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/slide_button.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverFinishedView extends StatefulWidget {
  const DriverFinishedView({super.key});

  @override
  State<DriverFinishedView> createState() => _DriverFinishedViewState();
}

class _DriverFinishedViewState extends State<DriverFinishedView> {
  final _driverCtx = Get.put(DriverController());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: const AssetImage("assets/images/png/app/yes.png"),
            width: Get.width * .3,
          ),
          const SizedBox(height: 24),
          const CustomText(
            text: "Хүргэлт амжилттай",
            fontSize: 16,
          ),
          const SizedBox(height: 8),
          CustomText(
            fontSize: 28,
            text: convertToCurrencyFormat(
              double.parse(_driverCtx.newOrderInfo["deliveryPrice"] ?? "0"),
            ),
          ),
          const SizedBox(height: 8),
          const CustomText(
            text: "Орлого нэмэгдлээ",
            fontSize: 12,
            color: MyColors.gray,
          ),
          SizedBox(height: Get.height * .05),
          CustomSlideButton(
            text: "Дуусгах",
            onSubmit: _driverCtx.finished,
          )
        ],
      ),
    );
  }
}
