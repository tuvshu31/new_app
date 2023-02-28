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
import 'package:http/http.dart';
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

bool swiped = false;
void storeOrdersToDeliveryView(context, data) {
  var products = data["products"];
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 1,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomText(
                text: "Захиалгын код",
                fontSize: 12,
                color: MyColors.gray,
              ),
              CustomText(
                text: data["orderId"].toString(),
                fontSize: 16,
                color: MyColors.black,
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: CustomText(text: (index + 1).toString()),
                    title: CustomText(text: products[index]["name"]),
                    trailing: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: MyColors.fadedGrey,
                        shape: BoxShape.circle,
                      ),
                      child: CustomText(
                        text: products[index]["quantity"].toString(),
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: Get.height * .6),
              Builder(
                builder: (contexts) {
                  final GlobalKey<SlideActionState> key = GlobalKey();
                  return SlideAction(
                    height: 70,
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
                      // Future.delayed(const Duration(minutes: 5), () {
                      //   key.currentState!.reset();
                      //   callDriver(data);
                      // });
                    },
                    alignment: Alignment.centerRight,
                    sliderButtonIcon: const Icon(
                      Icons.double_arrow_rounded,
                      color: MyColors.white,
                    ),
                    child: const Text(
                      "Хүргэлтэнд гаргах",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    },
  );
}
