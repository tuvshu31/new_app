import 'package:Erdenet24/utils/styles.dart';
import 'package:curved_progress_bar/curved_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget customLoadingWidget() {
  return Center(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: MyColors.white,
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
