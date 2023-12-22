import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/api/local_notification.dart';
import 'package:Erdenet24/api/socket_instance.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverWithoutOrderView extends StatefulWidget {
  const DriverWithoutOrderView({super.key});

  @override
  State<DriverWithoutOrderView> createState() => _DriverWithoutOrderViewState();
}

class _DriverWithoutOrderViewState extends State<DriverWithoutOrderView> {
  bool loading = false;
  bool isOpen = false;
  final _driverCtx = Get.put(DriverController());

  @override
  void initState() {
    super.initState();
    isOpen = _driverCtx.driverInfo["isOpen"];
    setState(() {});
  }

  void driverTurOnOff() async {
    loading = true;
    isOpen = !isOpen;
    dynamic driverTurOnOff = await DriverApi().driverTurOnOff(isOpen);
    loading = false;
    if (driverTurOnOff != null) {
      dynamic response = Map<String, dynamic>.from(driverTurOnOff);
      if (response["success"]) {
        _driverCtx.driverInfo["isOpen"] = response["data"];
        if (_driverCtx.driverInfo["isOpen"] == true) {
          SocketClient().connect();
          playSound("engine_start");
        } else {
          SocketClient().disconnect();
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: driverTurOnOff,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(24),
              backgroundColor: isOpen ? Colors.white : Colors.red,
            ),
            child: loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : isOpen
                    ? const Icon(
                        Icons.stop_circle_rounded,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.power_settings_new_rounded,
                        color: Colors.white,
                      )),
        SizedBox(height: Get.height * .025),
        Container(
          height: Get.height * .2,
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/png/money.png",
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
                title: Text(convertToCurrencyFormat(12000)),
                subtitle: const Text("12 хүргэлт"),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Бонус:"),
                    SizedBox(height: 4),
                    Text("+ ${convertToCurrencyFormat(6000)}")
                  ],
                ),
              ),
              Container(
                height: 7,
                color: MyColors.fadedGrey,
              ),
              ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/png/giftbox.png",
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
                title: Text("2500 урамшуулал"),
                subtitle: Text("0/2"),
                trailing: Text("12 өдөр \n үлдсэн"),
              ),
            ],
          ),
        )
      ],
    );
  }
}
