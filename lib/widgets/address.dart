import 'dart:developer';

import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:Erdenet24/controller/address_controller.dart';

class CustomAddressWidget extends StatefulWidget {
  final List section;
  final List location;
  final Map address;
  final VoidCallback onpressed;
  const CustomAddressWidget({
    required this.location,
    required this.address,
    required this.section,
    required this.onpressed,
    super.key,
  });

  @override
  State<CustomAddressWidget> createState() => _CustomAddressWidgetState();
}

class _CustomAddressWidgetState extends State<CustomAddressWidget> {
  List section = [];
  List location = [];
  List fdLocation = [];
  String phoneErrorText = "";
  String sectionTitle = "Сонгох";
  String locationTitle = "Сонгох";
  final addressCtx = Get.put(AddressController());

  @override
  void initState() {
    super.initState();
    Get.delete<AddressController>(force: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      replaceUserAddress();
    });
  }

  void replaceUserAddress() {
    section = widget.section;
    location = widget.location;
    if (widget.address.isNotEmpty) {
      addressCtx.selectedSection.value = widget.address["selectedSection"];
      sectionTitle = addressCtx.selectedSection["name"];
      addressCtx.selectedLocation.value = widget.address["selectedLocation"];
      locationTitle = addressCtx.selectedLocation["name"];
      addressCtx.addressController.value.text = widget.address["address"];
      // addressCtx.phoneController.value.text = widget.address["phone"];
      addressCtx.entranceController.value.text = widget.address["entrance"];
      addressCtx.isSectionOk.value = true;
      addressCtx.isLocationOk.value = true;
      addressCtx.isAddressOk.value = true;
      addressCtx.isLocationOk.value = true;
      addressCtx.isEntranceOk.value = true;
      widget.onpressed();
    }
  }

  void selectSection(Map item) {
    if (addressCtx.selectedSection != item) {
      locationTitle = "Сонгох";
      addressCtx.selectedLocation.value = {};
      addressCtx.isLocationOk.value = false;
    }
    addressCtx.selectedSection.value = item;
    sectionTitle = item["name"];
    fdLocation = location.where((el) => el["sectionId"] == item["id"]).toList();
    addressCtx.isSectionOk.value = true;
    setState(() {});
    Get.back();
  }

  void selectLocation(Map item) {
    addressCtx.selectedLocation.value = item;
    locationTitle = item["name"];
    addressCtx.isLocationOk.value = true;
    setState(() {});
    Get.back();
    widget.onpressed();
  }

  void showCustomBottomSheet(title, list, onPressed) {
    Get.bottomSheet(
      _locationListBody(
        title,
        list,
        onPressed,
      ),
      ignoreSafeArea: false,
      backgroundColor: MyColors.white,
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          section.length > 1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Байршил",
                        style: TextStyle(color: MyColors.gray)),
                    const SizedBox(height: 12),
                    CustomInkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => showCustomBottomSheet(
                        "Байршил сонгох",
                        section,
                        selectSection,
                      ),
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
                            Text(sectionTitle),
                            const Icon(IconlyLight.arrow_down_2)
                          ],
                        )),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                )
              : Container(),
          const Text(
            "Хаяг",
            style: TextStyle(
              color: MyColors.gray,
            ),
          ),
          const SizedBox(height: 12),
          CustomInkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => showCustomBottomSheet(
              "Хаяг сонгох",
              location,
              selectLocation,
            ),
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
                  Expanded(child: Text(locationTitle)),
                  const Icon(IconlyLight.arrow_down_2)
                ],
              )),
            ),
          ),
          const SizedBox(height: 12),
          const Text("Дэлгэрэнгүй хаяг",
              style: TextStyle(color: MyColors.gray)),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: "Жишээ нь: 3-24-р байр, 9 давхарт 1165 тоот",
            controller: addressCtx.addressController.value,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              FocusScope.of(context).nextFocus();
            },
            onChanged: (val) {
              if (val.isNotEmpty) {
                addressCtx.isAddressOk.value = true;
              }
            },
          ),
          const SizedBox(height: 12),
          const Text(
            "Утас",
            style: TextStyle(color: MyColors.gray),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: "9935*****",
            errorText: phoneErrorText,
            controller: addressCtx.phoneController.value,
            maxLength: 8,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              FocusScope.of(context).nextFocus();
            },
            onChanged: (val) {
              if (val.isEmpty) {
                phoneErrorText = "";
                addressCtx.isPhoneOk.value = false;
              } else if (val.length < 8) {
                phoneErrorText = "Утасны дугаар буруу байна";
                addressCtx.isPhoneOk.value = false;
              } else {
                phoneErrorText = "";
                addressCtx.isPhoneOk.value = true;
              }
              setState(() {});
            },
          ),
          _errorText(phoneErrorText),
          const SizedBox(height: 12),
          Row(
            children: const [
              Text(
                "Орцны код",
                style: TextStyle(color: MyColors.gray),
              ),
              Text(
                " /Заавал биш/",
                style: TextStyle(fontSize: 12, color: MyColors.gray),
              )
            ],
          ),
          const SizedBox(height: 12),
          CustomTextField(
            hintText: "#1234",
            controller: addressCtx.entranceController.value,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: Get.height * .15)
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
