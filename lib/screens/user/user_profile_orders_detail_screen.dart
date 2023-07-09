import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/screens/user/user_product_detail_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class UserProfileOrdersDetailScreen extends StatefulWidget {
  final dynamic data;
  const UserProfileOrdersDetailScreen({
    super.key,
    this.data,
  });

  @override
  State<UserProfileOrdersDetailScreen> createState() =>
      _UserProfileOrdersDetailScreenState();
}

class _UserProfileOrdersDetailScreenState
    extends State<UserProfileOrdersDetailScreen> {
  int currentStep = 1;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  final _userCtx = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      centerTitle: true,
      customLeading: Container(),
      customActions: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(
          Icons.close_rounded,
          color: Colors.black,
        ),
      ),
      title: "Захиалга",
      subtitle: Text(
        "#${widget.data["orderId"] ?? "00000"}",
        style: const TextStyle(
          color: MyColors.gray,
          fontSize: 12,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            _stepper(currentStep),
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
    );
  }

  IconData statusIcon(int step) {
    return step == 1
        ? IconlyLight.bookmark
        : step == 2
            ? IconlyLight.time_circle
            : step == 3
                ? Icons.delivery_dining
                : step == 4
                    ? IconlyLight.shield_done
                    : IconlyLight.bookmark;
  }

  Widget _statusInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                statusIcon(currentStep),
                color: MyColors.primary,
              ),
              const SizedBox(width: 12),
              CustomText(
                text:
                    "Захиалгыг ${_userCtx.statusText(currentStep).toLowerCase()}",
                fontSize: 12,
                color: MyColors.primary,
              ),
            ],
          ),
          CustomText(
            text: dateFormat.format(DateTime.now()),
            color: MyColors.gray,
            fontSize: 10,
          )
        ],
      ),
    );
  }

  Widget _stepper(int step) {
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
            children: const [
              Text(
                "Хүлээн \n авсан",
                style: TextStyle(fontSize: 10),
              ),
              Text(
                "Бэлдэж \n байна",
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
              Text(
                "Хүргэж \n байна",
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
              Text(
                "Хүргэсэн",
                style: TextStyle(fontSize: 10),
                textAlign: TextAlign.center,
              ),
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

  Widget _divider() {
    return Container(
      height: 7,
      color: MyColors.fadedGrey,
    );
  }

  Widget _productsInfoAndMap() {
    return currentStep == 3
        ? SizedBox(
            height: Get.height * .6,
            child: GoogleMap(
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
                  itemCount: widget.data["products"].length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    var product = widget.data["products"][index];
                    return Container(
                        height: Get.height * .09,
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
                                      "${URL.AWS}/products/${product["id"]}/small/1.png"),
                            ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      text: "Барааны үнэ:",
                      color: MyColors.gray,
                    ),
                    CustomText(
                      text: convertToCurrencyFormat(
                        double.parse(widget.data["storeTotalAmount"] ?? "0"),
                        toInt: true,
                        locatedAtTheEnd: true,
                      ),
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
                      text: convertToCurrencyFormat(
                        int.parse(widget.data["deliveryPrice"] ?? "0"),
                        toInt: true,
                        locatedAtTheEnd: true,
                      ),
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
                      text: convertToCurrencyFormat(
                        int.parse(widget.data["totalAmount"] ?? "0"),
                        toInt: true,
                        locatedAtTheEnd: true,
                      ),
                      color: MyColors.black,
                    )
                  ],
                ),
                const SizedBox(height: 12),
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
                text: widget.data["address"] ?? "",
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
                text: widget.data["phone"] ?? "",
                color: MyColors.gray,
                fontSize: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
