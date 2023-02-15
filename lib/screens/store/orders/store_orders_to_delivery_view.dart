import 'dart:convert';
import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/swipe_button.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:slide_to_act/slide_to_act.dart';

final _storeCtx = Get.put(StoreController());
void callDriver(dynamic info) async {
  var body = {
    "orderId": info['id'],
    'address': info["address"],
    'phone': info["phone"],
  };
  await RestApi().assignDriver(body);
}

void storeOrdersToDeliveryView(context, data) {
  var products = data["products"];
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
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      title: CustomText(
                          text: products[index]["name"], fontSize: 14),
                      trailing: CustomText(
                          text: products[index]["quantity"].toString()),
                    );
                  },
                ),
                SizedBox(height: Get.height * .5),
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
                          Future.delayed(const Duration(milliseconds: 300), () {
                            key.currentState!.reset();
                            callDriver(data);
                            Get.back();
                          });
                        },
                        alignment: Alignment.centerRight,
                        sliderButtonIcon: const Icon(
                          Icons.double_arrow_rounded,
                          color: MyColors.white,
                        ),
                        child: Text(
                          "Хүргэлтэнд гаргах",
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
      );
    },
  );
}
