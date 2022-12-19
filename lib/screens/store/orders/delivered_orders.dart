import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/loading.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:get/get.dart';

class DeliveredOrdersView extends StatefulWidget {
  const DeliveredOrdersView({super.key});

  @override
  State<DeliveredOrdersView> createState() => _DeliveredOrdersViewState();
}

class _DeliveredOrdersViewState extends State<DeliveredOrdersView> {
  dynamic _data = [];
  @override
  void initState() {
    super.initState();
    getOrders();
  }

  void getOrders() async {
    dynamic response =
        await RestApi().getStoreOrders(RestApiHelper.getUserId(), {});
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      setState(() {
        _data = d["data"];
      });
    }
  }

  void orderUpdateHelper(int id, dynamic body) async {
    loadingDialog(context);
    dynamic product = await RestApi().updateOrder(id, body);
    dynamic data = Map<String, dynamic>.from(product);
    Get.back();
    if (data["success"]) {
      successSnackBar("Амжилттай илгээлээ", 2, context);
    } else {
      errorSnackBar("Үл мэдэгдэх алдаа гарлаа", 2, context);
    }
  }

  String timeDiffCalctr(time) {
    var difference = DateTime.now().difference(DateTime.parse(time)).inMinutes;
    return difference.toString();
  }

  Color colorChanger(String status) {
    return status == "sent"
        ? MyColors.primary
        : status == "preparing"
            ? MyColors.warning
            : status == "delivering"
                ? MyColors.green
                : MyColors.black;
  }

  String statusChanger(String status) {
    return status == "sent"
        ? "preparing"
        : status == "preparing"
            ? "delivering"
            : status == "delivering"
                ? "received"
                : "";
  }

  String buttonTextChanger(String status) {
    return status == "sent"
        ? "Жолооч дуудах"
        : status == "preparing"
            ? "Хүлээлгэн өгөх"
            : "";
  }

  @override
  Widget build(BuildContext context) {
    return _data.length < 0
        ? ListView.separated(
            separatorBuilder: (context, index) {
              return Container(height: 8);
            },
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _data.length,
            itemBuilder: (context, index) {
              var status = _data[index]["orderStatus"];
              return GestureDetector(
                onTap: (() {}),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                                text: _data[index]["orderId"].toString()),
                            CustomText(
                              text:
                                  "${timeDiffCalctr(_data[index]["orderTime"])} минутын өмнө",
                              color: MyColors.warning,
                              fontSize: 12,
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Утас:",
                              color: MyColors.gray,
                              fontSize: 12,
                            ),
                            CustomText(
                              text: _data[index]["phone"],
                              fontSize: 12,
                              color: MyColors.gray,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: "Хаяг",
                              fontSize: 12,
                              color: MyColors.gray,
                            ),
                            CustomText(
                              text: _data[index]["address"],
                              fontSize: 12,
                              color: MyColors.gray,
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: "Захиалгын дүн:"),
                            CustomText(
                              text: convertToCurrencyFormat(
                                double.parse(_data[index]["totalAmount"]),
                                toInt: true,
                                locatedAtTheEnd: true,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            })
        : CustomLoadingIndicator(text: "Захиалга байхгүй байна");
  }
}
