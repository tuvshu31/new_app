import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/cart_controller.dart';
import 'package:Erdenet24/controller/navigation_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/shimmers.dart';
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
  final _navCtrl = Get.put(NavigationController());
  bool isPhoneOk = false;
  bool isAddressOk = false;
  dynamic _user = [];
  bool showPriceDetails = false;
  String phoneErrorText = "";
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController kod = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();

  @override
  void initState() {
    super.initState();
    getUserInfo();
    detectFocus();
  }

  void detectFocus() {
    focusNode1.addListener(() {
      if (focusNode1.hasFocus) {
        showPriceDetails = false;
      }
    });
    focusNode2.addListener(() {
      if (focusNode2.hasFocus) {
        showPriceDetails = false;
      }
    });
    focusNode3.addListener(() {
      if (focusNode3.hasFocus) {
        showPriceDetails = false;
      }
    });
    setState(() {});
  }

  void getUserInfo() async {
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

  void createInvoiceAndOrder() async {
    CustomDialogs().showLoadingDialog();
    int storeId = int.parse(_cartCtx.stores[0]);
    int randomNumber = random4digit();
    int userAndDriverCode = random4digit();
    var orderId = int.parse(("$storeId" "$randomNumber"));
    var qpayBody = {
      "sender_invoice_no": orderId.toString(),
      // "amount": _cartCtx.total,
      "amount": 50,
    };
    dynamic qpayResponse = await RestApi().qpayPayment(qpayBody);
    dynamic qpayData = Map<String, dynamic>.from(qpayResponse);
    if (qpayData["success"]) {
      var orderBody = {
        "orderId": orderId,
        "userAndDriverCode": userAndDriverCode,
        "userId": RestApiHelper.getUserId(),
        "storeId1": _cartCtx.stores.isNotEmpty ? _cartCtx.stores[0] : null,
        "address": address.text,
        "orderStatus": "notPaid",
        "totalAmount": _cartCtx.total,
        "storeTotalAmount": _cartCtx.subTotal.toString(),
        "orderTime": DateFormat('yyyy-MM-dd kk:mm:ss').format(DateTime.now()),
        "phone": phone.text,
        "kod": kod.text,
        "products": _cartCtx.cartList,
      };
      dynamic orderResponse = await RestApi().createOrder(orderBody);
      dynamic orderData = Map<String, dynamic>.from(orderResponse);

      if (orderData["success"]) {
        Get.back();
        Get.offAndToNamed(
          userOrderPaymentScreenRoute,
          arguments: {
            "data": jsonDecode(qpayData["data"]),
          },
        );
      }
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
              isActive: isPhoneOk && isAddressOk,
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
                  createInvoiceAndOrder();
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
                      text: "Утасны дугаар",
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
                    _errorText(),
                    const SizedBox(height: 12),
                    const CustomText(
                      text: "Хүргүүлэх хаяг",
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
                    const SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          IconlyLight.info_circle,
                          color: MyColors.grey,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Flexible(
                          child: CustomText(
                              fontSize: 12,
                              textAlign: TextAlign.justify,
                              color: MyColors.gray,
                              text:
                                  "Хүргэлт хүлээн авах мэдээллээ дэлгэрэнгүй оруулна уу. Хүргэлтийн мэдээллийг буруу оруулсан тохиолдолд хүргэлтийн төлбөр нэмэгдэж тооцогдохыг анхаарна уу"),
                        ),
                      ],
                    ),
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

  Widget _errorText() {
    return phoneErrorText.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Text(
              phoneErrorText,
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
                            _cartCtx.deliveryCost,
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
                            _cartCtx.total,
                            toInt: true,
                            locatedAtTheEnd: true,
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
