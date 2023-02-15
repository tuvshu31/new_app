import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/screens/store/orders/store_orders_main_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/swipe_button.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:slide_to_act/slide_to_act.dart';

List numbers = List<int>.generate(60, (i) => i + 1);
final _storeCtx = Get.put(StoreController());

void showOrdersSetTime(context, data) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Obx(
        () => FractionallySizedBox(
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
                        text: data["orderId"].toString(),
                        fontSize: 16,
                        color: MyColors.black,
                      ),
                      CustomText(
                        text: convertToCurrencyFormat(
                          double.parse(data["totalAmount"]),
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
                    itemCount: data["products"].length,
                    itemBuilder: (context, index) {
                      var product = data["products"][index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: CustomText(text: product["name"], fontSize: 14),
                        trailing:
                            CustomText(text: product["quantity"].toString()),
                      );
                    },
                  ),
                  SizedBox(height: Get.height * .3),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const CustomText(text: "Бэлэн болох хугацаа:"),
                      NumberPicker(
                        haptics: true,
                        itemWidth: Get.width * .2,
                        selectedTextStyle: const TextStyle(
                          color: MyColors.black,
                          fontSize: 16,
                        ),
                        textStyle: const TextStyle(
                          color: MyColors.gray,
                          fontSize: 12,
                        ),
                        textMapper: (numberText) {
                          return "$numberText минут";
                        },
                        value: _storeCtx.pickedMinutes.value,
                        minValue: 0,
                        maxValue: 100,
                        onChanged: (value) {
                          _storeCtx.pickedMinutes.value = value;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * .1),
                  Builder(
                    builder: (contexts) {
                      final GlobalKey<SlideActionState> key = GlobalKey();
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SlideAction(
                          outerColor: MyColors.black,
                          innerColor: MyColors.primary,
                          elevation: 0,
                          key: key,
                          submittedIcon: const Icon(
                            FontAwesomeIcons.check,
                            color: MyColors.white,
                          ),
                          onSubmit: () {
                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              key.currentState!.reset();
                              _storeCtx.orderList.add(data);
                              Get.back();
                              Get.to(() => const StoreOrdersMainScreen());
                            });
                          },
                          alignment: Alignment.centerRight,
                          sliderButtonIcon: const Icon(
                            Icons.double_arrow_rounded,
                            color: MyColors.white,
                          ),
                          child: Text(
                            "Бэлдэж эхлэх",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
