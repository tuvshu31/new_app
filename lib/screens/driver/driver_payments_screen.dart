import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverPaymentsScreen extends StatefulWidget {
  const DriverPaymentsScreen({super.key});

  @override
  State<DriverPaymentsScreen> createState() => _DriverPaymentsScreenState();
}

class _DriverPaymentsScreenState extends State<DriverPaymentsScreen> {
  PageController pageController = PageController();
  final _driverCtx = Get.put(DriverController());

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
              _listView(),
              const CustomLoadingIndicator(
                  text: "Шилжүүлсэн хүргэлт байхгүй байна")
            ],
          ))
        ],
      ),
    );
  }

  Widget _listView() {
    return Obx(
      () => _driverCtx.driverPayments.isNotEmpty
          ? ListView.separated(
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return Container(
                  height: 7,
                  color: MyColors.fadedGrey,
                );
              },
              itemCount: _driverCtx.driverPayments.length,
              itemBuilder: (context, index) {
                var data = _driverCtx.driverPayments[index];
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
                            CustomText(text: data["date"]),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: CustomText(text: data["count"].toString()),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: CustomText(
                            text: convertToCurrencyFormat(
                              data["count"] * 3000,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          : CustomLoadingIndicator(text: "Мэдээлэл байхгүй байна"),
    );
  }
}
