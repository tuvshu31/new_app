import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:slide_to_act/slide_to_act.dart';

final _storeCtx = Get.put(StoreController());

void storeOrdersToDeliveryView(context, data) {
  showModalBottomSheet(
    backgroundColor: MyColors.white,
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.9,
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 24),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CustomText(
                    text: "Захиалгын код:",
                    fontSize: 14,
                    color: MyColors.gray,
                  ),
                  CustomText(
                    text: data["orderId"].toString(),
                    fontSize: 16,
                    color: MyColors.black,
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    separatorBuilder: (context, index) {
                      return Container(
                        height: 7,
                        color: MyColors.fadedGrey,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: data["products"].length,
                    itemBuilder: (context, index) {
                      var product = data["products"][index];
                      return Container(
                          height: Get.height * .09,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          color: MyColors.white,
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: MyColors.black,
                                      width: 1,
                                    ),
                                  ),
                                  child: CustomText(
                                    text: "${index + 1}",
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            title: CustomText(
                              text: product["name"],
                              fontSize: 16,
                            ),
                            subtitle: CustomText(
                                text: convertToCurrencyFormat(
                              int.parse(product["price"]),
                              toInt: true,
                              locatedAtTheEnd: true,
                            )),
                            trailing: CustomText(
                                text: "${product["quantity"]} ширхэг"),
                          ));
                    },
                  ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  height: 70,
                  child: Builder(
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
                          Future.delayed(const Duration(milliseconds: 300),
                              () async {
                            key.currentState!.reset();
                            for (dynamic i in _storeCtx.orderList) {
                              if (i == data) {
                                i["orderStatus"] = "delivering";
                              }
                            }
                            _storeCtx.filterOrders(0);
                            var body = {"orderStatus": "delivering"};
                            await RestApi().updateOrder(data["id"], body);
                            //  CALL DRIVER
                            var body1 = {
                              "orderId": data['id'],
                              'address': data["address"],
                              'phone': data["phone"],
                            };
                            await RestApi().assignDriver(body1);
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
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
