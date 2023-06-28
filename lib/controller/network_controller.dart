import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showNetworkErrorSnackbar() {
  showGeneralDialog(
    context: Get.context!,
    barrierLabel: "",
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.bounceInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: Center(
          child: Container(
            width: Get.width,
            margin: EdgeInsets.all(Get.width * .09),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            padding: EdgeInsets.only(
              right: Get.width * .09,
              left: Get.width * .09,
              top: Get.height * .04,
              bottom: Get.height * .03,
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    size: Get.width * .15,
                    color: Colors.black,
                  ),
                  SizedBox(height: Get.height * .02),
                  Text(
                    "Анхааруулга",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.gray,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: Get.height * .02),
                  Text(
                    "Интернэт холболтоо шалгана уу",
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Get.height * .04),
                  CustomButton(
                    onPressed: () {
                      Get.back();
                    },
                    text: "Дахин оролдох",
                    isFullWidth: false,
                    bgColor: Colors.red,
                  )
                  // CustomInkWell(
                  //   onTap: () {
                  //     Get.back();
                  //   },
                  //   child: Container(
                  //     width: Get.width * .3,
                  //     height: 40,
                  //     decoration: BoxDecoration(
                  //       color: MyColors.fadedGrey,
                  //       borderRadius: BorderRadius.circular(25),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         "Дахин оролдох",
                  //         style: TextStyle(
                  //           color: MyColors.black,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 12,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
