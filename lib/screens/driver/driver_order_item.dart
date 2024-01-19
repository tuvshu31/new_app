import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/countdown.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class DriverOrderItem extends StatelessWidget {
  Map item;
  DriverOrderItem({super.key, required this.item});

  final _driverCtx = Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    bool isAccepted = item["accepted"] ?? false;
    bool warning = item["orderStatus"] == "waitingForDriver";
    bool isAcceptedByMe = item["driverId"] == RestApiHelper.getUserId();
    if (!isAccepted) {
      return _listItem(item, warning, 0);
    } else if (isAccepted && !isAcceptedByMe) {
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
                "${URL.AWS}/users/${item["storeId"] ?? 628}/small/1.png",
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
              children: _actionsHandler(item),
            ),
          ),
          SizedBox(width: Get.width * .04)
        ],
      ),
    );
  }

  List<Widget> _actionsHandler(Map item) {
    bool isAccepted = item["accepted"];
    bool warning = item["orderStatus"] == "waitingForDriver";
    bool isAcceptedByMe = item["driverId"] == RestApiHelper.getUserId();
    if (!isAccepted) {
      return _notAccepted(item, warning);
    } else if (isAccepted && !isAcceptedByMe) {
      return _acceptedByOthers(item, warning);
    } else {
      return _acceptedByMe(item, warning);
    }
  }

  List<Widget> _acceptedByMe(Map item, bool warning) {
    return [
      item["orderStatus"] == "waitingForDriver"
          ? const Icon(
              IconlyBold.notification,
              size: 16,
              color: Colors.red,
            )
          : _timer(item, warning),
      status(item["orderStatus"]),
    ];
  }

  List<Widget> _notAccepted(Map item, bool warning) {
    return [
      _timer(item, warning),
      TextButton(
        onPressed: () {
          _driverCtx.showPasswordDialog(item);
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
        ),
        child: const Text('Accept'),
      ),
    ];
  }

  List<Widget> _acceptedByOthers(Map item, bool warning) {
    return [
      _timer(item, warning),
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

  Widget _timer(item, warning) {
    return warning
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
