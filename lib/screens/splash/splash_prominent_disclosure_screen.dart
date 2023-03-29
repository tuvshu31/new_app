import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/text.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';

class SplashProminentDisclosure extends StatefulWidget {
  const SplashProminentDisclosure({super.key});

  @override
  State<SplashProminentDisclosure> createState() =>
      _SplashProminentDisclosureState();
}

class _SplashProminentDisclosureState extends State<SplashProminentDisclosure> {
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      customActions: Container(),
      customLeading: Container(),
      customTitle: Container(),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          children: [
            SizedBox(height: Get.height * .2),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  color: MyColors.fadedGrey, shape: BoxShape.circle),
              child: Image(
                image:
                    const AssetImage("assets/images/png/app/google-maps.png"),
                width: Get.width * .1,
              ),
            ),
            SizedBox(height: Get.height * .05),
            CustomText(
              text: "Та байршилаа асаана уу",
              fontSize: 20,
            ),
            SizedBox(height: Get.height * .03),
            CustomText(
              text: "Таны хүргэлтийн мэдээлэл харагдана",
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
                        onPressed: (() {}),
                        bgColor: MyColors.white,
                        elevation: 0,
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {},
                        text: "Асаах",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
