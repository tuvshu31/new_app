import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/countdown.dart';
import 'package:Erdenet24/controller/driver_controller.dart';

class DriverOrderItem extends StatelessWidget {
  Map item;
  DriverOrderItem({super.key, required this.item});

  final _driverCtx = Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    bool isAccepted = item["accepted"] ?? false;
    bool warning = item["orderStatus"] == "waitingForDriver";
    if (!isAccepted) {
      return _listItem(item, warning, 0);
    } else if (isAccepted && !item["acceptedByMe"]) {
      return _listItem(item, warning, 1);
    } else {
      return CustomInkWell(
        onTap: () => _driverCtx.showOrderBottomSheet(item),
        child: _listItem(item, warning, 2),
      );
    }
  }

  Widget _listItem(item, warning, id) {
    return SizedBox(
      height: Get.height * .11,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: Get.width * .04),
          Stack(
            children: [
              customImage(
                Get.width * .1,
                item["image"] ?? 'assets/images/png/no_image.png',
                isCircle: true,
              )
            ],
          ),
          SizedBox(width: Get.width * .04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: Get.width * .01),
                Text(
                  item["storeName"] ?? "n/a",
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item["address"] ?? "n/a",
                  overflow: TextOverflow.ellipsis,
                ),
                Text(convertToCurrencyFormat(item["deliveryPrice"] ?? 0)),
                SizedBox(height: Get.width * .01),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: !item["accepted"]
                  ? _notAccepted(item)
                  : !item["acceptedByMe"]
                      ? _acceptedByOthers(item)
                      : _acceptedByMe(item),
            ),
          ),
          SizedBox(width: Get.width * .04)
        ],
      ),
    );
  }

  List<Widget> _acceptedByMe(Map item) {
    return [
      item["orderStatus"] == "waitingForDriver"
          ? const Icon(
              IconlyBold.notification,
              size: 16,
              color: Colors.red,
            )
          : _timer(item),
      status(item["orderStatus"]),
    ];
  }

  List<Widget> _notAccepted(Map item) {
    return [
      _timer(item),
      TextButton(
        onPressed: () {
          _driverCtx.showPasswordDialog(item, 'accept');
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
        ),
        child: const Text('Accept'),
      ),
    ];
  }

  List<Widget> _acceptedByOthers(Map item) {
    return [
      _timer(item),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_taxi_rounded,
            size: 18,
          ),
          SizedBox(width: Get.width * .02),
          Text(
            item["driverName"] ?? "n/a",
            style: const TextStyle(
              fontSize: 12,
            ),
          )
        ],
      ),
    ];
  }

  Widget _timer(item) {
    return item["orderStatus"] == "waitingForDriver"
        ? SizedBox(
            width: Get.width * .1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Countdown(
                  animation: StepTween(
                    begin: item["initialDuration"] ?? 0,
                    end: 0,
                  ).animate(item["timer"]),
                ),
              ],
            ),
          )
        : Countdown(
            animation: StepTween(
              begin: item["initialDuration"] ?? 0,
              end: 0,
            ).animate(item["timer"]),
          );
  }
}
