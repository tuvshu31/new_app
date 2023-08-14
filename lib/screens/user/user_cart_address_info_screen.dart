import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class UserCartAddressInfoScreen extends StatefulWidget {
  const UserCartAddressInfoScreen({super.key});

  @override
  State<UserCartAddressInfoScreen> createState() =>
      _UserCartAddressInfoScreenState();
}

class _UserCartAddressInfoScreenState extends State<UserCartAddressInfoScreen> {
  final _cartCtx = Get.put(CartController());
  bool isPhoneOk = false;
  bool isAddressOk = false;
  bool isLocationOk = false;
  bool isApartment = false;
  dynamic _user = [];
  bool showPriceDetails = false;
  String phoneErrorText = "";
  String locationErrorText = "";
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController kod = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  List locationList = [];
  Map selectedLocation = {};

  @override
  void initState() {
    super.initState();
    getUserInfo();
    detectFocus();
  }

  void removeFocus(FocusNode focusNode) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showPriceDetails = false;
      }
    });
    setState(() {});
  }

  void detectFocus() {
    removeFocus(focusNode1);
    removeFocus(focusNode2);
    removeFocus(focusNode3);
    removeFocus(focusNode4);
  }

  void getUserInfo() async {
    dynamic locations = await RestApi().getLocations();
    if (locations != null) {
      dynamic locationsResponse = Map<String, dynamic>.from(locations);
      locationList = locationsResponse["locations"];
      setState(() {});
    }

    var query = {"id": RestApiHelper.getUserId()};
    dynamic res = await RestApi().getUsers(query);
    dynamic data = Map<String, dynamic>.from(res);
    _user = data["data"][0];
    if (_user["userPhone"] != null && _user["userPhone"] != 0) {
      phone.text = _user["userPhone"].toString();
    }
    if (_user["userAddress"] != null && _user["userAddress"].isNotEmpty) {
      address.text = _user["userAddress"];
    }
    if (_user["userEntranceCode"] != null &&
        _user["userEntranceCode"].isNotEmpty) {
      kod.text = _user["userEntranceCode"];
    }
    isPhoneOk = phone.text.isNotEmpty;
    isAddressOk = address.text.isNotEmpty;
    setState(() {});
  }

  int orderIdGenerator(int storeId) {
    String currentDate = DateFormat('dd-MM').format(DateTime.now());
    String date = currentDate.replaceAll("-", "");
    int randomDigit = random6digit();
    String orderString = "$storeId$randomDigit";
    int orderId = int.parse(orderString);
    return orderId;
  }

  void createOrderAndInvoice() async {
    CustomDialogs().showLoadingDialog();
    //create order
    int storeId = int.parse(_cartCtx.cartList[0]["store"]);
    int orderId = orderIdGenerator(storeId);
    var orderBody = {
      "orderId": orderId,
      "userAndDriverCode": random4digit(),
      "userId": RestApiHelper.getUserId(),
      "storeId1": storeId,
      "address": "${selectedLocation["locationName"]} - ${address.text}",
      "orderStatus": "notPaid",
      "totalAmount": _cartCtx.total,
      "storeTotalAmount": _cartCtx.subTotal.toString(),
      "orderTime": DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()),
      "phone": phone.text,
      "kod": kod.text,
      "products": _cartCtx.cartList,
      "deliveryPrice": _cartCtx.deliveryPrice.value,
    };
    dynamic orderResponse = await RestApi().createOrder(orderBody);
    if (orderResponse != null) {
      var id = orderResponse["data"]["id"];
      //create invoice
      var qpayBody = {
        "sender_invoice_no": id.toString(),
        "amount": _cartCtx.total,
        // "amount": 50,
      };
      dynamic qpayResponse = await RestApi().qpayPayment(qpayBody);
      Get.back();
      if (qpayResponse != null) {
        dynamic qpayData = Map<String, dynamic>.from(qpayResponse);
        if (qpayData["success"]) {
          Get.offAndToNamed(
            userOrderPaymentScreenRoute,
            arguments: {
              "data": jsonDecode(qpayData["data"]),
            },
          );
        }
      } else {
        customSnackbar(DialogType.error,
            "Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу", 2);
      }
    } else {
      Get.back();
      customSnackbar(
          DialogType.error, "Алдаа гарлаа, түр хүлээгээд дахин оролдоно уу", 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
        customActions: Container(),
        title: "Захиалгын мэдээлэл",
        bottomSheet: Container(
          width: Get.width,
          height: Get.height * .09,
          color: MyColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: CustomButton(
              isActive: isPhoneOk && isAddressOk && isLocationOk,
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
                  createOrderAndInvoice();
                }
              },
              text: showPriceDetails ? "Төлбөр төлөх" : "Үргэлжлүүлэх",
              textColor: MyColors.white,
              elevation: 0,
            ),
          ),
        ),
        body: _user.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: "Байршил",
                      color: MyColors.gray,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: MyColors.grey,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: DropdownButton(
                            value: selectedLocation["locationName"],
                            focusNode: focusNode4,
                            icon: const Icon(IconlyLight.arrow_down_2),
                            isDense: true,
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(12),
                            hint: const CustomText(
                              text: "Байршил сонгох",
                              color: MyColors.gray,
                              fontSize: 14,
                            ),
                            underline: Container(),
                            items: locationList.map((e) {
                              String value = e["locationName"];
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (val) {
                              selectedLocation = locationList.firstWhere(
                                  (element) => element["locationName"] == val);
                              address.clear();
                              isAddressOk = false;
                              isApartment = selectedLocation["isApartment"];
                              _cartCtx.deliveryPrice.value =
                                  selectedLocation["deliveryPrice"];
                              isLocationOk = true;
                              setState(() {});
                            }),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const CustomText(
                      text: "Дэлгэрэнгүй хаяг",
                      color: MyColors.gray,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      focusNode: focusNode2,
                      hintText: "3-24-р байр, 9 давхарт 1165 тоот",
                      controller: address,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                      onChanged: (val) {
                        setState(() {
                          isAddressOk = val.isNotEmpty;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    const CustomText(
                      text: "Утас",
                      color: MyColors.gray,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      focusNode: focusNode1,
                      hintText: "9935*****",
                      errorText: phoneErrorText,
                      controller: phone,
                      maxLength: 8,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                      onChanged: (val) {
                        if (val.isEmpty) {
                          phoneErrorText = "";
                          isPhoneOk = false;
                        } else if (val.length < 8) {
                          phoneErrorText = "Утасны дугаар буруу байна";
                          isPhoneOk = false;
                        } else {
                          phoneErrorText = "";
                          isPhoneOk = true;
                        }
                        setState(() {});
                      },
                    ),
                    _errorText(phoneErrorText),
                    isApartment
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 12),
                              Row(
                                children: const [
                                  CustomText(
                                    text: "Орцны код",
                                    color: MyColors.gray,
                                  ),
                                  CustomText(
                                    text: " /Заавал биш/",
                                    fontSize: 12,
                                    color: MyColors.gray,
                                  )
                                ],
                              ),
                              const SizedBox(height: 12),
                              CustomTextField(
                                focusNode: focusNode3,
                                hintText: "#1234",
                                controller: kod,
                                textInputAction: TextInputAction.done,
                              ),
                            ],
                          )
                        : Container(),
                    _priceDetails()
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmer(
                      width: Get.width * .3,
                      height: 16,
                      borderRadius: 12,
                    ),
                    const SizedBox(height: 12),
                    CustomShimmer(
                      width: Get.width,
                      height: 42,
                      borderRadius: 25,
                    ),
                    const SizedBox(height: 12),
                    CustomShimmer(
                      width: Get.width * .3,
                      height: 16,
                      borderRadius: 12,
                    ),
                    const SizedBox(height: 12),
                    CustomShimmer(
                      width: Get.width,
                      height: 42,
                      borderRadius: 25,
                    ),
                    const SizedBox(height: 12),
                    CustomShimmer(
                      width: Get.width * .4,
                      height: 16,
                      borderRadius: 12,
                    ),
                    const SizedBox(height: 12),
                    CustomShimmer(
                      width: Get.width,
                      height: 42,
                      borderRadius: 25,
                    ),
                  ],
                ),
              ));
  }

  Widget _errorText(String text) {
    return text.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 10,
              ),
            ),
          );
  }

  Widget _priceDetails() {
    return showPriceDetails
        ? Expanded(
            child: Animate(
              effects: const [
                SlideEffect(duration: Duration(milliseconds: 900))
              ],
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomText(
                          text: "Барааны үнэ:",
                          color: MyColors.gray,
                        ),
                        CustomText(
                          text: convertToCurrencyFormat(
                            _cartCtx.subTotal,
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
                            _cartCtx.deliveryCost,
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
                            _cartCtx.total,
                          ),
                          color: MyColors.black,
                        )
                      ],
                    ),
                    SizedBox(height: Get.height * .1),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }
}
