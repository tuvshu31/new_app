import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';

Color _getDialogColors(ActionType actionType) {
  switch (actionType) {
    case ActionType.error:
      return Colors.red;
    case ActionType.warning:
      return Colors.amber;
    case ActionType.success:
      return Colors.green;
    default:
      return Colors.red;
  }
}

String _getDialogTitle(ActionType actionType) {
  switch (actionType) {
    case ActionType.error:
      return "Уучлаарай";
    case ActionType.warning:
      return "Анхааруулга";
    case ActionType.success:
      return "Амжилттай";
    default:
      return "Уучлаарай";
  }
}

void showCustomDialog(
    ActionType actionType, String text, VoidCallback onPressed,
    {onWillPop = true}) {
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
      return WillPopScope(
        onWillPop: () async => onWillPop,
        child: Transform.scale(
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
                      IconlyBold.info_circle,
                      size: Get.width * .15,
                      color: _getDialogColors(actionType),
                    ),
                    SizedBox(height: Get.height * .02),
                    Text(
                      _getDialogTitle(actionType),
                      style: const TextStyle(
                        color: MyColors.gray,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: Get.height * .02),
                    Column(
                      children: [
                        Text(
                          text,
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
                                bgColor: _getDialogColors(actionType),
                                text: "Тийм",
                                onPressed: onPressed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void showMyCustomDialog(bool onWillPop, ActionType actionType, String text,
    VoidCallback onPressed, Widget body,
    {String okText = "Тийм", String cancelText = "Үгүй"}) {
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
      return WillPopScope(
        onWillPop: () async => onWillPop,
        child: Transform.scale(
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
                      IconlyBold.info_circle,
                      size: Get.width * .15,
                      color: _getDialogColors(actionType),
                    ),
                    SizedBox(height: Get.height * .02),
                    Text(
                      _getDialogTitle(actionType),
                      style: const TextStyle(
                        color: MyColors.gray,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: Get.height * .02),
                    Column(
                      children: [
                        Text(
                          text,
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
                              text: cancelText,
                              elevation: 0,
                              textColor: Colors.black,
                            )),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomButton(
                                elevation: 0,
                                bgColor: _getDialogColors(actionType),
                                text: okText,
                                onPressed: onPressed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
