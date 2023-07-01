import 'dart:async';
import 'dart:developer';

import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/controller/network_controller.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/snackbar.dart';

import 'package:get/get.dart';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:circular_countdown/circular_countdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/screens/driver/driver_bottom_views.dart';
import 'package:Erdenet24/screens/driver/driver_drawer_screen.dart';
import 'package:Erdenet24/screens/driver/driver_screen_map_view.dart';

import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/styles.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen> {
  final _driverCtx = Get.put(DriverController());
  final _loginCtx = Get.put(LoginController());
  final GlobalKey<SlideActionState> key = GlobalKey();
  TextEditingController driverApproveCodeCtrl = TextEditingController();

  List<Widget> steps = [
    step0(),
    step1(),
    step2(),
    step3(),
    step4(),
    step5(),
  ];
  List<String> texts = [
    "",
    "Зөвшөөрөх",
    "Ирлээ",
    "Хүлээн авсан",
    "Хүлээлгэн өгсөн",
    "Дуусгах"
  ];
  @override
  void initState() {
    super.initState();
    _loginCtx.getFirebaseMessagingToken(context);
    _driverCtx.fetchDriverInfo(context);
    _driverCtx.fetchDriverOrders();
    _driverCtx.fetchDriverPayments();
    _driverCtx.checkIfDriverKilled();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: MyColors.white,
              drawer: driverDrawer(context),
              appBar: _appBar(),
              body: Stack(
                children: [
                  const DriverScreenMapView(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      bottomSheets(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSize _appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(54.0),
      child: AppBar(
        iconTheme: const IconThemeData(color: MyColors.primary),
        backgroundColor: MyColors.white,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        title: CustomText(
          text: _driverCtx.isOnline.value ? "Online" : "Offline",
          color: MyColors.black,
          fontSize: 16,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: CupertinoSwitch(
                value: _driverCtx.isOnline.value,
                thumbColor: _driverCtx.isOnline.value
                    ? MyColors.primary
                    : MyColors.gray,
                trackColor: MyColors.background,
                activeColor: MyColors.black,
                onChanged: (value) {
                  if (_driverCtx.step.value == 0) {
                    _driverCtx.turnOnOff(value, context);
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget bottomSheets() {
    return Obx(
      () => _driverCtx.isOnline.value
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: MyColors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _driverCtx.step.value == 0 && _driverCtx.lastDelivery.isEmpty
                      ? Container()
                      : _driverCtx.step.value == 0 &&
                              _driverCtx.lastDelivery.isNotEmpty
                          ? step0()
                          : steps[_driverCtx.step.value],
                  _driverCtx.step.value != 0
                      ? Builder(
                          builder: (context) {
                            final GlobalKey<SlideActionState> key = GlobalKey();
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SlideAction(
                                outerColor: MyColors.black,
                                innerColor: MyColors.primary,
                                elevation: 0,
                                key: key,
                                submittedIcon: const Icon(
                                  FontAwesomeIcons.check,
                                  color: MyColors.white,
                                ),
                                onSubmit: () {
                                  Future.delayed(
                                      const Duration(milliseconds: 300), () {
                                    key.currentState!.reset();
                                    if (_driverCtx.step.value == 1) {
                                      stopSound();
                                      // AwesomeNotifications().dismiss(1);
                                      _driverCtx.updateOrder({
                                        "orderStatus": "driverAccepted",
                                        "deliveryDriverId":
                                            RestApiHelper.getUserId().toString()
                                      });
                                      RestApiHelper.saveOrderId(int.parse(
                                          _driverCtx.deliveryInfo["id"]));
                                      _driverCtx.stopwatch.value.start();
                                      _driverCtx.step.value += 1;
                                    } else if (_driverCtx.step.value == 2) {
                                      RestApiHelper.saveOrderInfo(
                                          _driverCtx.deliveryInfo);
                                      _driverCtx.step.value += 1;
                                      log(_driverCtx.step.value.toString());
                                    } else if (_driverCtx.step.value == 3) {
                                      _driverCtx.updateOrder({
                                        "orderStatus": "delivering",
                                      });
                                      _driverCtx.step.value += 1;
                                      log(_driverCtx.step.value.toString());
                                    } else if (_driverCtx.step.value == 4) {
                                      driverApproveCodeCtrl.clear();
                                      driverDeliveryCodeApproveDialog(
                                        context,
                                        driverApproveCodeCtrl,
                                        () {
                                          if (driverApproveCodeCtrl.text ==
                                              _driverCtx.deliveryInfo[
                                                  "userAndDriverCode"]) {
                                            Get.back();
                                            var deliveryDuration = _driverCtx
                                                .stopwatch
                                                .value
                                                .elapsed
                                                .inSeconds;
                                            _driverCtx.updateOrder({
                                              "orderStatus": "delivered",
                                              "deliveryDuration":
                                                  deliveryDuration,
                                              "deliveryPrice": "3000",
                                              "deliveryPaidOff": false,
                                            });
                                            _driverCtx.fakeDeliveryTimer.value =
                                                deliveryDuration.toString();
                                            _driverCtx.stopwatch.value.reset();
                                            _driverCtx.deliveryInfo.clear();
                                            _driverCtx.storeLocation.refresh();
                                            _driverCtx.step.value += 1;
                                          } else {
                                            errorSnackBar(
                                                "Захиалгын код буруу байна",
                                                3,
                                                context);
                                          }
                                        },
                                      );
                                    } else {
                                      _driverCtx.finishDelivery();
                                    }
                                  });
                                },
                                alignment: Alignment.centerRight,
                                sliderButtonIcon: const Icon(
                                  Icons.double_arrow_rounded,
                                  color: MyColors.white,
                                ),
                                child: Text(
                                  texts[_driverCtx.step.value].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                ]),
              ),
            )
          : Container(),
    );
  }
}
