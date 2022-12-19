import 'dart:developer';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class GoingOrdersView extends StatefulWidget {
  const GoingOrdersView({super.key});

  @override
  State<GoingOrdersView> createState() => _GoingOrdersViewState();
}

class _GoingOrdersViewState extends State<GoingOrdersView> {
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  dynamic _data = [];
  void getOrders() async {
    var body = {"userId": RestApiHelper.getUserId()};
    dynamic response = await RestApi().getOrders(body);
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      setState(() {
        _data = d["data"][0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _data.isNotEmpty
        ? SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: Get.width * .1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * .1),
                  _statusList(
                      _data["orderStatus"] == "sent", "Захиалга хүлээн авсан"),
                  _divider(),
                  _statusList(_data["orderStatus"] == "preparing",
                      "Хүргэлтэнд бэлдэж байна"),
                  _divider(),
                  _statusList(_data["orderStatus"] == "delivering",
                      "Хүргэлтэнд гарсан"),
                  _divider(),
                  _statusList(_data["orderStatus"] == "received",
                      "Захиалгыг хүлээлгэн өгсөн"),
                  SizedBox(height: Get.height * .1),
                ],
              ),
            ),
          )
        : CustomLoadingIndicator(text: "Шинэ захиалга байхгүй байна");
  }

  Widget _statusList(bool isActive, String text) {
    return Row(
      children: [
        SizedBox(
          width: Get.width * .2,
          child: isActive
              ? Lottie.asset(
                  'assets/json/radiant.json',
                  width: Get.width * .1,
                  height: Get.width * .1,
                )
              : Icon(
                  Icons.circle,
                  color: MyColors.gray,
                  size: 14,
                ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isActive
                ? CustomText(
                    text: _data["orderTime"],
                    color: isActive ? MyColors.black : MyColors.gray,
                  )
                : Container(),
            CustomText(
              text: text,
              color: isActive ? MyColors.black : MyColors.gray,
            ),
          ],
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.only(left: Get.width * .1),
      height: Get.height * .07,
      width: 1,
      color: MyColors.background,
    );
  }
}
