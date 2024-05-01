import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class DriverBottomSheetsBody extends StatefulWidget {
  Map item;
  DriverBottomSheetsBody({required this.item, super.key});

  @override
  State<DriverBottomSheetsBody> createState() => _DriverBottomSheetsBodyState();
}

class _DriverBottomSheetsBodyState extends State<DriverBottomSheetsBody> {
  final _driverCtx = Get.put(DriverController());
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Get.width * .04),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.item["orderStatus"] == "preparing" ||
                widget.item["orderStatus"] == "driverAccepted" ||
                widget.item["orderStatus"] == "waitingForDriver"
            ? _receivedView()
            : _deliveredView(),
      ),
    );
  }

  List<Widget> _receivedView() {
    return [
      _listTileWidget(
        customImage(
          Get.width * .1,
          widget.item["image"],
          isCircle: true,
        ),
        widget.item["storeName"] ?? "n/a",
        widget.item["storeAddress"] ?? "n/a",
        widget.item["storePhone"] ?? "0",
      ),
      const Divider(),
      SizedBox(height: Get.width * .03),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Захиалгын дугаар:"),
          Text(widget.item["orderId"]),
        ],
      ),
      SizedBox(height: Get.width * .03),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Тоо ширхэг:"),
          Text("${widget.item["products"].length ?? 0} ширхэг"),
        ],
      ),
      SizedBox(height: Get.width * .08),
      CustomButton(
        text: "Хүлээн авлаа",
        onPressed: () {
          _driverCtx.showPasswordDialog(widget.item, 'received');
        },
      ),
    ];
  }

  List<Widget> _deliveredView() {
    return [
      _listTileWidget(
        ClipRRect(
            borderRadius: BorderRadius.circular(50),
            clipBehavior: Clip.hardEdge,
            child: Container(
              width: Get.width * .1,
              height: Get.width * .1,
              color: Colors.amber,
              child: const Center(
                child: Icon(
                  IconlyLight.profile,
                  color: MyColors.white,
                  size: 20,
                ),
              ),
            )),
        widget.item["address"] ?? "n/a",
        "Орцны код: ${widget.item["entrance"] ?? "n/a"}",
        widget.item["phone"] ?? "0",
      ),
      const Divider(),
      SizedBox(height: Get.width * .03),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Захиалгын дугаар:"),
          Text(widget.item["orderId"] ?? "n/a"),
        ],
      ),
      SizedBox(height: Get.width * .03),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Тоо ширхэг:"),
          Text("${widget.item["products"].length ?? 0} ширхэг"),
        ],
      ),
      SizedBox(height: Get.width * .08),
      CustomButton(
        text: "Хүлээлгэн өглөө",
        onPressed: () {
          Get.back();
          _driverCtx.showPasswordDialog(widget.item, "delivered");
        },
      ),
    ];
  }

  Widget _listTileWidget(
    Widget leadingWidget,
    String title,
    String subtitle,
    String phone,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.width * .03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          leadingWidget,
          SizedBox(width: Get.width * .04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: MyColors.gray, fontSize: 14),
                ),
              ],
            ),
          ),
          CustomInkWell(
            onTap: () {
              Get.back();
              makePhoneCall("+976-$phone");
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                  color: Colors.green, shape: BoxShape.circle),
              child: const Icon(
                Icons.phone_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
