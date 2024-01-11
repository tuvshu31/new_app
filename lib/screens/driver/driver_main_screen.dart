import 'dart:developer';
import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/countdown.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:app_settings/app_settings.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen>
    with TickerProviderStateMixin {
  bool loading = false;
  final _driverCtx = Get.put(DriverController());
  final _loginCtx = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    _driverCtx.getAllPreparingOrders();
    getDriverInfo();
  }

  void getDriverInfo() async {
    dynamic getDriverInfo = await DriverApi().getDriverInfo();
    if (getDriverInfo != null) {
      dynamic response = Map<String, dynamic>.from(getDriverInfo);
      if (response["success"]) {
        _driverCtx.driverInfo.value = response["data"];
        _driverCtx.isOnline.value = _driverCtx.driverInfo["isOpen"];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: _appbar(),
          drawer: _drawer(),
          body: !_driverCtx.isOnline.value
              ? customEmptyWidget("Та идэвхгүй байна")
              : _driverCtx.fetchingOrders.value && _driverCtx.orders.isEmpty
                  ? listShimmerWidget()
                  : !_driverCtx.fetchingOrders.value &&
                          _driverCtx.orders.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomInkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: _driverCtx.refreshOrders,
                                child: Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.refresh_rounded,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              SizedBox(height: Get.width * .04),
                              const Text(
                                "Захиалга байхгүй байна",
                                style: TextStyle(
                                  color: MyColors.gray,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          color: MyColors.primary,
                          onRefresh: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 600));
                            _driverCtx.refreshOrders();
                          },
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return Container(
                                height: 7,
                                color: MyColors.fadedGrey,
                              );
                            },
                            itemCount: _driverCtx.orders.length,
                            itemBuilder: (context, index) {
                              var item = _driverCtx.orders[index];
                              return item["acceptedByMe"]
                                  ? CustomInkWell(
                                      onTap: () =>
                                          _driverCtx.showOrderBottomSheet(item),
                                      child: _listItem(item))
                                  : _listItem(item);
                            },
                          ),
                        ),
        ),
      ),
    );
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
                  item["storeName"],
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item["address"],
                  overflow: TextOverflow.ellipsis,
                ),
                Text(convertToCurrencyFormat(item["deliveryPrice"] ?? 0)),
                SizedBox(height: Get.width * .01),
              ],
            ),
          ),
          item["acceptedByMe"] == true
              ? Expanded(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Countdown(
                      animation: StepTween(
                        begin: item["initialDuration"] ?? 0,
                        end: 0,
                      ).animate(item["timer"]),
                    ),
                    status(item["orderStatus"])
                  ],
                ))
              : Expanded(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Countdown(
                      animation: StepTween(
                        begin: item["initialDuration"] ?? 0,
                        end: 0,
                      ).animate(item["timer"]),
                    ),
                    item["orderStatus"] == "driverAccepted"
                        ? TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
                            child: Text(item["driverName"]),
                          )
                        : TextButton(
                            onPressed: () {
                              _driverCtx.showPasswordDialog(item);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Accept'),
                          ),
                  ],
                )),
          SizedBox(width: Get.width * .04)
        ],
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: _driverCtx.driverInfo.isNotEmpty && _driverCtx.isOnline.value
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 12,
                ),
                SizedBox(width: 8),
                Text(
                  "Online",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            )
          : const Text(
              "Offline",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
      actions: [
        CupertinoSwitch(
          value: _driverCtx.isOnline.value,
          onChanged: (value) {
            _driverCtx.driverTurOnOff();
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _drawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          DrawerHeader(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.white,
                  border: Border.all(width: 1, color: MyColors.background),
                ),
                child: const Icon(
                  Icons.account_balance,
                  size: 40,
                  color: MyColors.grey,
                ),
              ),
              loading
                  ? CustomShimmer(width: Get.width * .2, height: 14)
                  : Text("Name")
            ],
          )),
          _drawerListTile(IconlyLight.user, "Миний бүртгэл", () {
            Get.toNamed(driverSettingsScreenRoute);
          }),
          _drawerListTile(IconlyLight.setting, "Тохиргоо", () {
            AppSettings.openAppSettings();
          }),
          _drawerListTile(IconlyLight.location, "Хүргэлтүүд", () {
            Get.toNamed(driverDeliverListScreenRoute);
          }),
          _drawerListTile(IconlyLight.wallet, "Төлбөр", () {
            Get.toNamed(driverPaymentsScreenRoute);
          }),
          _drawerListTile(IconlyLight.logout, "Аппаас гарах", () {
            CustomDialogs().showLogoutDialog(() {
              _loginCtx.logout();
            });
          }),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _drawerListTile(IconData icon, String title, dynamic onTap) {
    return CustomInkWell(
      borderRadius: BorderRadius.zero,
      onTap: onTap,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: Get.width * .075),
        dense: true,
        minLeadingWidth: Get.width * .07,
        leading: Icon(
          icon,
          color: MyColors.black,
          size: 20,
        ),
        title: CustomText(
          text: title,
          fontSize: 14,
        ),
      ),
    );
  }
}
