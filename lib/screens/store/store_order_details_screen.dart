import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/divider.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreOrdersDetailScreen extends StatefulWidget {
  Map item;
  StoreOrdersDetailScreen({
    required this.item,
    super.key,
  });

  @override
  State<StoreOrdersDetailScreen> createState() =>
      _StoreOrdersDetailScreenState();
}

class _StoreOrdersDetailScreenState extends State<StoreOrdersDetailScreen> {
  bool loading = false;
  List products = [];
  int initialDuration = 0;
  int prepDuration = 0;
  int pickedTime = 0;
  final _storeCtx = Get.put(StoreController());

  @override
  void initState() {
    super.initState();
    getStoreOrderDetails();
  }

  void getStoreOrderDetails() async {
    loading = true;
    dynamic getStoreOrderDetails =
        await StoreApi().getStoreOrderDetails(widget.item["id"]);
    loading = false;
    if (getStoreOrderDetails != null) {
      dynamic response = Map<String, dynamic>.from(getStoreOrderDetails);
      if (response["success"]) {
        products = response["data"];
      }
    }
    setState(() {});
  }

  String buttonTitle(String status) {
    if (status == "sent") {
      return "Бэлдэж эхлэх";
    } else if (status == "preparing") {
      return "Хүргэлтэнд гаргах";
    } else {
      return "";
    }
  }

  void onPressed(String status) {
    if (status == "sent") {
      Get.back();
      showStoreDurationPicker();
    } else if (status == "preparing") {
      Get.back();
      _storeCtx.setToDelivery(widget.item);
    }
  }

  Future<void> showStoreDurationPicker() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text(
                  "Бэлдэх хугацаагаа \n сонгоно уу",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  height: Get.height * .3,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 50,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    onSelectedItemChanged: (value) {
                      setState(() => pickedTime = value * 60);
                    },
                    physics: const BouncingScrollPhysics(),
                    useMagnifier: true,
                    magnification: 1.3,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 60,
                      builder: (context, index) {
                        return Center(child: Text("$index' минут"));
                      },
                    ),
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        isActive: pickedTime != 0,
                        isFullWidth: false,
                        text: "Сонгох",
                        bgColor: Colors.green,
                        elevation: 0,
                        height: 48,
                        cornerRadius: 8,
                        onPressed: () {
                          Get.back();
                          _storeCtx.startPreparingOrder(
                            widget.item,
                            pickedTime,
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: Get.width * .02),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _storeCtx.bottomSheetOpened.value = false;
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
                _storeCtx.bottomSheetOpened.value = false;
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
            body: loading
                ? listShimmerWidget()
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: Get.height * .03),
                        _productsInfo(),
                        divider(),
                        SizedBox(height: Get.height * .03),
                        _addressInfo(),
                        divider(),
                        SizedBox(height: Get.height * .1),
                      ],
                    ),
                  ),
            bottomSheet: widget.item["orderStatus"] == "sent" ||
                    widget.item["orderStatus"] == "preparing"
                ? Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: EdgeInsets.all(Get.width * .03),
                    child: CustomButton(
                      text: buttonTitle(widget.item["orderStatus"]),
                      onPressed: () {
                        onPressed(widget.item["orderStatus"]);
                      },
                    ),
                  )
                : Container(height: 0),
          ),
        ),
      ),
    );
  }

  Widget _productsInfo() {
    return Padding(
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
                      trailing: CustomText(text: "${item["quantity"]} ширхэг"),
                    ),
                  ));
            },
          ),
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
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Нийт тоо ширхэг:"),
              Text(convertToCurrencyFormat(widget.item["totalAmount"] ?? 0))
            ],
          ),
          SizedBox(height: Get.width * .03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Нийт үнэ:"),
              Text(convertToCurrencyFormat(widget.item["totalAmount"] ?? 0))
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Хүргэлтийн хаяг"),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Хаяг:",
                  style: TextStyle(
                    color: MyColors.gray,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.item["address"] ?? "N/a",
                  style: const TextStyle(
                    color: MyColors.gray,
                    overflow: TextOverflow.visible,
                  ),
                ),
              )
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
              Text(
                widget.item["phone"] ?? "N/a",
                style: const TextStyle(
                  color: MyColors.gray,
                ),
              )
            ],
          ),
          const SizedBox(height: 12)
        ]));
  }
}
