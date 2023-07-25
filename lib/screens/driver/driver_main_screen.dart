import 'dart:async';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:get/get.dart';
import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:iconly/iconly.dart';
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
    // _loginCtx.listenToTokenChanges("driver");
    checkIfDriverOnline();
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

  @override
  void dispose() {
    super.dispose();
    _driverCtx.animationController.dispose();
  }

  Widget _bottomViewsHandler(DriverStatus status) {
    if (status == DriverStatus.withoutOrder) {
      return withoutOrderView();
    } else if (status == DriverStatus.incomingNewOrder) {
      return incomingNewOrderView();
    } else if (status == DriverStatus.arrivedAtStore) {
      return arrivedAtStoreView();
    } else if (status == DriverStatus.receivedTheOrder) {
      return receivedTheOrderView();
    } else if (status == DriverStatus.deliveredTheOrder) {
      return deliveredTheOrderView();
    } else if (status == DriverStatus.deliveredTheOrder) {
      return deliveredTheOrderView();
    } else {
      return withoutOrderView();
    }
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
              drawer: driverDrawer(),
              appBar: _appBar(),
              body: _body(),
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
        title: _driverCtx.isOnline.value
            ? const Text(
                "Online",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              )
            : const Text(
                "Offline",
                style: TextStyle(
                  color: MyColors.gray,
                  fontSize: 16,
                ),
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
                onChanged: (value) async {
                  CustomDialogs().showLoadingDialog();
                  var body = {"isOpen": value};
                  dynamic response = await RestApi()
                      .updateDriver(RestApiHelper.getUserId(), body);
                  Get.back();
                  if (response != null) {
                    _driverCtx.isOnline.value = value;
                    if (value) {
                      _driverCtx.playSound("engine_start");
                      timerController.start();
                      _driverCtx.animationController.forward();
                    } else {
                      timerController.finish();
                      _driverCtx.animationController.reverse();
                    }
                  }
                  setState(() {});
                }),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        const DriverScreenMapView(),
        _driverCtx.isOnline.value
            ? Container(
                height: Get.height * .075,
                width: double.infinity,
                color: MyColors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        dense: true,
                        horizontalTitleGap: 0,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              IconlyLight.wallet,
                            ),
                          ],
                        ),
                        title: const CustomText(
                          text: "Өнөөдрийн орлого:",
                          fontSize: 12,
                        ),
                        subtitle: CustomText(
                            text: convertToCurrencyFormat(
                          3000,
                          locatedAtTheEnd: true,
                          toInt: true,
                        )),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        dense: true,
                        horizontalTitleGap: 0,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              IconlyLight.time_circle,
                            ),
                          ],
                        ),
                        title: const CustomText(
                          text: "Идэвхтэй хугацаа:",
                          fontSize: 12,
                        ),
                        subtitle: CustomTimer(
                          controller: timerController,
                          builder: (state, time) {
                            return Text(
                              "${time.hours}:${time.minutes}:${time.seconds}",
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
        SlideTransition(
          position: offset,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: _driverCtx.isOnline.value
                  ? _bottomViewsHandler(_driverCtx.driverStatus.value)
                  : Container(),
            ),
          ),
        )
      ],
    );
  }

  // Widget bottomSheets() {
  //   return Obx(
  //     () => _driverCtx.isOnline.value
  //         ? Align(
  //             alignment: Alignment.bottomCenter,
  //             child: Container(
  //               margin: const EdgeInsets.all(24),
  //               padding: const EdgeInsets.all(24),
  //               decoration: BoxDecoration(
  //                 color: MyColors.white,
  //                 borderRadius: BorderRadius.circular(24),
  //               ),
  //               child: Column(mainAxisSize: MainAxisSize.min, children: [
  //                 _driverCtx.step.value == 0 && _driverCtx.lastDelivery.isEmpty
  //                     ? Container()
  //                     : _driverCtx.step.value == 0 &&
  //                             _driverCtx.lastDelivery.isNotEmpty
  //                         ? step0()
  //                         : steps[_driverCtx.step.value],
  //                 _driverCtx.step.value != 0
  //                     ? Builder(
  //                         builder: (context) {
  //                           final GlobalKey<SlideActionState> key = GlobalKey();
  //                           return Padding(
  //                             padding: const EdgeInsets.all(8.0),
  //                             child: SlideAction(
  //                               outerColor: MyColors.black,
  //                               innerColor: MyColors.primary,
  //                               elevation: 0,
  //                               key: key,
  //                               submittedIcon: const Icon(
  //                                 FontAwesomeIcons.check,
  //                                 color: MyColors.white,
  //                               ),
  //                               onSubmit: () {
  //                                 Future.delayed(
  //                                     const Duration(milliseconds: 300), () {
  //                                   key.currentState!.reset();
  //                                   if (_driverCtx.step.value == 1) {
  //                                     stopSound();
  //                                     // AwesomeNotifications().dismiss(1);
  //                                     _driverCtx.updateOrder({
  //                                       "orderStatus": "driverAccepted",
  //                                       "deliveryDriverId":
  //                                           RestApiHelper.getUserId().toString()
  //                                     });
  //                                     RestApiHelper.saveOrderId(int.parse(
  //                                         _driverCtx.deliveryInfo["id"]));
  //                                     _driverCtx.stopwatch.value.start();
  //                                     _driverCtx.step.value += 1;
  //                                   } else if (_driverCtx.step.value == 2) {
  //                                     RestApiHelper.saveOrderInfo(
  //                                         _driverCtx.deliveryInfo);
  //                                     _driverCtx.step.value += 1;
  //                                     log(_driverCtx.step.value.toString());
  //                                   } else if (_driverCtx.step.value == 3) {
  //                                     _driverCtx.updateOrder({
  //                                       "orderStatus": "delivering",
  //                                     });
  //                                     _driverCtx.step.value += 1;
  //                                     log(_driverCtx.step.value.toString());
  //                                   } else if (_driverCtx.step.value == 4) {
  //                                     driverApproveCodeCtrl.clear();
  //                                     driverDeliveryCodeApproveDialog(
  //                                       context,
  //                                       driverApproveCodeCtrl,
  //                                       () {
  //                                         if (driverApproveCodeCtrl.text ==
  //                                             _driverCtx.deliveryInfo[
  //                                                 "userAndDriverCode"]) {
  //                                           Get.back();
  //                                           var deliveryDuration = _driverCtx
  //                                               .stopwatch
  //                                               .value
  //                                               .elapsed
  //                                               .inSeconds;
  //                                           _driverCtx.updateOrder({
  //                                             "orderStatus": "delivered",
  //                                             "deliveryDuration":
  //                                                 deliveryDuration,
  //                                             "deliveryPrice": "3000",
  //                                             "deliveryPaidOff": false,
  //                                           });
  //                                           _driverCtx.fakeDeliveryTimer.value =
  //                                               deliveryDuration.toString();
  //                                           _driverCtx.stopwatch.value.reset();
  //                                           _driverCtx.deliveryInfo.clear();
  //                                           _driverCtx.storeLocation.refresh();
  //                                           _driverCtx.step.value += 1;
  //                                         } else {
  //                                           customSnackbar(DialogType.error,
  //                                               "Захиалгын код буруу байна", 3);
  //                                         }
  //                                       },
  //                                     );
  //                                   } else {
  //                                     _driverCtx.finishDelivery();
  //                                   }
  //                                 });
  //                               },
  //                               alignment: Alignment.centerRight,
  //                               sliderButtonIcon: const Icon(
  //                                 Icons.double_arrow_rounded,
  //                                 color: MyColors.white,
  //                               ),
  //                               child: Text(
  //                                 texts[_driverCtx.step.value].toUpperCase(),
  //                                 style: const TextStyle(
  //                                   color: Colors.white,
  //                                   fontSize: 14,
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                       )
  //                     : Container(),
  //               ]),
  //             ),
  //           )
  //         : Container(),
  //   );
  // }
}
