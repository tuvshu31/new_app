import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/slide_button.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverDeliveredView extends StatefulWidget {
  const DriverDeliveredView({super.key});

  @override
  State<DriverDeliveredView> createState() => _DriverDeliveredViewState();
}

class _DriverDeliveredViewState extends State<DriverDeliveredView> {
  final _driverCtx = Get.put(DriverController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(24),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: MyColors.white,
                  radius: 20,
                  child: Image(
                    width: 32,
                    image: AssetImage(
                      "assets/images/png/app/home.png",
                    ),
                  ),
                ),
                title: CustomText(
                  text: _driverCtx.newOrderInfo["address"] ?? "No data",
                  fontSize: 16,
                ),
                subtitle: CustomText(
                    text:
                        "Орцны код: ${_driverCtx.newOrderInfo["kod"] ?? "No data"}"),
                trailing: GestureDetector(
                  onTap: () {
                    makePhoneCall(
                        "+976-${_driverCtx.newOrderInfo["phone"] ?? 000}");
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image(
                        image:
                            AssetImage("assets/images/png/app/phone-call.png")),
                  ),
                ),
              ),
            ),
            SizedBox(height: Get.height * .05),
            CustomSlideButton(
              text: "Хүлээлгэн өгсөн",
              onSubmit: _driverCtx.delivered,
            )
          ],
        ),
      ),
    );
  }
}
