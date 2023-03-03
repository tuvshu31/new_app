import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/screens/user/home/home.dart';
import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:percent_indicator/percent_indicator.dart';

class UserOrderActiveScreen extends StatefulWidget {
  const UserOrderActiveScreen({
    super.key,
  });

  @override
  State<UserOrderActiveScreen> createState() => _UserOrderActiveScreenState();
}

class _UserOrderActiveScreenState extends State<UserOrderActiveScreen> {
  List statusList = ["Баталгаажсан", "Бэлтгэж байна", 'Хүргэж байна'];
  final _userCtx = Get.put(UserController());
  final _driverCtx = Get.put(DriverController());
  int driverId = 0;
  LatLng driverLatLng = LatLng(49.02821126030273, 104.04634376483777);
  double driverHeading = 0;
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _userCtx.getActiveOrderInfo();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var data = message.data;
      var jsonData = json.decode(data["data"]);
      if (RestApiHelper.getUserRole() == "user") {
        if (data["type"] == "sent") {
          _userCtx.activeOrderStep.value = 0;
        } else if (data["type"] == "received") {
          _userCtx.activeOrderStep.value = 1;
          _userCtx.activeOrderChangeScreen(1);
        } else if (data["type"] == "preparing") {
          _userCtx.activeOrderStep.value = 2;
          _userCtx.activeOrderChangeScreen(2);
        } else if (data["type"] == "delivering") {
          _userCtx.activeOrderStep.value = 3;
          _userCtx.activeOrderChangeScreen(3);
          setState(() {
            driverId = int.parse(jsonData["deliveryDriverId"]);
          });
          fetchDriverPositionSctream(driverId);
        } else if (data["type"] == "delivered") {
          _userCtx.activeOrderStep.value = 0;
          Get.to(() => const MainScreen());
          RestApiHelper.saveOrderId(0);
        } else {}
      }
    });
  }

  void fetchDriverPositionSctream(int id) {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      dynamic response = await RestApi().getDriver(id);
      dynamic d = Map<String, dynamic>.from(response);
      if (d["success"]) {
        setState(() {
          driverHeading = double.parse(d["data"][0]["heading"]);
          driverLatLng = LatLng(double.parse(d["data"][0]["latitude"]),
              double.parse(d["data"][0]["longitude"]));
        });
      }
      CameraPosition currentCameraPosition = CameraPosition(
        bearing: 0,
        target: driverLatLng,
        zoom: 16,
      );
      _driverCtx.addDriverMarker();
      final GoogleMapController controller = await mapController.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition));
    });
  }

  void onMapCreated(GoogleMapController controller) async {
    mapController.complete(controller);
    Future.delayed(const Duration(seconds: 1), () async {
      GoogleMapController controller = await mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: driverLatLng,
            zoom: 17.0,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Obx(
        () => _userCtx.userOrderList.isEmpty
            ? Material(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18)),
                        child: Image(
                          image:
                              const AssetImage("assets/images/png/android.png"),
                          width: Get.width * .22,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "ERDENET24",
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: "Exo",
                          fontSize: 22,
                          color: MyColors.black,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : CustomHeader(
                withTabBar: true,
                customLeading: Container(),
                centerTitle: true,
                customTitle: const CustomText(
                  text: "Захиалга",
                  color: MyColors.black,
                  fontSize: 16,
                ),
                customActions: Container(),
                body: Column(
                  children: [
                    _stepper(),
                    Expanded(
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (value) {
                          _userCtx.activeOrderStep.value = value;
                        },
                        controller: _userCtx.activeOrderPageController.value,
                        children: [
                          step0(),
                          step0(),
                          step1(),
                          step2(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _stepper() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearPercentIndicator(
              backgroundColor: MyColors.black,
              alignment: MainAxisAlignment.center,
              barRadius: const Radius.circular(12),
              lineHeight: 8.0,
              percent: _userCtx.activeOrderStep.value == 0
                  ? 0
                  : _userCtx.activeOrderStep.value == 1
                      ? 0.25
                      : _userCtx.activeOrderStep.value == 2
                          ? 0.5
                          : 1,
              progressColor: MyColors.primary,
              curve: Curves.bounceIn,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _buildRowList(),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRowList() {
    List<Widget> lines = [];
    statusList.asMap().forEach((index, value) {
      bool active = index + 1 == _userCtx.activeOrderStep.value;
      lines.add(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: value,
            color: active ? MyColors.black : MyColors.gray,
          ),
          const SizedBox(height: 4),
          active
              ? CustomText(
                  text: _userCtx.userOrderList[0]["orderTime"],
                  color: MyColors.gray,
                  fontSize: 10,
                )
              : Container(),
        ],
      ));
    });
    return lines;
  }

  Widget step0() {
    return Column(
      children: [
        _orderInfoView(),
        const Image(image: AssetImage("assets/images/png/app/banner1.jpg"))
      ],
    );
  }

  Widget step1() {
    return Column(
      children: [
        _orderInfoView(),
        const Image(image: AssetImage("assets/images/png/app/banner1.jpg"))
      ],
    );
  }

  Widget step2() {
    return Obx(
      () => Column(
        children: [
          _orderInfoView(),
          Expanded(
            child: GoogleMap(
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              mapType: MapType.normal,
              buildingsEnabled: true,
              myLocationButtonEnabled: true,
              onCameraMove: _driverCtx.onCameraMove,
              rotateGesturesEnabled: true,
              trafficEnabled: false,
              compassEnabled: false,
              markers: Set<Marker>.of(_driverCtx.markers.values),
              initialCameraPosition: CameraPosition(
                target: driverLatLng,
                zoom: 14.4746,
              ),
              onMapCreated: _driverCtx.onMapCreated,
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderInfoView() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Container(
              height: 7,
              color: MyColors.fadedGrey,
            ),
            CustomInkWell(
              onTap: () => userActiveOrderDetailView(context),
              borderRadius: BorderRadius.zero,
              child: SizedBox(
                height: Get.height * .09,
                child: Center(
                  child: ListTile(
                    leading: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                            text:
                                "Захиалгын дугаар: ${_userCtx.userOrderList[0]["orderId"]}"),
                        const SizedBox(height: 4),
                        CustomText(
                          text: _userCtx.userOrderList[0]["orderTime"],
                          color: MyColors.gray,
                          fontSize: 10,
                        )
                      ],
                    ),
                    trailing: Icon(IconlyLight.arrow_right_2),
                  ),
                ),
              ),
            ),
            Container(
              height: 7,
              color: MyColors.fadedGrey,
            ),
          ],
        ),
      ),
    );
  }
}

void userActiveOrderDetailView(context) {
  final userCtx = Get.put(UserController());
  var productInfo = userCtx.userOrderList[0];
  showModalBottomSheet(
    backgroundColor: MyColors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomText(
                  text: "Захиалгын код:",
                  fontSize: 14,
                  color: MyColors.gray,
                ),
                CustomText(
                  text: productInfo["orderId"].toString(),
                  fontSize: 16,
                  color: MyColors.black,
                ),
                const SizedBox(height: 12),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 7,
                      color: MyColors.fadedGrey,
                    );
                  },
                  shrinkWrap: true,
                  itemCount: productInfo["products"].length,
                  itemBuilder: (context, index) {
                    var product = productInfo["products"][index];
                    return Container(
                        height: Get.height * .09,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        color: MyColors.white,
                        child: Center(
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            minLeadingWidth: Get.width * .15,
                            leading: Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12)),
                                child: CachedImage(
                                    image:
                                        "${URL.AWS}/products/${product["id"]}/small/1.png")),
                            title: CustomText(
                              text: product["name"],
                              fontSize: 14,
                            ),
                            subtitle: CustomText(
                                text: convertToCurrencyFormat(
                              int.parse(product["price"]),
                              toInt: true,
                              locatedAtTheEnd: true,
                            )),
                            trailing: CustomText(
                                text: "${product["quantity"]} ширхэг"),
                          ),
                        ));
                  },
                ),
                Container(
                  height: 7,
                  color: MyColors.fadedGrey,
                ),
                SizedBox(
                  height: Get.height * .09,
                  child: Center(
                    child: ListTile(
                      leading: const CustomText(text: "Нийт үнэ:"),
                      trailing: CustomText(
                        text: convertToCurrencyFormat(
                          int.parse(productInfo["totalAmount"]),
                          toInt: true,
                          locatedAtTheEnd: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
