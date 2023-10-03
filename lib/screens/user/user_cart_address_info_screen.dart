import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
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
  Map _userInfo = {};
  bool showPriceDetails = false;
  bool loading = false;
  String phoneErrorText = "";
  String locationErrorText = "";
  String address1 = "";
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController kod = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  List locationList = [];
  Map selectedLocation = {};
  final _loginCtx = Get.put(LoginController());

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
    loading = true;
    dynamic res1 = await RestApi().getAllLocations();
    dynamic response = Map<String, dynamic>.from(res1);
    if (response["success"]) {
      locationList = response["data"];
    }
    dynamic res = await RestApi().getUser(RestApiHelper.getUserId());
    dynamic info = Map<String, dynamic>.from(res);
    if (info["success"]) {
      _userInfo = info["data"];
      address1 = _userInfo["userAddress1"] ?? "";
      selectedLocation =
          locationList.firstWhere((element) => element["name"] == address1);
      isLocationOk = address1.isNotEmpty;
      address.text = _userInfo["userAddress"] ?? "";
      isAddressOk = address.text.isNotEmpty;
      phone.text =
          _userInfo["userPhone"] == 0 ? "" : _userInfo["userPhone"].toString();
      isPhoneOk = phone.text.isNotEmpty;
      kod.text = _userInfo["userEntranceCode"] ?? "";
    }
    loading = false;
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
      "address": "${selectedLocation["name"]} - ${address.text}",
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
        // "amount": _cartCtx.total,
        "amount": 50,
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
          _loginCtx.saveUserToken();
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
        body: !loading
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
                    CustomInkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: MyColors.white,
                          context: Get.context!,
                          isScrollControlled: true,
                          builder: (context) {
                            return _addressPickerBody();
                          },
                        );
                      },
                      child: Container(
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
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              address1 != ""
                                  ? address1
                                  : selectedLocation["name"] ??
                                      "Байршил сонгох",
                              style: TextStyle(
                                color: selectedLocation.isNotEmpty ||
                                        address1 != ""
                                    ? MyColors.black
                                    : MyColors.grey,
                              ),
                            ),
                            const Icon(IconlyLight.arrow_down_2)
                          ],
                        )),
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
                    Column(
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

  Widget _addressPickerBody() {
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
      child: SafeArea(
          child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Байршил сонгох",
                    style: TextStyle(fontSize: 16),
                  ),
                  CustomInkWell(
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
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Container(
                  height: 0.4,
                  width: double.infinity,
                  color: MyColors.grey,
                ),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: locationList.length,
                itemBuilder: (context, index) {
                  var item = locationList[index];
                  return CustomInkWell(
                    onTap: () {
                      selectedLocation = item;
                      address1 = item["name"];
                      address.clear();
                      isAddressOk = false;
                      isApartment = selectedLocation["apartment"] == 1;
                      _cartCtx.deliveryPrice.value = selectedLocation["price"];
                      isLocationOk = true;
                      setState(() {});
                      Get.back();
                    },
                    borderRadius: BorderRadius.circular(0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: Get.width * .04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: item["name"]),
                          const Icon(
                            IconlyLight.arrow_right_2,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
