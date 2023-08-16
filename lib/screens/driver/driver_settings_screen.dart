import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DriverSettingsScreen extends StatefulWidget {
  const DriverSettingsScreen({
    super.key,
  });

  @override
  State<DriverSettingsScreen> createState() => _DriverSettingsScreenState();
}

class _DriverSettingsScreenState extends State<DriverSettingsScreen> {
  bool loading = false;
  List driverInfo = [];
  @override
  void initState() {
    super.initState();
    getDriverInfo();
  }

  Future<void> getDriverInfo() async {
    loading = true;
    dynamic res = await RestApi().getUser(RestApiHelper.getUserId());
    if (res != null) {
      dynamic response = Map<String, dynamic>.from(res);
      driverInfo = [response["data"]];
      log(response["data"].toString());
    }
    loading = false;
    setState(() {});
  }

  String generateDriverName(driverInfo) {
    var first = driverInfo["firstName"] ?? "";
    var last = driverInfo["lastName"] ?? "";
    var name = "${first[0]}. $last";
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
        title: "Миний бүртгэл",
        customActions: Container(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.white,
                  border: Border.all(width: 1, color: MyColors.background),
                ),
                child: const Icon(
                  FontAwesomeIcons.user,
                  size: 40,
                  color: MyColors.grey,
                ),
              ),
              const SizedBox(height: 12),
              loading
                  ? CustomShimmer(width: Get.width * .2, height: 14)
                  : Text(generateDriverName(driverInfo[0])),
              const SizedBox(height: 12),
              loading && driverInfo.isEmpty
                  ? Column(
                      children: [
                        listItemShimmer(),
                        listItemShimmer(),
                        listItemShimmer(),
                      ],
                    )
                  : Column(
                      children: [
                        listItem("Гар утасны дугаар",
                            driverInfo[0]["phone"] ?? "No info"),
                        listItem("Харилцах банк", "Хаан банк"),
                        listItem("Дансны дугаар",
                            driverInfo[0]["bankAccount"] ?? "No data"),
                      ],
                    ),
            ],
          ),
        ));
  }

  Widget listItem(String title, String info) {
    return CustomInkWell(
      onTap: () {},
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1,
                color: MyColors.background,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: MyColors.gray, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(info),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listItemShimmer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          width: 1,
          color: MyColors.background,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      height: Get.height * .1,
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: Get.width * .5,
            child: Row(
              children: [
                CustomShimmer(
                  width: Get.width * .1,
                  height: Get.width * .1,
                  borderRadius: 50,
                ),
                const SizedBox(width: 12),
                CustomShimmer(
                  width: Get.width * .3,
                  height: 14,
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomShimmer(
                  width: Get.width * .3,
                  height: 14,
                ),
                CustomShimmer(
                  width: Get.width * .3,
                  height: 14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
