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

class DriverArrivedView extends StatefulWidget {
  const DriverArrivedView({super.key});

  @override
  State<DriverArrivedView> createState() => _DriverArrivedViewState();
}

class _DriverArrivedViewState extends State<DriverArrivedView> {
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

  void driverArrived() async {
    loading = true;
    dynamic driverArrived = await DriverApi().driverArrived();
    loading = false;
    if (driverArrived != null) {
      dynamic response = Map<String, dynamic>.from(driverArrived);
      if (response["success"]) {
        _driverCtx.driverStatus.value = DriverStatus.received;
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
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      scale: 2,
                      "${URL.AWS}/users/${order["storeId"]}/small/1.png",
                    ),
                  ),
                  title: CustomText(
                    text: order["storeName"] ?? "No data",
                    fontSize: 16,
                  ),
                  subtitle: CustomText(
                    text: order["storeAddress"] ?? "No data",
                    fontSize: 12,
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      makePhoneCall("+976-${order["storePhone"] ?? 000}");
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * .03),
                CustomButton(
                  text: "Ирлээ",
                  onPressed: driverArrived,
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
