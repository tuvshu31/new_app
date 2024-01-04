import 'dart:developer';

import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/custom_loading_widget.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class UserProfileAddressEditScreen extends StatefulWidget {
  const UserProfileAddressEditScreen({super.key});

  @override
  State<UserProfileAddressEditScreen> createState() =>
      _UserProfileAddressEditScreenState();
}

class _UserProfileAddressEditScreenState
    extends State<UserProfileAddressEditScreen> {
  bool isPhoneOk = false;
  bool isAddressOk = false;
  bool isLocationOk = false;
  bool isApartment = false;
  bool fetchingUserAddress = false;
  String phoneErrorText = "";
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  TextEditingController kod = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  List locationList = [];
  Map selectedLocation = {};
  int cartTotalPrice = 0;
  int deliveryPrice = 0;
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    getUserAddress();
    getAllLocations();
    detectFocus();
  }

  void removeFocus(FocusNode focusNode) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {}
    });
    setState(() {});
  }

  void detectFocus() {
    removeFocus(focusNode1);
    removeFocus(focusNode2);
    removeFocus(focusNode3);
    removeFocus(focusNode4);
  }

  void getUserAddress() async {
    fetchingUserAddress = true;
    dynamic getUserAddress = await UserApi().getUserAddress();
    fetchingUserAddress = false;
    dynamic response = Map<String, dynamic>.from(getUserAddress);
    if (response["success"]) {
      Map userAddress = response["address"];
      if (userAddress.isNotEmpty) {
        selectedLocation["name"] = userAddress["district"];
        address.text = userAddress["address"];
        phone.text = userAddress["phone"];
        kod.text = userAddress["code"];
        if (address.text.isNotEmpty) {
          isAddressOk = true;
        }
        if (selectedLocation["name"].isNotEmpty) {
          isLocationOk = true;
        }
        if (phone.text.isNotEmpty) {
          isPhoneOk = true;
        }
      }
    }
    setState(() {});
  }

  void getAllLocations() async {
    dynamic getAllLocations = await UserApi().getAllLocations();
    dynamic response = Map<String, dynamic>.from(getAllLocations);
    if (response["success"]) {
      locationList = response["data"];
      setState(() {});
    }
  }

  void updateUserAddress() async {
    CustomDialogs().showLoadingDialog();
    var body = {
      "district": selectedLocation["name"],
      "phone": phone.text,
      "address": address.text,
      "code": kod.text,
    };
    dynamic updateUserAddress = await UserApi().updateUserAddress(body);
    Get.back();
    if (updateUserAddress != null) {
      dynamic response = Map<String, dynamic>.from(updateUserAddress);
      if (response["success"]) {
        Get.back();
        customSnackbar(
          ActionType.success,
          "Хүргэлтийн хаяг амжилттай хадгалагдлаа",
          2,
        );
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      customActions: Container(),
      title: "Хүргэлтийн хаяг",
      body: fetchingUserAddress
          ? _shimmer()
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
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
                            Get.bottomSheet(
                              _locationListBody(),
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
                                Text(selectedLocation.isNotEmpty
                                    ? selectedLocation["name"]
                                    : "Байршил сонгох"),
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
                          hintText: "Ex: 3-24-р байр, 9 давхарт 1165 тоот",
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
                      ],
                    ),
                  ),
                ),
                Positioned(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: Get.width,
                    height: Get.height * .1,
                    color: MyColors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: CustomButton(
                        isActive: isPhoneOk && isAddressOk && isLocationOk,
                        onPressed: updateUserAddress,
                        text: "Хадгалах",
                        textColor: MyColors.white,
                        elevation: 0,
                      ),
                    ),
                  ),
                ))
              ],
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

  Widget _locationListBody() {
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
        title: "Байршил сонгох",
        customLeading: Container(),
        body: locationList.isEmpty
            ? customLoadingWidget()
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
                itemCount: locationList.length,
                itemBuilder: (context, index) {
                  var item = locationList[index];
                  return CustomInkWell(
                    onTap: () {
                      selectedLocation = item;
                      isLocationOk = true;
                      deliveryPrice = selectedLocation["price"];
                      totalPrice = deliveryPrice + cartTotalPrice;
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
