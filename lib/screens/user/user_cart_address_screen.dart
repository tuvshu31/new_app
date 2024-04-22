import 'dart:developer';

import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

class UserCartAddressScreen extends StatefulWidget {
  const UserCartAddressScreen({super.key});

  @override
  State<UserCartAddressScreen> createState() => _UserCartAddressScreenState();
}

class _UserCartAddressScreenState extends State<UserCartAddressScreen> {
  bool isPhoneOk = false;
  bool isAddressOk = false;
  bool isLocationOk = false;
  bool isSectionOk = false;
  bool isApartment = false;
  bool showPriceDetails = false;
  bool loading = false;
  String phoneErrorText = "";
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  TextEditingController kod = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController addressCTRL = TextEditingController();
  List location = [];
  List section = [];
  List address = [];
  List priceList = [];
  List filteredLocation = [];
  Map selectedLocation = {};
  Map selectedSection = {};
  int deliveryPrice = 0;
  int totalPrice = 0;
  final _arguments = Get.arguments;

  @override
  void initState() {
    super.initState();
    // getLocationList();
    checkUserAddress();
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

  void checkUserAddress() async {
    loading = true;
    dynamic checkUserAddress =
        await UserApi().checkUserAddress(_arguments["store"]);
    loading = false;
    if (checkUserAddress != null) {
      dynamic response = Map<String, dynamic>.from(checkUserAddress);
      if (response["success"]) {
        List userAddress = response["address"] ?? [];
        List userSection = response["section"] ?? [];
        List userLocation = response["location"] ?? [];
        section = userSection;
        location = userLocation;
        filteredLocation = location;
      }
    }
    setState(() {});
  }

  Future<void> calculateDeliveryPrice() async {
    CustomDialogs().showLoadingDialog();
    var body = {
      "storeId": _arguments["store"],
      "sectionId": selectedSection["id"],
      "locationId": selectedLocation["id"]
    };
    dynamic calculateDeliveryPrice =
        await UserApi().calculateDeliveryPrice(body);
    Get.back();
    if (calculateDeliveryPrice != null) {
      dynamic response = Map<String, dynamic>.from(calculateDeliveryPrice);
      if (response["success"]) {
        totalPrice = 0;
        deliveryPrice = 0;
        priceList = response["price"];
        deliveryPrice = response["deliveryPrice"];
        for (var i = 0; i < priceList.length; i++) {
          Map element = priceList[i];
          int price = element["price"];
          totalPrice += price;
        }
        int productPrice = _arguments["total"];
        totalPrice += productPrice;
        priceList.insert(0, {"name": "Барааны үнэ", "price": productPrice});
        priceList.add({"name": "Нийт үнэ", "price": totalPrice});
      }
    }
    setState(() {});
  }

  // void getUserAddress() async {
  //   CustomDialogs().showLoadingDialog();
  //   dynamic getUserAddress = await UserApi().getUserAddress();
  //   Get.back();
  //   dynamic response = Map<String, dynamic>.from(getUserAddress);
  //   if (response["success"]) {
  //     Map userAddress = response["address"];
  //     if (userAddress["district"] != "") {
  //       selectedLocation =
  //           locations.firstWhere((a) => a["name"] == userAddress["district"]);
  //       deliveryPrice = selectedLocation["price"];
  //       totalPrice = deliveryPrice + cartTotalPrice;
  //       isLocationOk = true;
  //     }
  //     if (userAddress["address"] != "") {
  //       addressCTRL.text = userAddress["address"];
  //       isAddressOk = true;
  //     }
  //     if (userAddress["phone"] != "") {
  //       phone.text = userAddress["phone"];
  //       isPhoneOk = true;
  //     }
  //     if (userAddress["code"] != "") {
  //       kod.text = userAddress["code"];
  //     }
  //   }
  //   setState(() {});
  // }

  void saveUserAddress() async {
    CustomDialogs().showLoadingDialog();
    var body = {
      "sectionId": selectedSection["id"],
      "locationId": selectedLocation["id"],
      "address": addressCTRL.text,
      "phone": phone.text,
      "entrance": kod.text,
    };
    dynamic saveUserAddress = await UserApi().saveUserAddress(body);
    Get.back();
    if (saveUserAddress != null) {
      dynamic response = Map<String, dynamic>.from(saveUserAddress);
      if (response["success"]) {
        log(response.toString());
      }
    }
    setState(() {});
  }

  void showUserAddressSaveDialog() {
    Get.bottomSheet(
        backgroundColor: MyColors.white,
        isDismissible: false,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        )), StatefulBuilder(
      builder: ((context, setState) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber,
                ),
                child: const Icon(
                  IconlyBold.bookmark,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Get.height * .03),
              const Text(
                "Хүргэлтийн хаягаа хадгалах уу?",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: Get.height * .03 + 12),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      bgColor: Colors.white,
                      text: "Үгүй",
                      textColor: MyColors.black,
                      onPressed: Get.back,
                      hasBorder: true,
                      borderColor: Colors.grey,
                      elevation: 0,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomButton(
                      bgColor: Colors.amber,
                      text: "Тийм",
                      onPressed: () {
                        saveUserAddress();
                        // Get.back();
                        // createNewOrder();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    ));
  }

  void createNewOrder() async {
    CustomDialogs().showLoadingDialog();
    var body = {
      "section": selectedSection["name"],
      "location": selectedLocation["name"],
      "deliveryPrice": deliveryPrice,
      "address": addressCTRL.text,
      "phone": phone.text,
      "kod": kod.text,
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
    return CustomHeader(
      customActions: Container(),
      title: "Захиалгын мэдээлэл",
      bottomSheet: _bottomSheet(),
      body: loading
          ? _shimmer()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    section.length > 1
                        ? Column(
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
                                  Get.bottomSheet(
                                    _locationListBody("Байршил сонгох", section,
                                        (item) {
                                      selectedSection = item;
                                      selectedLocation.clear();
                                      isSectionOk = true;
                                      filteredLocation = location
                                          .where((el) =>
                                              el["sectionId"] ==
                                              selectedSection["id"])
                                          .toList();
                                      setState(() {});
                                      Get.back();
                                    }),
                                    ignoreSafeArea: false,
                                    backgroundColor: MyColors.white,
                                    isScrollControlled: true,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  height: 42,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: MyColors.background,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(selectedSection.isNotEmpty
                                          ? selectedSection["name"]
                                          : "Сонгох"),
                                      const Icon(IconlyLight.arrow_down_2)
                                    ],
                                  )),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          )
                        : Container(),
                    const CustomText(
                      text: "Хаяг",
                      color: MyColors.gray,
                    ),
                    const SizedBox(height: 12),
                    CustomInkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        Get.bottomSheet(
                          _locationListBody("Хаяг сонгох", filteredLocation,
                              (item) {
                            selectedLocation = item;
                            isLocationOk = true;
                            Get.back();
                            calculateDeliveryPrice();
                            setState(() {});
                          }),
                          ignoreSafeArea: false,
                          backgroundColor: MyColors.white,
                          isScrollControlled: true,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: MyColors.background,
                            width: 1,
                          ),
                        ),
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(selectedLocation.isNotEmpty
                                  ? selectedLocation["name"]
                                  : "Сонгох"),
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
                      hintText: "Жишээ нь: 3-24-р байр, 9 давхарт 1165 тоот",
                      controller: addressCTRL,
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
                    showPriceDetails
                        ? Animate(
                            effects: const [
                              SlideEffect(duration: Duration(milliseconds: 900))
                            ],
                            child: Column(
                              children: [
                                SizedBox(height: Get.height * .1),
                                ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    if (index == priceList.length - 2) {
                                      return Column(
                                        children: const [
                                          SizedBox(height: 12),
                                          DottedLine(
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
                                          SizedBox(height: 12)
                                        ],
                                      );
                                    } else {
                                      return const SizedBox(height: 12);
                                    }
                                  },
                                  itemCount: priceList.length,
                                  itemBuilder: (context, index) {
                                    var item = priceList[index];
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(height: Get.height * .15)
                  ],
                ),
              ),
            ),
    );
  }

  Widget _bottomSheet() {
    return Container(
      width: Get.width,
      height: Get.height * .1,
      color: MyColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              createNewOrder();
              // if (address.isEmpty) {
              //   showUserAddressSaveDialog();
              // } else {
              //   createNewOrder();
              // }
            }
          },
          text: showPriceDetails ? "Төлбөр төлөх" : "Үргэлжлүүлэх",
          textColor: MyColors.white,
          elevation: 0,
        ),
      ),
    );
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Байршил",
            style: TextStyle(color: MyColors.gray),
          ),
          const SizedBox(height: 12),
          CustomShimmer(
            width: Get.width,
            height: 42,
            borderRadius: 25,
          ),
          const SizedBox(height: 12),
          const Text(
            "Дэлгэрэнгүй хаяг",
            style: TextStyle(color: MyColors.gray),
          ),
          const SizedBox(height: 12),
          CustomShimmer(
            width: Get.width,
            height: 42,
            borderRadius: 25,
          ),
          const SizedBox(height: 12),
          const Text(
            "Утас",
            style: TextStyle(color: MyColors.gray),
          ),
          const SizedBox(height: 12),
          CustomShimmer(
            width: Get.width,
            height: 42,
            borderRadius: 25,
          ),
          const SizedBox(height: 12),
          const Text(
            "Орцны код",
            style: TextStyle(color: MyColors.gray),
          ),
          const SizedBox(height: 12),
          CustomShimmer(
            width: Get.width,
            height: 42,
            borderRadius: 25,
          ),
        ],
      ),
    );
  }

  Widget _locationListBody(String title, List list, dynamic onpressed) {
    return CustomHeader(
        customActions: CustomInkWell(
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
        leadingWidth: 20,
        centerTitle: true,
        customTitle: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        customLeading: Container(),
        body: list.isEmpty
            ? listShimmerWidget()
            : ListView.separated(
                separatorBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    width: double.infinity,
                    height: Get.height * .008,
                    decoration: BoxDecoration(color: MyColors.fadedGrey),
                  );
                },
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  var item = list[index];
                  return CustomInkWell(
                    onTap: () => onpressed(item),
                    borderRadius: BorderRadius.circular(0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: Get.width * .04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item["name"],
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            IconlyLight.arrow_right_2,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  );
                },
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
}
