import 'dart:developer';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/text.dart';
import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

void requestPermission() async {
  await Geolocator.requestPermission().then((value) {
    log(value.toString());
    // Get.toNamed(_route);
  });
}

void showLocationDisclosureScreen(context) {
  showDialog(
    useSafeArea: true,
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.6,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: MyColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: MyColors.fadedGrey, shape: BoxShape.circle),
                  child: Image(
                    image: const AssetImage(
                        "assets/images/png/app/google-maps.png"),
                    width: Get.width * .1,
                  ),
                ),
                SizedBox(height: Get.height * .05),
                CustomText(
                  text: "Таны байршлын мэдээллийг авахыг зөвшөөрч байна уу",
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Get.height * .03),
                CustomText(
                  textAlign: TextAlign.justify,
                  text:
                      "Erdenet24 цахим худалдааны апликейшн нь таныг хүргэлтийн бүсэд байгаа эсэхийг тодорхойлох болон таны захиалгын хүргэлтийн мэдээллийг харуулахын тулд програмыг ашиглаж байх үед байршлын мэдээллийг цуглуулдаг.",
                  color: MyColors.gray,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Татгалзах",
                            textColor: MyColors.gray,
                            onPressed: () {
                              Get.back();
                              // Get.offNamed(route);
                            },
                            bgColor: MyColors.white,
                            elevation: 0,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: CustomButton(
                            onPressed: requestPermission,
                            text: "Зөвшөөрөх",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
