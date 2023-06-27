import 'dart:io';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreProductsPreviewScreen extends StatefulWidget {
  const StoreProductsPreviewScreen({super.key});

  @override
  State<StoreProductsPreviewScreen> createState() =>
      _StoreProductsPreviewScreenState();
}

class _StoreProductsPreviewScreenState
    extends State<StoreProductsPreviewScreen> {
  int scrollIndex = 1;
  final _incoming = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      customActions: Container(),
      title: "Бүтээгдэхүүн",
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CarouselSlider(
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      initialPage: 0,
                      aspectRatio: 1,
                      viewportFraction: 1,
                      scrollPhysics: const BouncingScrollPhysics(),
                      onPageChanged: (index, reason) {
                        setState(() {
                          scrollIndex = index + 1;
                        });
                      },
                    ),
                    items: _incoming["image"]
                        .map<Widget>(
                          (item) => Image.file(File(item)),
                        )
                        .toList()),
                _incoming["image"].length > 1
                    ? Positioned(
                        bottom: 12,
                        right: 24,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                              color: MyColors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4)),
                          child: CustomText(
                            text: "$scrollIndex/${_incoming["image"].length}",
                            color: MyColors.white,
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            Container(
              margin: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: _incoming["name"],
                  ),
                  const SizedBox(height: 8),
                  CustomText(
                    text: convertToCurrencyFormat(
                        double.parse("${_incoming["price"]}"),
                        toInt: true,
                        locatedAtTheEnd: true),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  _incoming["otherInfo"].isNotEmpty
                      ? ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 12);
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _incoming["otherInfo"].length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = Map<String, dynamic>.from(
                                _incoming["otherInfo"][index]);
                            var key = removeBracket(data.keys.toString());
                            var value = removeBracket(data.values.toString());
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: CustomText(text: "$key:")),
                                const SizedBox(width: 12),
                                Expanded(
                                    child: CustomText(
                                  text: value,
                                ))
                              ],
                            );
                          },
                        )
                      : Container(),
                  SizedBox(height: Get.height * .1)
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: Get.width,
        height: Get.height * .09,
        color: MyColors.white,
        padding: EdgeInsets.symmetric(horizontal: Get.width * .03),
        child: Row(
          children: [],
        ),
      ),
    );
  }
}
