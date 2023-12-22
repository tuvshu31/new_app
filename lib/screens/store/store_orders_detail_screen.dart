import 'dart:developer';
import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class StoreOrdersDetailScreen extends StatefulWidget {
  final int id;
  final String orderId;
  const StoreOrdersDetailScreen({
    required this.id,
    required this.orderId,
    super.key,
  });

  @override
  State<StoreOrdersDetailScreen> createState() =>
      _StoreOrdersDetailScreenState();
}

class _StoreOrdersDetailScreenState extends State<StoreOrdersDetailScreen> {
  int orderId = 0;
  List products = [];
  String orderStatus = "";
  int pickedTime = 0;
  bool loading = false;

  final _storeCtx = Get.put(StoreController());

  @override
  void initState() {
    super.initState();
    orderId = widget.id;
    setState(() {});
    getStoreOrderDetails();
  }

  void getStoreOrderDetails() async {
    loading = true;
    dynamic getStoreOrderDetails =
        await StoreApi().getStoreOrderDetails(widget.id);
    loading = false;
    if (getStoreOrderDetails != null) {
      dynamic response = Map<String, dynamic>.from(getStoreOrderDetails);
      if (response["success"]) {
        products = response["data"];
        orderStatus = response["orderStatus"];
      }
    }
    setState(() {});
  }

  void updateOrderStatus(String orderStatus, {int prepDuration = 0}) async {
    var query = {
      "orderStatus": orderStatus,
      "prepDuration": orderStatus == "preparing" ? prepDuration : 0
    };
    query.removeWhere((key, value) => value == 0);
    dynamic updateOrderStatus =
        await StoreApi().updateOrderStatus(int.parse(widget.orderId), query);
    if (updateOrderStatus != null) {
      dynamic response = Map<String, dynamic>.from(updateOrderStatus);
      if (response["success"]) {
        int index = _storeCtx.orders.indexWhere((e) => e["id"] == orderId);
        _storeCtx.orders[index]["orderStatus"] = orderStatus;
      }
    }
  }

  void startPreparingOrder() async {
    CustomDialogs().showLoadingDialog();
    dynamic startPreparingOrder =
        await StoreApi().startPreparingOrder(orderId, pickedTime);
    Get.back();
    Get.back();
    Get.back();
    if (startPreparingOrder != null) {
      dynamic response = Map<String, dynamic>.from(startPreparingOrder);
      if (response["success"]) {
        _storeCtx.orders.clear();
        _storeCtx.tab.value = 0;
        _storeCtx.page.value = 1;
        _storeCtx.getStoreOrders();
      }
    }
  }

  void setToDelivery() async {
    CustomDialogs().showLoadingDialog();
    dynamic setToDelivery = await StoreApi().setToDelivery(orderId);
    Get.back();
    Get.back();
    if (setToDelivery != null) {
      dynamic response = Map<String, dynamic>.from(setToDelivery);
      if (response["success"]) {
        _storeCtx.orders.clear();
        _storeCtx.tab.value = 0;
        _storeCtx.page.value = 1;
        _storeCtx.getStoreOrders();
      }
    }
  }

  void showDurationPicker() {
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
        return StatefulBuilder(
          builder: (context, setState) {
            return WillPopScope(
              onWillPop: () async => true,
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
                      top: Get.height * .04,
                      bottom: Get.height * .03,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            IconlyBold.time_square,
                            size: Get.width * .15,
                            color: Colors.amber,
                          ),
                          SizedBox(height: Get.height * .02),
                          const Text(
                            "Бэлдэх хугацаа сонгох",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: Get.height * .02),
                          Column(
                            children: [
                              SizedBox(
                                height: Get.height * .3,
                                child: ListWheelScrollView.useDelegate(
                                  itemExtent: 50,
                                  perspective: 0.005,
                                  diameterRatio: 1.2,
                                  onSelectedItemChanged: (value) {
                                    pickedTime = value * 60;
                                    setState;
                                  },
                                  physics: const BouncingScrollPhysics(),
                                  useMagnifier: true,
                                  magnification: 1.3,
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    childCount: 60,
                                    builder: (context, index) {
                                      return Center(
                                          child: Text("$index' минут"));
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: Get.height * .04),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * .05),
                                child: Row(
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
                                        text: "Сонгох",
                                        onPressed: startPreparingOrder,
                                      ),
                                    ),
                                  ],
                                ),
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
      },
    );
  }

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
                        Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: products.length ?? 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                itemBuilder: (context, index) {
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
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text("x"),
                                                const SizedBox(width: 12),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red,
                                                  ),
                                                  child: Text(
                                                    "${item["quantity"]}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ));
                                },
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
            bottomSheet: _bottomSheet()),
      ),
    );
  }

  Widget _bottomSheet() {
    if (orderStatus == "sent") {
      return Container(
        width: Get.width,
        height: Get.height * .1,
        color: MyColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: CustomButton(
            isActive: !loading,
            onPressed: showDurationPicker,
            text: "Бэлдэж эхлэх",
            textColor: MyColors.white,
            elevation: 0,
          ),
        ),
      );
    } else if (orderStatus == "preparing") {
      return Container(
        width: Get.width,
        height: Get.height * .1,
        color: MyColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: CustomButton(
            isActive: !loading,
            onPressed: setToDelivery,
            text: "Хүргэлтэнд гаргах",
            textColor: MyColors.white,
            elevation: 0,
          ),
        ),
      );
    } else {
      return Container(
        width: Get.width,
        height: Get.height * .1,
        color: MyColors.white,
      );
    }
  }
}
