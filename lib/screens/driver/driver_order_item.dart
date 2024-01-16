import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/countdown.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class DriverOrderItem extends StatefulWidget {
  Map item;
  DriverOrderItem({super.key, required this.item});

  @override
  State<DriverOrderItem> createState() => _DriverOrderItemState();
}

class _DriverOrderItemState extends State<DriverOrderItem> {
  final _driverCtx = Get.put(DriverController());
  @override
  Widget build(BuildContext context) {
    return widget.item["deliveryStatus"] == "acceptedByMe"
        ? CustomInkWell(
            onTap: () => _driverCtx.showOrderBottomSheet(widget.item),
            child: _listItem(widget.item))
        : _listItem(widget.item);
  }

  Widget _listItem(item) {
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
    bool acceptedByMe = item["deliveryStatus"] == "acceptedByMe";
    bool notAccepted = item["deliveryStatus"] == "notAccepted";
    bool acceptedByOthers = item["deliveryStatus"] == "acceptedByOthers";
    bool driverAccepted = item["orderStatus"] == "driverAccepted";
    bool waitingForDriver = item["orderStatus"] == "waitingForDriver";
    bool delivering = item["orderStatus"] == "delivering";
    bool preparing = item["orderStatus"] == "preparing";
    if (acceptedByMe && driverAccepted) {
      return _action1(item);
    } else if (acceptedByMe && waitingForDriver) {
      return _action2(item);
    } else if (acceptedByMe && delivering) {
      return _action3(item);
    } else if (notAccepted && preparing) {
      return _action4(item);
    } else if (notAccepted && waitingForDriver) {
      return _action5(item);
    } else if (acceptedByOthers && driverAccepted) {
      return _action6(item);
    } else if (acceptedByOthers && waitingForDriver) {
      return _action7(item);
    } else if (acceptedByOthers && delivering) {
      return _action8(item);
    } else if (acceptedByOthers && preparing) {
      return _action9(item);
    } else {
      return _action3(item);
    }
  }

  List<Widget> _action1(Map item) {
    return [
      Countdown(
        animation: StepTween(
          begin: item["initialDuration"] ?? 0,
          end: 0,
        ).animate(item["timer"]),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.circle_rounded,
            size: 8,
            color: Colors.amber,
          ),
          SizedBox(width: Get.width * .02),
          const Text(
            "Бэлдэж байна",
            style: TextStyle(
              fontSize: 12,
              color: MyColors.gray,
            ),
          )
        ],
      ),
    ];
  }

  List<Widget> _action2(Map item) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              IconlyLight.notification,
              size: 16,
              color: Colors.white,
            ),
          ),
          SizedBox(width: Get.width * .02),
          Countdown(
            animation: StepTween(
              begin: item["initialDuration"] ?? 0,
              end: 0,
            ).animate(item["timer"]),
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.circle_rounded,
            size: 8,
            color: Colors.amber,
          ),
          SizedBox(width: Get.width * .02),
          const Text(
            "Бэлдэж байна",
            style: TextStyle(
              fontSize: 12,
              color: MyColors.gray,
            ),
          )
        ],
      ),
    ];
  }

  List<Widget> _action3(Map item) {
    return [
      Countdown(
        animation: StepTween(
          begin: item["initialDuration"] ?? 0,
          end: 0,
        ).animate(item["timer"]),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.circle_rounded,
            size: 8,
            color: Colors.blue,
          ),
          SizedBox(width: Get.width * .02),
          const Text(
            "Хүргэж байна",
            style: TextStyle(
              fontSize: 12,
              color: MyColors.gray,
            ),
          )
        ],
      ),
    ];
  }

  //Not accepted && preparing
  List<Widget> _action4(Map item) {
    return [
      Countdown(
        animation: StepTween(
          begin: item["initialDuration"] ?? 0,
          end: 0,
        ).animate(item["timer"]),
      ),
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

  //Not accepted && waitingForDriver
  List<Widget> _action5(Map item) {
    return [
      Row(
        children: [
          const Icon(IconlyLight.notification),
          const SizedBox(width: 12),
          Countdown(
            animation: StepTween(
              begin: item["initialDuration"] ?? 0,
              end: 0,
            ).animate(item["timer"]),
          ),
        ],
      ),
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

  //AcceptedByOthers && driverAccepted
  List<Widget> _action6(Map item) {
    return [
      Countdown(
        animation: StepTween(
          begin: item["initialDuration"] ?? 0,
          end: 0,
        ).animate(item["timer"]),
      ),
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

  //AcceptedByOthers && waitingForDriver
  List<Widget> _action7(Map item) {
    return [
      Row(
        children: [
          const Icon(IconlyLight.notification),
          const SizedBox(width: 12),
          Countdown(
            animation: StepTween(
              begin: item["initialDuration"] ?? 0,
              end: 0,
            ).animate(item["timer"]),
          ),
        ],
      ),
      Text(
        item["driverName"] ?? "n/a",
      )
    ];
  }

  //AcceptedByOthers && delivering
  List<Widget> _action8(Map item) {
    return [
      Countdown(
        animation: StepTween(
          begin: item["initialDuration"] ?? 0,
          end: 0,
        ).animate(item["timer"]),
      ),
      Text(
        item["driverName"] ?? "n/a",
      ),
    ];
  }

  //Example
  List<Widget> _action9(Map item) {
    return [
      Countdown(
        animation: StepTween(
          begin: item["initialDuration"] ?? 0,
          end: 0,
        ).animate(item["timer"]),
      ),
      Text(
        item["driverName"] ?? "n/a",
      ),
    ];
  }
}
