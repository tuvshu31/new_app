import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/controller/user_controller.dart';
import 'package:Erdenet24/screens/user/user_order_map_screen.dart';
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

class UserOrdersDetailScreen extends StatefulWidget {
  Map item;
  UserOrdersDetailScreen({
    required this.item,
    super.key,
  });

  @override
  State<UserOrdersDetailScreen> createState() => _UserOrdersDetailScreenState();
}

class _UserOrdersDetailScreenState extends State<UserOrdersDetailScreen> {
  bool loading = false;
  List products = [];
  int initialDuration = 0;
  int prepDuration = 0;

  final _userCtx = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    getUserOrderDetails();
  }

  void getUserOrderDetails() async {
    loading = true;
    dynamic getUserOrderDetails =
        await UserApi().getUserOrderDetails(widget.item["id"]);
    loading = false;
    if (getUserOrderDetails != null) {
      dynamic response = Map<String, dynamic>.from(getUserOrderDetails);
      if (response["success"]) {
        products = response["data"];
        initialDuration = response["initialDuration"];
        prepDuration = response["prepDuration"];
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _userCtx.bottomSheetOpened.value = false;
        return true;
      },
      child: MediaQuery(
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
        child: SafeArea(
          child: CustomHeader(
            centerTitle: true,
            customLeading: Container(),
            customActions: CustomInkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: () {
                Get.back();
                _userCtx.bottomSheetOpened.value = false;
              },
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
              widget.item["orderId"],
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
      ),
    );
  }

  Widget _stepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          orderStatusLine(widget.item["orderStatus"]),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text("Баталгаажсан"),
              _text("Бэлдэж байна"),
              _text("Хүргэж байна"),
              _text("Хүргэсэн"),
            ],
          )
        ],
      ),
    );
  }

  Widget _text(String text) {
    return Text(
      text,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                handleOrderStatusIcon(widget.item["orderStatus"]),
                color: Colors.red,
              ),
              const SizedBox(width: 12),
              Text(handleOrderStatusText(widget.item["orderStatus"]))
            ],
          ),
          widget.item["orderStatus"] == "preparing"
              ? CircularCountDownTimer(
                  width: Get.height * .07,
                  height: Get.height * .07,
                  duration: prepDuration,
                  initialDuration: initialDuration,
                  fillColor: MyColors.background,
                  isReverse: true,
                  ringColor: Colors.red,
                )
              : Text(
                  widget.item["updatedTime"],
                  style: const TextStyle(
                    color: MyColors.gray,
                    fontSize: 12,
                  ),
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
                text: widget.item["address"] ?? "N/a",
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
                text: widget.item["phone"] ?? "N/a",
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
                text: "Захиалгаа авах код:",
                color: MyColors.gray,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(12)),
                child: CustomText(
                  text: "${widget.item["code"] ?? "n/a"}",
                  color: MyColors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _productsInfoAndMap() {
    return widget.item["orderStatus"] == "delivering"
        ? UserOrderMapScreen(orderId: widget.item["id"])
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
                  itemCount: products.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, index) {
                    // var product = _userCtx.selectedOrder["products"][index];
                    var item = products[index];
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
                      text: convertToCurrencyFormat(
                          widget.item["productsTotal"] ?? 0),
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
                          widget.item["deliveryPrice"] ?? 0),
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
                          widget.item["totalAmount"] ?? 0),
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
