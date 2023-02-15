import 'dart:developer';

import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/swipe_button.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

List numbers = List<int>.generate(60, (i) => i + 1);
void showOrdersSetTime(context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 1,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                vertical: Get.height * .075, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "Захиалгын код",
                      fontSize: 12,
                      color: MyColors.gray,
                    ),
                    CustomText(
                      text: "Нийт үнэ",
                      fontSize: 12,
                      color: MyColors.gray,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: "3224",
                      fontSize: 16,
                      color: MyColors.black,
                    ),
                    CustomText(
                      text: convertToCurrencyFormat(
                        24000,
                        toInt: true,
                        locatedAtTheEnd: true,
                      ),
                      fontSize: 14,
                      color: MyColors.black,
                    )
                  ],
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: CustomText(text: "Гуляш", fontSize: 14),
                      trailing: CustomText(text: "1"),
                    );
                  },
                ),
                const SizedBox(height: 12),
                const CustomText(text: "Бэлэн болох хугацаа:"),
                SizedBox(
                  height: Get.height * .2,
                  width: Get.width * .3,
                  child: CupertinoPicker(
                    magnification: 1.1,
                    squeeze: 1,
                    useMagnifier: false,
                    itemExtent: 24,
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int selectedItem) {
                      log(selectedItem.toString());
                    },
                    children:
                        List<Widget>.generate(numbers.length, (int index) {
                      return Center(
                        child: CustomText(
                          text: "${numbers[index]} минут",
                          fontSize: 14,
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: Get.height * .15),
                swipeButton("Хүргэлтэнд", () {
                  Get.back();
                })
              ],
            ),
          ),
        ),
      );
    },
  );
}
