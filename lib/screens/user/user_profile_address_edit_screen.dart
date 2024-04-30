import 'dart:developer';

import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/controller/address_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/address.dart';
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
  List location = [];
  List section = [];
  Map address = {};
  bool loading = false;
  bool showSection = false;
  final _addressCtx = Get.put(AddressController());

  @override
  void initState() {
    super.initState();
    getUserAddressDetails();
  }

  void getUserAddressDetails() async {
    loading = true;
    dynamic getUserAddressDetails = await UserApi().getUserAddressDetails();
    loading = false;
    if (getUserAddressDetails != null) {
      dynamic response = Map<String, dynamic>.from(getUserAddressDetails);
      if (response["success"]) {
        section = response["section"];
        location = response["location"];
        address = response["address"] ?? {};
        showSection = response["showSection"];
      }
    }
    setState(() {});
  }

  void saveUserAddressInfo() async {
    CustomDialogs().showLoadingDialog();
    var body = {
      "sectionId": _addressCtx.selectedSection["id"],
      "locationId": _addressCtx.selectedLocation["id"],
      "address": _addressCtx.addressController.value.text,
      "phone": _addressCtx.phoneController.value.text,
      "entrance": _addressCtx.entranceController.value.text,
    };
    dynamic saveUserAddressInfo = await UserApi().saveUserAddressInfo(body);
    Get.back();
    if (saveUserAddressInfo != null) {
      dynamic response = Map<String, dynamic>.from(saveUserAddressInfo);
      if (response["success"]) {
        Get.back();
        customSnackbar(ActionType.success, "Амжилттай хадгалагдлаа", 2);
      } else {
        customSnackbar(ActionType.error, "Алдаа гарлаа", 2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomHeader(
        customActions: Container(),
        title: "Хүргэлтийн хаяг",
        body: loading
            ? _shimmer()
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
                        showSection: showSection,
                        onpressed: () {},
                      ),
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
              onPressed: saveUserAddressInfo,
              text: "Хадгалах",
              textColor: MyColors.white,
              elevation: 0,
            ),
          ),
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
}
