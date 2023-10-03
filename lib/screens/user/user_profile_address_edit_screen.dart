import 'dart:developer';

import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:iconly/iconly.dart';

class UserProfileAddressEditScreen extends StatefulWidget {
  const UserProfileAddressEditScreen({super.key});

  @override
  State<UserProfileAddressEditScreen> createState() =>
      _UserProfileAddressEditScreenState();
}

class _UserProfileAddressEditScreenState
    extends State<UserProfileAddressEditScreen> {
  Map selectedLocation = {};
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  bool isEdited = false;
  bool isPhoneOk = false;
  bool isAddressOk = false;
  bool isLocationOk = false;
  bool isApartment = false;
  Map _userInfo = {};
  bool loading = false;
  String phoneErrorText = "";
  String locationErrorText = "";
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController kod = TextEditingController();
  String address1 = "";
  List locationList = [];

  @override
  void initState() {
    super.initState();
    getUserInfo();
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

  void saveUserAddress() async {
    CustomDialogs().showLoadingDialog();
    var body = {
      "userAddress1": address1,
      "userPhone": phone.text,
      "userAddress": address.text,
      "userEntranceCode": kod.text,
    };
    dynamic res = await RestApi().updateUser(RestApiHelper.getUserId(), body);
    dynamic response = Map<String, dynamic>.from(res);
    Get.back();
    Get.back();
    if (response["success"]) {
      customSnackbar(DialogType.success, "Амжилттай хадгалагдлаа", 3);
    } else {
      customSnackbar(
          DialogType.error, "Алдаа гарлаа түр хүлээгээд дахин оролдоно уу", 2);
    }
  }

  void removeFocus(FocusNode focusNode) {
    focusNode.addListener(() {});
    setState(() {});
  }

  void detectFocus() {
    removeFocus(focusNode1);
    removeFocus(focusNode2);
    removeFocus(focusNode3);
    removeFocus(focusNode4);
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      customActions: Container(),
      title: "Хүргэлтийн хаяг",
      bottomSheet: Container(
        width: Get.width,
        height: Get.height * .09,
        color: MyColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: CustomButton(
            isActive: isPhoneOk && isAddressOk && isLocationOk & isEdited,
            onPressed: () {
              FocusScope.of(context).unfocus();
              // createOrderAndInvoice();
              saveUserAddress();
            },
            text: "Хадгалах",
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
                                : selectedLocation["name"] ?? "Байршил сонгох",
                            style: TextStyle(
                              color:
                                  selectedLocation.isNotEmpty || address1 != ""
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
                        isEdited = true;
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
                      isEdited = true;
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
                        onChanged: (p0) {
                          isEdited = true;
                          setState(() {});
                        },
                      ),
                    ],
                  )
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
            ),
    );
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
                      isEdited = true;
                      address1 = item["name"];
                      address.clear();
                      isAddressOk = false;
                      isApartment = selectedLocation["apartment"] == 1;
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
