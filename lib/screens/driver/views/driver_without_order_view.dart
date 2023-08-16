import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class DriverWithoutOrderView extends StatefulWidget {
  const DriverWithoutOrderView({super.key});

  @override
  State<DriverWithoutOrderView> createState() => _DriverWithoutOrderViewState();
}

class _DriverWithoutOrderViewState extends State<DriverWithoutOrderView> {
  final _driverCtx = Get.put(DriverController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _driverCtx.getDriverBonusInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {
              var body = {"isOpen": !_driverCtx.isOnline.value};
              _driverCtx.turnOnOff(body);
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(24),
              backgroundColor:
                  _driverCtx.isOnline.value ? Colors.white : Colors.red,
            ),
            child: _driverCtx.isOnline.value
                ? const Icon(
                    Icons.stop_circle_rounded,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.power_settings_new_rounded,
                    color: Colors.white,
                  ),
          ),
          SizedBox(height: Get.height * .025),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Та ${_driverCtx.isOnline.value ? "online" : "offline"} байна",
                    style: TextStyle(
                      fontSize: 16,
                      color: _driverCtx.isOnline.value
                          ? MyColors.black
                          : MyColors.grey,
                    ),
                  ),
                  // const Divider(),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              IconlyLight.discount,
                              color: Colors.white,
                              size: 16,
                            )),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${convertToCurrencyFormat(_driverCtx.driverBonusInfo["bonusAmount"] ?? 0)} урамшуулал:",
                                overflow: TextOverflow.ellipsis, // new
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${_driverCtx.driverBonusInfo["deliveryCount"] ?? 0}/${_driverCtx.driverBonusInfo["bonusCount"] ?? 0}",
                                style: const TextStyle(
                                  color: MyColors.gray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${_driverCtx.driverBonusInfo["daysUntilWeekend"] ?? 0} өдөр \n үлдсэн",
                              style: const TextStyle(
                                fontSize: 12,
                                color: MyColors.gray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
