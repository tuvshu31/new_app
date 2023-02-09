import 'dart:developer';
import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverPaymentsPage extends StatefulWidget {
  const DriverPaymentsPage({super.key});

  @override
  State<DriverPaymentsPage> createState() => _DriverPaymentsPageState();
}

class _DriverPaymentsPageState extends State<DriverPaymentsPage> {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Төлбөр тооцоо",
      customActions: Container(),
      body: Column(
        children: [
          DefaultTabController(
            length: 2,
            initialIndex: 0,
            child: TabBar(
              onTap: ((value) {
                pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.bounceInOut,
                );
              }),
              labelColor: MyColors.primary,
              unselectedLabelColor: MyColors.black,
              indicatorColor: MyColors.primary,
              tabs: const [
                Tab(
                  text: "Хүлээгдэж буй",
                ),
                Tab(
                  text: "Шилжүүлсэн",
                ),
              ],
            ),
          ),
          Expanded(
              child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              _listView(6),
              _listView(16),
            ],
          ))
        ],
      ),
    );
  }

  Widget _listView(int count) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) {
        return Container(
          height: 7,
          color: MyColors.fadedGrey,
        );
      },
      itemCount: count,
      itemBuilder: (context, index) {
        return _item();
      },
    );
  }

  Widget _item() {
    return Container(
      height: Get.height * .09,
      color: MyColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(text: "Нийт"),
                CustomText(text: "2023-02-06"),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: CustomText(text: "5"),
            ),
          ),
          Expanded(
            child: Center(
              child: CustomText(
                text: convertToCurrencyFormat(
                  double.parse("4000"),
                  toInt: true,
                  locatedAtTheEnd: true,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
