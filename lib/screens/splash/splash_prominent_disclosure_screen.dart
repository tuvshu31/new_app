import 'dart:developer';

import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import "package:flutter/material.dart";
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashProminentDisclosure extends StatefulWidget {
  const SplashProminentDisclosure({super.key});

  @override
  State<SplashProminentDisclosure> createState() =>
      _SplashProminentDisclosureState();
}

class _SplashProminentDisclosureState extends State<SplashProminentDisclosure> {
  void requestPermission() async {
    await Geolocator.requestPermission().then((value) {
      Get.offAllNamed(_route);
    });
  }

  final _route = Get.arguments;
  @override
  void initState() {
    super.initState();
    log(_route);
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      customActions: Row(
        children: [
          CustomInkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () {
              Get.offAllNamed(_route);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: MyColors.fadedGrey,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      customLeading: Container(),
      customTitle: Container(),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: Get.height * .05),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: MyColors.fadedGrey,
                shape: BoxShape.circle,
              ),
              child: Lottie.asset(
                'assets/json/location.json',
                height: Get.width * .6,
                width: Get.width * .6,
              ),
            ),
            SizedBox(height: Get.height * .1),
            const CustomText(
              text: "Байршил заагчаа асаана уу",
              fontSize: 18,
            ),
            SizedBox(height: Get.height * .03),
            const CustomText(
              textAlign: TextAlign.center,
              text:
                  "Захиалга хийгдэхийн тулд таны байршилыг тодорхойлох шаардлагатай.",
              color: MyColors.gray,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  onPressed: requestPermission,
                  text: "Асаах",
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
