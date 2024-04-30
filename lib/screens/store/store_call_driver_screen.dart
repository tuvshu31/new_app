import 'dart:developer';

import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/controller/address_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/address.dart';
import 'package:Erdenet24/widgets/custom_loading_widget.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/textfield.dart';

class StoreCallDriverScreen extends StatefulWidget {
  const StoreCallDriverScreen({super.key});

  @override
  State<StoreCallDriverScreen> createState() => _StoreCallDriverScreenState();
}

class _StoreCallDriverScreenState extends State<StoreCallDriverScreen> {
  int pickedTime = 0;
  String timePickerText = "Бэлдэх хугацаа сонгох";
  String locationTitle = "Хүлээн авагчийн байршил";
  String locationPickerText = "";
  bool fetchingUserAddress = false;
  TextEditingController totalAmountCTRL = TextEditingController();
  List location = [];
  List section = [];
  Map address = {};
  bool showSection = false;
  int deliveryPrice = 0;
  final _addressCtx = Get.put(AddressController());

  @override
  void initState() {
    super.initState();
    locationPickerText = locationTitle;
    setState(() {});
    storeCheckUserLocation();
  }

  void storeCheckUserLocation() async {
    fetchingUserAddress = true;
    dynamic storeCheckUserLocation = await StoreApi().storeCheckUserLocation();
    fetchingUserAddress = false;
    if (storeCheckUserLocation != null) {
      dynamic response = Map<String, dynamic>.from(storeCheckUserLocation);
      if (response["success"]) {
        section = response["section"];
        location = response["location"];
        showSection = response["showSection"];
      }
    }
    setState(() {});
  }

  void storeCalculateDeliveryPrice() async {
    CustomDialogs().showLoadingDialog();
    var body = {
      "sectionId": _addressCtx.selectedSection["id"],
      "locationId": _addressCtx.selectedLocation["id"]
    };
    dynamic storeCalculateDeliveryPrice =
        await StoreApi().storeCalculateDeliveryPrice(body);
    Get.back();
    if (storeCalculateDeliveryPrice != null) {
      dynamic response = Map<String, dynamic>.from(storeCalculateDeliveryPrice);
      log(response.toString());
      if (response["success"]) {
        deliveryPrice = response["deliveryPrice"];
      }
    }
  }

  void storeCreateNewOrder() async {
    CustomDialogs().showLoadingDialog();
    var body = {
      "section": _addressCtx.selectedSection["name"],
      "location": _addressCtx.selectedLocation["name"],
      "deliveryPrice": deliveryPrice,
      "address": _addressCtx.addressController.value.text,
      "phone": _addressCtx.phoneController.value.text,
      "entrance": _addressCtx.entranceController.value.text,
      "totalAmount": totalAmountCTRL.text,
      "prepDuration": pickedTime,
    };
    log(body.toString());
    dynamic storeCreateNewOrder = await StoreApi().storeCreateNewOrder(body);
    Get.back();
    if (storeCreateNewOrder != null) {
      dynamic response = Map<String, dynamic>.from(storeCreateNewOrder);
      if (response["success"]) {
        Get.back();
      } else {
        customSnackbar(ActionType.error, "Алдаа гарлаа", 2);
      }
    }
  }

  Future<void> showStoreDurationPicker(StateSetter setStates) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => true,
          child: StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text(
                  "Бэлдэх хугацаагаа \n сонгоно уу",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  height: Get.height * .3,
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 50,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    onSelectedItemChanged: (value) {
                      setState(() {
                        pickedTime = value * 60;
                      });
                    },
                    physics: const BouncingScrollPhysics(),
                    useMagnifier: true,
                    magnification: 1.3,
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 60,
                      builder: (context, index) {
                        return Center(child: Text("$index' минут"));
                      },
                    ),
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        isActive: pickedTime != 0,
                        isFullWidth: false,
                        text: "Сонгох",
                        bgColor: Colors.green,
                        elevation: 0,
                        height: 48,
                        cornerRadius: 8,
                        onPressed: () {
                          setStates(() {
                            timePickerText = "${pickedTime / 60} минут";
                          });

                          Get.back();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: Get.width * .02),
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomHeader(
        title: "Жолооч дуудах",
        customActions: Container(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  hintText: "Захиалгын үнийн дүн",
                  controller: totalAmountCTRL,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {},
                  formatThousands: true,
                ),
                const SizedBox(height: 12),
                _dropDownWidget(
                    () => showStoreDurationPicker(setState), timePickerText),
                const SizedBox(height: 12),
                CustomAddressWidget(
                  location: location,
                  address: address,
                  section: section,
                  onpressed: storeCalculateDeliveryPrice,
                  showSection: true,
                )
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
                  _addressCtx.isAddressOk.value &&
                  totalAmountCTRL.text.isNotEmpty &&
                  totalAmountCTRL.text != "0" &&
                  pickedTime != 0,
              onPressed: storeCreateNewOrder,
              text: "Жолооч дуудах",
              textColor: MyColors.white,
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dropDownWidget(VoidCallback onTap, String text) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: MyColors.white,
            border: Border.all(
              width: 0.7,
              color: MyColors.grey,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: text,
              color: MyColors.black,
            ),
            const Icon(
              IconlyLight.arrow_down_2,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
