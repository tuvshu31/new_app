import 'dart:developer';

import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/utils/enums.dart';
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
  List locationList = [];
  Map selectedLocation = {};
  TextEditingController totalAmountCTRL = TextEditingController();
  TextEditingController addressCTRL = TextEditingController();
  TextEditingController phoneCTRL = TextEditingController();
  TextEditingController entranceKodCTRL = TextEditingController();

  @override
  void initState() {
    super.initState();
    locationPickerText = locationTitle;
    setState(() {});
    getAllLocations();
  }

  void getAllLocations() async {
    fetchingUserAddress = true;
    dynamic getAllLocations = await UserApi().getAllLocations();
    fetchingUserAddress = false;
    if (getAllLocations != null) {
      dynamic response = Map<String, dynamic>.from(getAllLocations);
      if (response["success"]) {
        locationList = response["data"];
      }
    }
    setState(() {});
  }

  void storeCreateNewOrder() async {
    CustomDialogs().showLoadingDialog();
    var body = {
      "location": selectedLocation["name"],
      "deliveryPrice": selectedLocation["price"],
      "address": addressCTRL.text,
      "phone": phoneCTRL.text,
      "entrance": entranceKodCTRL.text,
      "totalAmount": totalAmountCTRL.text,
      "prepDuration": pickedTime,
    };
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
    return CustomHeader(
      title: "Жолооч дуудах",
      customActions: Container(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
            _dropDownWidget(
              () {
                Get.bottomSheet(
                  _locationListBody(),
                  ignoreSafeArea: false,
                  backgroundColor: MyColors.white,
                  isScrollControlled: true,
                );
              },
              locationPickerText,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: "Хүлээн авагчийн хаяг",
              controller: addressCTRL,
              textInputAction: TextInputAction.next,
              onChanged: (val) {
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: "Хүлээн авагчийн утасны дугаар",
              controller: phoneCTRL,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              maxLength: 8,
              onChanged: (val) {
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: "Хүлээн авагчийн орцны код",
              controller: entranceKodCTRL,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              onChanged: (val) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
      bottomSheet: _bottomSheet(),
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
                      locationPickerText = item["name"];
                      selectedLocation = item;
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

  Widget _bottomSheet() {
    return Container(
      width: Get.width,
      height: Get.height * .1,
      color: MyColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: CustomButton(
          isActive: totalAmountCTRL.text.isNotEmpty &&
              totalAmountCTRL.text != "0" &&
              addressCTRL.text.isNotEmpty &&
              phoneCTRL.text.isNotEmpty &&
              phoneCTRL.text.length == 8 &&
              locationPickerText != locationTitle &&
              pickedTime != 0,
          onPressed: storeCreateNewOrder,
          text: "Жолооч дуудах",
          textColor: MyColors.white,
          elevation: 0,
        ),
      ),
    );
  }
}
