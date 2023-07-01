import 'package:Erdenet24/utils/styles.dart';
import 'package:curved_progress_bar/curved_progress_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/button.dart';

Widget showLoadingDialogBody() {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(Get.width * .09),
      child: const CurvedCircularProgressIndicator(
        strokeWidth: 5,
        animationDuration: Duration(seconds: 1),
        backgroundColor: MyColors.background,
        color: MyColors.primary,
      ),
    ),
  );
}

Widget showLogoutDialogBody(dynamic onPressed) {
  return Column(
    children: [
      const Text(
        "Та системээс гарахдаа итгэлтэй байна уу?",
        textAlign: TextAlign.center,
      ),
      SizedBox(height: Get.height * .04),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: CustomButton(
            onPressed: Get.back,
            bgColor: Colors.white,
            text: "Үгүй",
            elevation: 0,
            textColor: Colors.black,
          )),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              elevation: 0,
              bgColor: Colors.amber,
              text: "Тийм",
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget showAccountDeleteDialogBody(dynamic onPressed) {
  return Column(
    children: [
      const Text(
        "Бүртгэлээ устгаснаар таны бүх мэдээлэл апликейшн дээрээс устгагдана. Та бүртгэлээ устгахдаа итгэлтэй байна уу? ",
        textAlign: TextAlign.center,
      ),
      SizedBox(height: Get.height * .04),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: CustomButton(
            onPressed: Get.back,
            bgColor: Colors.white,
            text: "Үгүй",
            elevation: 0,
            textColor: Colors.black,
          )),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              elevation: 0,
              bgColor: Colors.amber,
              text: "Тийм",
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget showNetworkErrorDialogBody(dynamic onPressed) {
  return Column(
    children: [
      const Text(
        "Интернэт холболт салсан байна",
        textAlign: TextAlign.center,
      ),
      SizedBox(height: Get.height * .04),
      CustomButton(
        isFullWidth: false,
        elevation: 0,
        bgColor: Colors.red,
        text: "OK",
        onPressed: () {
          Get.back();
        },
      ),
    ],
  );
}
