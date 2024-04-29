import 'dart:developer';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/controller/address_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/address.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:get/get.dart';

class UserCartAddressScreen extends StatefulWidget {
  const UserCartAddressScreen({super.key});

  @override
  State<UserCartAddressScreen> createState() => _UserCartAddressScreenState();
}

class _UserCartAddressScreenState extends State<UserCartAddressScreen> {
  bool showPriceDetails = false;
  bool loading = false;
  List location = [];
  List section = [];
  Map address = {};
  List priceDetals = [];
  int totalPrice = 0;
  int deliveryPrice = 0;
  final _arguments = Get.arguments;
  final _addressCtx = Get.put(AddressController());

  @override
  void initState() {
    super.initState();
    checkUserAddress();
  }

  void checkUserAddress() async {
    loading = true;
    dynamic checkUserAddress =
        await UserApi().checkUserAddress(_arguments["store"]);
    loading = false;
    if (checkUserAddress != null) {
      dynamic response = Map<String, dynamic>.from(checkUserAddress);
      if (response["success"]) {
        section = response["section"];
        location = response["location"];
        address = response["address"] ?? {};
      }
    }
    setState(() {});
  }

  Future<void> calculateDeliveryPrice() async {
    CustomDialogs().showLoadingDialog();
    var body = {
      "total": _arguments["total"],
      "storeId": _arguments["store"],
      "sectionId": _addressCtx.selectedSection["id"],
      "locationId": _addressCtx.selectedLocation["id"]
    };
    dynamic calculateDeliveryPrice =
        await UserApi().calculateDeliveryPrice(body);
    Get.back();
    if (calculateDeliveryPrice != null) {
      dynamic response = Map<String, dynamic>.from(calculateDeliveryPrice);
      if (response["success"]) {
        priceDetals = response["priceDetails"];
        totalPrice = response["totalPrice"];
        deliveryPrice = response["deliveryPrice"];
      }
    }
    setState(() {});
  }

  void createNewOrder() async {
    CustomDialogs().showLoadingDialog();
    var body = {
      "section": _addressCtx.selectedSection["name"] ?? "",
      "location": _addressCtx.selectedLocation["name"] ?? "",
      "deliveryPrice": deliveryPrice,
      "address": _addressCtx.addressController.value.text,
      "phone": _addressCtx.phoneController.value.text,
      "kod": _addressCtx.entranceController.value.text,
      "total": totalPrice,
    };
    Get.back();
    dynamic createNewOrder = await UserApi().createNewOrder(body);
    if (createNewOrder != null) {
      dynamic response = Map<String, dynamic>.from(createNewOrder);
      if (response["success"]) {
        if (response["error"] == "") {
          var orderId = response["data"];
          Get.toNamed(userPaymentScreenRoute, arguments: {
            "orderId": orderId,
            "amount": totalPrice,
          });
        } else {
          customSnackbar(ActionType.error, response["error"], 5);
        }
      } else {
        customSnackbar(ActionType.error,
            "Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу", 2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomHeader(
        customActions: Container(),
        title: "Захиалгын мэдээлэл",
        body: loading
            ? addressShimmer()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAddressWidget(
                        address: address,
                        location: location,
                        section: section,
                        onpressed: () {
                          calculateDeliveryPrice();
                        },
                      ),
                      priceDetailsWidget(),
                    ],
                  ),
                ),
              ),
        bottomSheet: Container(
          width: Get.width,
          height: Get.height * .1,
          color: MyColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: CustomButton(
              isActive: _addressCtx.isLocationOk.value &&
                  _addressCtx.isPhoneOk.value &&
                  _addressCtx.isAddressOk.value,
              onPressed: () {
                if (!showPriceDetails) {
                  FocusScope.of(context).unfocus();
                  CustomDialogs().showLoadingDialog();
                  Future.delayed(const Duration(seconds: 1), () {
                    Get.back();
                    showPriceDetails = true;
                    setState(() {});
                  });
                } else {
                  createNewOrder();
                }
              },
              text: showPriceDetails ? "Төлбөр төлөх" : "Үргэлжлүүлэх",
              textColor: MyColors.white,
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget priceDetailsWidget() {
    return showPriceDetails
        ? Animate(
            effects: const [SlideEffect(duration: Duration(milliseconds: 900))],
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: priceDetals.length,
                  itemBuilder: (context, index) {
                    var item = priceDetals[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: item["name"],
                            color: MyColors.gray,
                          ),
                          CustomText(
                            text: convertToCurrencyFormat(
                              item["price"],
                            ),
                            color: MyColors.gray,
                          )
                        ],
                      ),
                    );
                  },
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
                    const CustomText(
                      text: "Нийт үнэ",
                      color: MyColors.gray,
                    ),
                    CustomText(
                      text: convertToCurrencyFormat(
                        totalPrice,
                      ),
                      color: MyColors.gray,
                    )
                  ],
                ),
              ],
            ),
          )
        : Container();
  }
}
