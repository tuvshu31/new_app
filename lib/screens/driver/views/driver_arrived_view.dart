import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/slide_button.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverArrivedView extends StatefulWidget {
  const DriverArrivedView({super.key});

  @override
  State<DriverArrivedView> createState() => _DriverArrivedViewState();
}

class _DriverArrivedViewState extends State<DriverArrivedView> {
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  scale: 2,
                  "${URL.AWS}/users/${_driverCtx.newOrderInfo["storeId1"] ?? 10}/small/1.png",
                ),
              ),
              title: CustomText(
                text: _driverCtx.newOrderInfo["storeName"] ?? "No data",
                fontSize: 16,
              ),
              subtitle: CustomText(
                text: _driverCtx.newOrderInfo["storeAddress"] ?? "No data",
                fontSize: 12,
              ),
              trailing: GestureDetector(
                onTap: () {
                  makePhoneCall(
                      "+976-${_driverCtx.newOrderInfo["storePhone"] ?? 000}");
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                      image:
                          AssetImage("assets/images/png/app/phone-call.png")),
                ),
              ),
            ),
            SizedBox(height: Get.height * .05),
            CustomSlideButton(
              text: "Ирлээ",
              onSubmit: _driverCtx.arrived,
            )
          ],
        ),
      ),
    );
  }
}
