import 'package:Erdenet24/screens/user/user_products_screen.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/user_controller.dart';

class UserOrderActiveScreen extends StatefulWidget {
  const UserOrderActiveScreen({
    super.key,
  });

  @override
  State<UserOrderActiveScreen> createState() => _UserOrderActiveScreenState();
}

class _UserOrderActiveScreenState extends State<UserOrderActiveScreen> {
  final _userCtx = Get.put(UserController());
  List statusList = ["Баталгаажсан", "Бэлтгэж байна", 'Хүргэж байна'];

  @override
  void initState() {
    super.initState();
    // saveUserToken();
    _userCtx.getCurrentOrderInfo(1412);
    // _userCtx.userOrderList[0];
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getFormattedTime() {
    DateTime now = DateTime.now();
    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');
    String second = now.second.toString().padLeft(2, '0');
    return "$hour:$minute:$second";
  }

  _percent() {
    switch (_userCtx.activeStep.value) {
      case 0:
        return .01;
      case 1:
        return .25;
      case 2:
        return .5;
      case 3:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Obx(
        () => _userCtx.userOrderList.isEmpty
            ? _loadingLogo()
            : CustomHeader(
                withTabBar: true,
                customLeading: Container(),
                centerTitle: true,
                customTitle: const CustomText(
                  text: "Таны захиалга",
                  color: MyColors.black,
                  fontSize: 16,
                ),
                customActions: Container(),
                body: Column(
                  children: [
                    _stepper(),
                    _orderInfoView(),
                    _bottomViews(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _stepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearPercentIndicator(
            backgroundColor: MyColors.black,
            alignment: MainAxisAlignment.center,
            barRadius: const Radius.circular(12),
            lineHeight: 8.0,
            percent: _percent(),
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
    );
  }

  List<Widget> _buildRowList() {
    List<Widget> lines = [];
    statusList.asMap().forEach((index, value) {
      bool active = index + 1 == _userCtx.activeStep.value;
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
                  text: getFormattedTime(),
                  color: MyColors.gray,
                  fontSize: 10,
                )
              : Container(),
        ],
      ));
    });
    return lines;
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
                                "Захиалгаа авах код: ${_userCtx.userOrderList[0]["userAndDriverCode"]}"),
                        const SizedBox(height: 4),
                        CustomText(
                          text: _userCtx.userOrderList[0]["orderTime"],
                          color: MyColors.gray,
                          fontSize: 10,
                        )
                      ],
                    ),
                    trailing: _userCtx.activeStep.value == 2 &&
                            !_userCtx.loading.value
                        ? CircularCountDownTimer(
                            width: 50,
                            height: 50,
                            isReverse: true,
                            duration: int.parse(
                                    _userCtx.userOrderList[0]["prepDuration"]) *
                                60,
                            timeFormatterFunction:
                                (defaultFormatterFunction, duration) {
                              if (duration.inSeconds == 0) {
                                return "0";
                              } else {
                                return Function.apply(
                                    defaultFormatterFunction, [duration]);
                              }
                            },
                            fillColor: MyColors.primary,
                            ringColor: MyColors.black,
                            strokeCap: StrokeCap.round,
                            textStyle: const TextStyle(
                              fontSize: 8.0,
                            ),
                          )
                        : const Icon(IconlyLight.arrow_right_2),
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

  Widget _bottomViews() {
    return Expanded(
      child: Obx(
        () => PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _userCtx.activeOrderPageController.value,
          children: [
            const Image(
                image: AssetImage("assets/images/png/app/Banner2.webp")),
            const Image(image: AssetImage("assets/images/png/app/banner1.jpg")),
            const Image(image: AssetImage("assets/images/png/app/banner1.jpg")),
            GoogleMap(
              scrollGesturesEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              mapType: MapType.normal,
              buildingsEnabled: true,
              myLocationButtonEnabled: true,
              onCameraMove: _userCtx.onCameraMove,
              rotateGesturesEnabled: true,
              trafficEnabled: false,
              compassEnabled: false,
              markers: Set<Marker>.of(_userCtx.markers.values),
              initialCameraPosition: CameraPosition(
                target: _userCtx.driverPosition.value,
                zoom: 14.4746,
              ),
              onMapCreated: _userCtx.onMapCreated,
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingLogo() {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(18)),
              child: Image(
                image: const AssetImage("assets/images/png/android.png"),
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
