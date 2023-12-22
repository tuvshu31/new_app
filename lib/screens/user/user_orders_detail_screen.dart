import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserOrdersDetailScreen extends StatefulWidget {
  final int id;
  final String orderId;
  const UserOrdersDetailScreen({
    required this.id,
    required this.orderId,
    super.key,
  });

  @override
  State<UserOrdersDetailScreen> createState() => _UserOrdersDetailScreenState();
}

class _UserOrdersDetailScreenState extends State<UserOrdersDetailScreen> {
  bool showUserAndDriverCode = true;
  int prepDuration = 60;
  int initialDuration = 0;
  int step = 1;
  bool loading = false;
  Map order = {};

  @override
  void initState() {
    super.initState();
    getUserOrderDetails();
  }

  void getUserOrderDetails() async {
    loading = true;
    dynamic getUserOrderDetails =
        await UserApi().getUserOrderDetails(widget.id);
    loading = false;
    if (getUserOrderDetails != null) {
      dynamic response = Map<String, dynamic>.from(getUserOrderDetails);
      if (response["success"]) {
        order = response["data"];
        step = order["orderStep"];
      }
    }
    setState(() {});
  }

  List statusList = [
    {
      "text": "Баталгаажсан",
      "wrappedText": "Баталгаажсан",
      "icon": Icons.check,
    },
    {
      "text": "Бэлдэж байна",
      "wrappedText": "Бэлдэж \n байна",
      "icon": Icons.check,
    },
    {
      "text": "Хүргэж байна",
      "wrappedText": "Хүргэж \n байна",
      "icon": Icons.check,
    },
    {
      "text": "Хүргэсэн",
      "wrappedText": "Хүргэсэн",
      "icon": Icons.check,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: SafeArea(
        child: CustomHeader(
          centerTitle: true,
          customLeading: Container(),
          customActions: CustomInkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: Get.back,
            child: Container(
              decoration: BoxDecoration(
                color: MyColors.fadedGrey,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.black,
              ),
            ),
          ),
          title: "Захиалга",
          subtitle: Text(
            widget.orderId,
            style: const TextStyle(
              color: MyColors.gray,
              fontSize: 12,
            ),
          ),
          // body: listShimmerWidget(),
          body: loading
              ? listShimmerWidget()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 12),
                      _stepper(),
                      const SizedBox(height: 12),
                      _divider(),
                      const SizedBox(height: 12),
                      _statusInfo(),
                      const SizedBox(height: 12),
                      _divider(),
                      const SizedBox(height: 12),
                      _addressInfo(),
                      const SizedBox(height: 12),
                      _divider(),
                      _productsInfoAndMap(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _stepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _dot(step >= 1),
              _line(step > 1),
              _dot(step >= 2),
              _line(step > 2),
              _dot(step >= 3),
              _line(step > 3),
              _dot(step == 4),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text(0),
              _text(1),
              _text(2),
              _text(3),
            ],
          )
        ],
      ),
    );
  }

  Widget _dot(bool isActive) {
    return Container(
      width: 12,
      height: 12,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? MyColors.primary : Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _line(bool isActive) {
    return Expanded(
      child: Container(
        height: 3,
        decoration: BoxDecoration(
          color: isActive ? MyColors.primary : Colors.black,
        ),
      ),
    );
  }

  Widget _text(int index) {
    return Text(
      statusList[index]["wrappedText"],
      style: const TextStyle(fontSize: 10),
    );
  }

  Widget _divider() {
    return Container(
      height: 7,
      color: MyColors.fadedGrey,
    );
  }

  Widget _statusInfo() {
    Map element = statusList[step - 1];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                element["icon"],
                color: MyColors.primary,
              ),
              const SizedBox(width: 12),
              Text(
                element["text"],
                style: const TextStyle(color: Colors.red, fontSize: 12),
              )
            ],
          ),
          step == 2
              ? CircularCountDownTimer(
                  width: Get.height * .07,
                  height: Get.height * .07,
                  duration: order["prepDuration"],
                  initialDuration: order["initialDuration"],
                  fillColor: MyColors.background,
                  isReverse: true,
                  ringColor: Colors.red,
                )
              : CustomText(
                  text: order["updatedAt"],
                  color: MyColors.gray,
                  fontSize: 10,
                )
        ],
      ),
    );
  }

  Widget _addressInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Хүргэлтийн хаяг"),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: "Хаяг:",
                color: MyColors.gray,
              ),
              CustomText(
                text: order["address"] ?? "N/a",
                color: MyColors.gray,
                fontSize: 12,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                text: "Утас:",
                color: MyColors.gray,
              ),
              CustomText(
                text: order["phone"] ?? "N/a",
                color: MyColors.gray,
                fontSize: 12,
              ),
            ],
          ),
          const SizedBox(height: 12),
          showUserAndDriverCode
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Захиалгаа авах код:",
                      color: MyColors.gray,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12)),
                      child: CustomText(
                        text: "${order["code"]}",
                        color: MyColors.white,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _productsInfoAndMap() {
    return step == 3
        ? SizedBox(
            height: Get.height * .6,
            child: const GoogleMap(
              scrollGesturesEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              mapType: MapType.normal,
              buildingsEnabled: true,
              myLocationButtonEnabled: true,
              // onCameraMove: _userCtx.onCameraMove,
              rotateGesturesEnabled: true,
              trafficEnabled: false,
              compassEnabled: false,
              // markers: Set<Marker>.of(_userCtx.markers.values),
              initialCameraPosition: CameraPosition(
                target: LatLng(37.42796133580664, -122.085749655962),
                zoom: 14.4746,
              ),
              // onMapCreated: _userCtx.onMapCreated,
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text("Захиалсан бараанууд"),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: order["products"].length ?? 0,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    // var product = _userCtx.selectedOrder["products"][index];
                    var item = order["products"][index];
                    return Container(
                        height: Get.height * .09,
                        color: MyColors.white,
                        child: Center(
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            // minLeadingWidth: Get.width * .15,
                            leading: SizedBox(
                              width: Get.width * .15,
                              child: customImage(
                                Get.width * .15,
                                item["image"],
                              ),
                            ),
                            title: CustomText(
                              text: item["name"],
                              fontSize: 14,
                            ),
                            subtitle: CustomText(
                                text: convertToCurrencyFormat(
                              item["price"],
                            )),
                            trailing:
                                CustomText(text: "${item["quantity"]} ширхэг"),
                          ),
                        ));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Барааны үнэ:",
                      color: MyColors.gray,
                    ),
                    CustomText(
                      text: convertToCurrencyFormat(order["productsTotal"]),
                      color: MyColors.gray,
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Хүргэлтийн төлбөр:",
                      color: MyColors.gray,
                    ),
                    CustomText(
                      text: convertToCurrencyFormat(order["deliveryPrice"]),
                      color: MyColors.gray,
                    )
                  ],
                ),
                const SizedBox(height: 12),
                const DottedLine(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  lineLength: double.infinity,
                  lineThickness: 1.0,
                  dashLength: 4.0,
                  dashColor: MyColors.grey,
                  dashRadius: 0.0,
                  dashGapLength: 4.0,
                  dashGapColor: Colors.transparent,
                  dashGapRadius: 0.0,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(text: "Нийт үнэ:"),
                    CustomText(
                      text: convertToCurrencyFormat(order["totalAmount"]),
                      color: MyColors.black,
                    )
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
  }
}
