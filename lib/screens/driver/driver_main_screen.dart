import 'dart:developer';
import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/custom_loading_widget.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';

class DriverMainScreen extends StatefulWidget {
  const DriverMainScreen({super.key});

  @override
  State<DriverMainScreen> createState() => _DriverMainScreenState();
}

class _DriverMainScreenState extends State<DriverMainScreen>
    with TickerProviderStateMixin {
  bool loading = false;
  List acceptedOrders = [];
  List orders = [];
  final _driverCtx = Get.put(DriverController());
  final _loginCtx = Get.put(LoginController());
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    getAllPreparingOrders();
    getDriverInfo();
  }

  void getDriverInfo() async {
    dynamic getDriverInfo = await DriverApi().getDriverInfo();
    if (getDriverInfo != null) {
      dynamic response = Map<String, dynamic>.from(getDriverInfo);
      if (response["success"]) {
        log(response.toString());
        _driverCtx.driverInfo.value = response["data"];
      }
    }
    setState(() {});
  }

  void getAllPreparingOrders() async {
    loading = true;
    dynamic getAllPreparingOrders = await DriverApi().getAllPreparingOrders();
    loading = false;
    if (getAllPreparingOrders != null) {
      dynamic response = Map<String, dynamic>.from(getAllPreparingOrders);
      if (response["success"]) {
        orders = response["data"];
        for (var i = 0; i < orders.length; i++) {
          orders[i]["accepted"] = false;
          animationController = AnimationController(
              vsync: this,
              duration: Duration(seconds: orders[i]["prepDuration"]));
          animationController.forward();
          orders[i]["timer"] = animationController;
        }
      } else {}
    }
    setState(() {});
  }

  void showAuthDialog(Map item) {
    showGeneralDialog(
      context: context,
      barrierLabel: "",
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.bounceInOut.transform(a1.value);
        return WillPopScope(
          onWillPop: () async => false,
          child: Transform.scale(
            scale: curve,
            child: Center(
              child: Container(
                width: Get.width,
                margin: EdgeInsets.all(Get.width * .09),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(
                  right: Get.width * .09,
                  left: Get.width * .09,
                  top: Get.height * .04,
                  bottom: Get.height * .03,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        IconlyBold.lock,
                        size: Get.width * .15,
                        color: Colors.amber,
                      ),
                      SizedBox(height: Get.height * .02),
                      const Text(
                        "Баталгаажуулах",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Get.height * .02),
                      Column(
                        children: [
                          const Text(
                            "Жолоочийн дугаараа оруулж баталгаажуулна уу",
                            style: TextStyle(color: MyColors.gray),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: Get.height * .03),
                          SizedBox(
                            width: Get.width * .3,
                            child: CustomTextField(
                              autoFocus: true,
                              maxLength: 4,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(height: Get.height * .04),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                  child: CustomButton(
                                onPressed: Get.back,
                                bgColor: Colors.white,
                                text: "Хаах",
                                elevation: 0,
                                textColor: Colors.black,
                              )),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomButton(
                                  elevation: 0,
                                  bgColor: Colors.amber,
                                  text: "Submit",
                                  onPressed: () {
                                    if (!acceptedOrders.contains(item["id"])) {
                                      acceptedOrders.add(item["id"]);
                                      int index = acceptedOrders
                                          .indexWhere((e) => e == item["id"]);
                                      orders.remove(item);
                                      item["accepted"] = true;
                                      orders.insert(index, item);
                                    }
                                    setState(() {});
                                    Get.back();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            appBar: _appbar(),
            drawer: _drawer(),
            body: loading && orders.isEmpty
                ? listShimmerWidget()
                : !loading && orders.isEmpty
                    ? customEmptyWidget("Захиалга байхгүй байна")
                    : ListView.separated(
                        separatorBuilder: (context, index) {
                          return Container(
                            height: 7,
                            color: MyColors.fadedGrey,
                          );
                        },
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          var item = orders[index];
                          return item["accepted"]
                              ? _accepted1(item)
                              : _notAccepted(item);
                        },
                      )),
      ),
    );
  }

  // Widget _bottomViewsHandler(DriverStatus status) {
  //   if (status == DriverStatus.withoutOrder) {
  //     return const DriverWithoutOrderView();
  //   } else if (status == DriverStatus.incoming) {
  //     return const DriverIncomingOrderView();
  //   } else if (status == DriverStatus.arrived) {
  //     return const DriverArrivedView();
  //   } else if (status == DriverStatus.received) {
  //     return const DriverReceivedView();
  //   } else if (status == DriverStatus.delivered) {
  //     return const DriverDeliveredView();
  //   } else if (status == DriverStatus.finished) {
  //     return const DriverFinishedView();
  //   } else {
  //     return const DriverWithoutOrderView();
  //   }
  // }

  AppBar _appbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      title: _driverCtx.driverInfo.isNotEmpty && _driverCtx.driverInfo["isOpen"]
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
          value: true,
          onChanged: (value) {},
        ),
        SizedBox(width: 16),
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

  Widget _notAccepted(Map item) {
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
                "${URL.AWS}/users/${628}/small/1.png",
                isCircle: true,
              )
            ],
          ),
          SizedBox(width: Get.width * .04),
          SizedBox(
            width: Get.width * .6,
            height: Get.height * .11,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Erdenet24 market",
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item["address"],
                  overflow: TextOverflow.ellipsis,
                ),
                Text(convertToCurrencyFormat(3000)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Countdown(
                  animation: StepTween(
                    begin:
                        item["prepDuration"], // THIS IS A USER ENTERED NUMBER
                    end: 0,
                  ).animate(item["timer"]),
                ),
                TextButton(
                  onPressed: () {
                    showAuthDialog(item);
                  },
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Get.width * .04)
        ],
      ),
    );
  }

  Widget _accepted1(Map item) {
    return CustomInkWell(
      onTap: () {
        Get.bottomSheet(
          StatefulBuilder(
            builder: ((context, setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: _accepted(item),
              );
            }),
          ),
          backgroundColor: MyColors.white,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.zero,
      child: SizedBox(
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
                  "${URL.AWS}/users/${628}/small/1.png",
                  isCircle: true,
                )
              ],
            ),
            SizedBox(width: Get.width * .04),
            Expanded(
              child: SizedBox(
                height: Get.height * .11,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Erdenet24 market",
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item["address"],
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(convertToCurrencyFormat(3000)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Countdown(
                    animation: StepTween(
                      begin:
                          item["prepDuration"], // THIS IS A USER ENTERED NUMBER
                      end: 0,
                    ).animate(item["timer"]),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle_rounded,
                        size: 8,
                        color: Colors.amber,
                      ),
                      SizedBox(width: Get.width * .02),
                      Text(
                        "Бэлдэж байна",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: Get.width * .04)
          ],
        ),
      ),
    );
  }

  Widget _accepted(Map item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * .04),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: Get.width * .03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                customImage(
                  Get.width * .1,
                  "${URL.AWS}/users/${628}/small/1.png",
                  isCircle: true,
                ),
                SizedBox(width: Get.width * .04),
                SizedBox(
                  width: Get.width * .6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Erdenet24 market",
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        item["address"],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: MyColors.gray, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomInkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(8),
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
                )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: Get.width * .03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      width: Get.width * .1,
                      height: Get.width * .1,
                      color: Colors.amber,
                      child: Center(
                        child: Icon(
                          IconlyLight.profile,
                          color: MyColors.white,
                          size: 20,
                        ),
                      ),
                    )),
                SizedBox(width: Get.width * .04),
                SizedBox(
                  width: Get.width * .6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item["address"],
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Орцны код: ",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: MyColors.gray, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomInkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(8),
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
                )),
              ],
            ),
          ),
          Divider(),
          SizedBox(height: Get.width * .03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Захиалгын дугаар:"),
              Text("123456789"),
            ],
          ),
          SizedBox(height: Get.width * .03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Тоо ширхэг:"),
              Text("5 ширхэг"),
            ],
          ),

          SizedBox(height: Get.width * .08),
          CustomButton(
            text: "Хүлээн авсан",
            onPressed: () {},
          ),
          // SizedBox(height: Get.width * .04),
        ],
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Text(timerText);
  }
}
