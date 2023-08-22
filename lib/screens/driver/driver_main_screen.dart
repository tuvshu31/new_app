import 'dart:async';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/screens/driver/views/driver_arrived_view.dart';
import 'package:Erdenet24/screens/driver/views/driver_delivered_view.dart';
import 'package:Erdenet24/screens/driver/views/driver_finished_view.dart';
import 'package:Erdenet24/screens/driver/views/driver_incoming_order_view.dart';
import 'package:Erdenet24/screens/driver/views/driver_received_view.dart';
import 'package:Erdenet24/screens/driver/views/driver_without_order_view.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:get/get.dart';
import "package:flutter/material.dart";
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/screens/driver/driver_drawer_screen.dart';
import 'package:Erdenet24/screens/driver/driver_map_screen.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen>
    with TickerProviderStateMixin {
  late Animation<Offset> offset;

  late CustomTimerController timerController = CustomTimerController(
    vsync: this,
    begin: const Duration(hours: 2),
    end: const Duration(),
    initialState: CustomTimerState.reset,
    interval: CustomTimerInterval.milliseconds,
  );
  final _driverCtx = Get.put(DriverController());

  @override
  void initState() {
    super.initState();
    _driverCtx.showBottomView();
    checkIfDriverOnline();
    checkDriverOrder();

    _driverCtx.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    offset = Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
        .animate(_driverCtx.animationController);
  }

  Future<void> checkIfDriverOnline() async {
    dynamic response = await RestApi().getDriver(RestApiHelper.getUserId());
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      _driverCtx.isOnline.value = d["data"][0]["isOpen"];
      if (_driverCtx.isOnline.value) {
        _driverCtx.playSound("engine_start");
        timerController.start();
        _driverCtx.animationController.forward();
      }
    }
  }

  Future<void> checkDriverOrder() async {
    dynamic response =
        await RestApi().checkDriverOrder(RestApiHelper.getUserId());
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"] && d["withOrder"]) {
      _driverCtx.hideBottomView();
      _driverCtx.newOrderInfo.value = d["order"];
      _driverCtx.driverStatus.value = d["orderStep"] == 1
          ? DriverStatus.arrived
          : d["orderStep"] == 2
              ? DriverStatus.received
              : d["orderStep"] == 3
                  ? DriverStatus.delivered
                  : DriverStatus.finished;
      _driverCtx.showBottomView();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _driverCtx.animationController.dispose();
  }

  Widget _bottomViewsHandler(DriverStatus status) {
    if (status == DriverStatus.withoutOrder) {
      return const DriverWithoutOrderView();
    } else if (status == DriverStatus.incoming) {
      return const DriverIncomingOrderView();
    } else if (status == DriverStatus.arrived) {
      return const DriverArrivedView();
    } else if (status == DriverStatus.received) {
      return const DriverReceivedView();
    } else if (status == DriverStatus.delivered) {
      return const DriverDeliveredView();
    } else if (status == DriverStatus.finished) {
      return const DriverFinishedView();
    } else {
      return const DriverWithoutOrderView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          drawer: const DriverDrawerScreen(),
          body: Builder(
            builder: (context) => Stack(
              children: [
                const DriverMapScreen(),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).viewPadding.top + 12,
                      horizontal: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Icon(
                            Icons.menu_rounded,
                            color: MyColors.primary,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 4),
                          ),
                          child: Obx(
                            () => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      convertToCurrencyFormat(
                                          _driverCtx.driverBonusInfo[
                                                  "totalDeliveryPrice"] ??
                                              0),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "${_driverCtx.driverBonusInfo["deliveryCount"] ?? 0} хүргэлт",
                                      style: const TextStyle(
                                          color: MyColors.gray, fontSize: 12),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => SlideTransition(
                    position: offset,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _bottomViewsHandler(_driverCtx.driverStatus.value),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
