import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
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
  bool fetching = false;
  bool loading = false;
  Map order = {};
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

  void driverReceived() async {
    loading = true;
    dynamic driverReceived = await DriverApi().driverReceived();
    loading = false;
    if (driverReceived != null) {
      dynamic response = Map<String, dynamic>.from(driverReceived);
      if (response["success"]) {
        _driverCtx.driverStatus.value = DriverStatus.delivered;
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
          ? _listShimmerWidget()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomText(
                  text: "Баталгаажуулах код:",
                  color: MyColors.gray,
                ),
                const SizedBox(height: 12),
                CustomText(
                  text: "${order["orderId"] ?? 0}",
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
                SizedBox(height: Get.height * .03),
                Text("Нийт ${order["totalProducts"]} ширхэг бараа"),
                SizedBox(height: Get.height * .03),
                CustomButton(
                  text: "Хүлээн авсан",
                  onPressed: driverReceived,
                )
              ],
            ),
    );
  }

  Widget _listShimmerWidget() {
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
