import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverFinishedView extends StatefulWidget {
  const DriverFinishedView({super.key});

  @override
  State<DriverFinishedView> createState() => _DriverFinishedViewState();
}

class _DriverFinishedViewState extends State<DriverFinishedView> {
  Map order = {};
  bool fetching = false;
  bool loading = false;
  final _driverCtx = Get.put(DriverController());

  @override
  void initState() {
    super.initState();
    getCurrentOrderInfo();
  }

  void getCurrentOrderInfo() async {
    fetching = true;
    dynamic getCurrentOrderInfo = await DriverApi().getCurrentOrderInfo();
    fetching = false;
    if (getCurrentOrderInfo != null) {
      dynamic response = Map<String, dynamic>.from(getCurrentOrderInfo);
      if (response["success"]) {
        order = response["data"];
      }
    }
    setState(() {});
  }

  void driverFinished() async {
    loading = true;
    dynamic driverFinished = await DriverApi().driverFinished();
    loading = false;
    if (driverFinished != null) {
      dynamic response = Map<String, dynamic>.from(driverFinished);
      if (response["success"]) {
        _driverCtx.driverStatus.value = DriverStatus.withoutOrder;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: fetching
          ? _listItemShimmer()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                const CustomText(
                  text: "Хүргэлт амжилттай",
                  fontSize: 16,
                ),
                const SizedBox(height: 8),
                CustomText(
                  fontSize: 28,
                  text: convertToCurrencyFormat(order["deliveryPrice"] ?? "0"),
                ),
                const SizedBox(height: 8),
                const Text(
                  "орлого нэмэгдлээ",
                  style: TextStyle(color: MyColors.gray),
                ),
                SizedBox(height: Get.height * .05),
                CustomButton(
                  text: "Дуусгах",
                  onPressed: driverFinished,
                )
              ],
            ),
    );
  }

  Widget _listItemShimmer() {
    return SizedBox(
      height: Get.width * .2 + 16,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: Get.width * .04),
            Stack(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Get.width * 0.15,
                    maxHeight: Get.width * 0.15,
                  ),
                  child: CustomShimmer(
                    width: Get.width * .15,
                    height: Get.width * .15,
                    borderRadius: 50,
                  ),
                ),
              ],
            ),
            SizedBox(width: Get.width * .04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomShimmer(width: Get.width * .7, height: 16),
                  CustomShimmer(width: Get.width * .7, height: 16),
                  CustomShimmer(width: Get.width * .7, height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
