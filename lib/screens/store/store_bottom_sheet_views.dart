import 'dart:developer';

import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_to_act/slide_to_act.dart';

final _storeCtx = Get.put(StoreController());
final GlobalKey<SlideActionState> slideActionKey = GlobalKey();
Widget showIncomingOrderDialogBody(onPressed) {
  return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: Get.width * .9,
            height: Get.width * .9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Lottie.asset(
                  'assets/json/bell_incoming.json',
                  width: Get.width * .4,
                  height: Get.width * .4,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Шинэ захиалга ирлээ!",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: Get.width * .3,
                  child: CustomButton(
                    isFullWidth: false,
                    height: 48,
                    textFontSize: 16,
                    onPressed: onPressed,
                    bgColor: const Color(0xFF3FCE44),
                    text: "Accept",
                  ),
                )
              ],
            ),
          ),
        ],
      ));
}

Widget showOrdersSetTimeViewBody(context, data, onPressed) {
  return Obx(
    () => Material(
      color: Colors.white,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(),
                      Column(
                        children: [
                          const CustomText(
                            text: "Захиалгын код:",
                            color: MyColors.gray,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            text: data["orderId"].toString(),
                            color: MyColors.black,
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                      CustomInkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1,
                              color: MyColors.black,
                            ),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
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
                    return CustomInkWell(
                      onTap: () {
                        showProductDetailDialog(product);
                      },
                      borderRadius: BorderRadius.zero,
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          color: MyColors.white,
                          child: Center(
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: MyColors.black,
                                        width: 1,
                                      ),
                                    ),
                                    child: CustomText(
                                      text: "${index + 1}",
                                    ),
                                  ),
                                ],
                              ),
                              title: CustomText(
                                text: product["name"] ?? "",
                                fontSize: 16,
                              ),
                              subtitle: CustomText(
                                  text: "Үнэ: ${convertToCurrencyFormat(
                                int.parse(product["price"]),
                              )}"),
                              trailing: CustomText(
                                text: "${product["quantity"]} ширхэг",
                              ),
                            ),
                          )),
                    );
                  },
                ),
                Container(height: 7, color: MyColors.fadedGrey),
                Container(
                  height: Get.height * .09,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: MyColors.white,
                  child: Center(
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CustomText(
                            text: "Нийт үнэ:",
                          ),
                        ],
                      ),
                      trailing: CustomText(
                        text: convertToCurrencyFormat(
                          double.parse(data["storeTotalAmount"]),
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(height: 7, color: MyColors.fadedGrey),
                Container(
                  height: Get.height * .09,
                  padding: EdgeInsets.only(right: 24, left: 24),
                  color: MyColors.white,
                  child: Center(
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const CustomText(
                        text: "Бэлдэх хугацаа:",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomButton(
                            isFullWidth: false,
                            text: _storeCtx.prepDuration.value == 0
                                ? "Сонгох"
                                : "${_storeCtx.prepDuration.value} минут",
                            onPressed: () {
                              Picker(
                                  adapter: NumberPickerAdapter(data: [
                                    NumberPickerColumn(
                                      initValue:
                                          _storeCtx.prepDuration.value == 0
                                              ? 1
                                              : _storeCtx.prepDuration.value,
                                      begin: 1,
                                      end: 60,
                                    ),
                                  ]),
                                  delimiter: [
                                    PickerDelimiter(
                                      child: Container(
                                        width: 50.0,
                                        alignment: Alignment.center,
                                        child: const CustomText(
                                          text: "минут",
                                          isLowerCase: true,
                                        ),
                                      ),
                                    )
                                  ],
                                  hideHeader: true,
                                  title: const CustomText(
                                    text: "Хугацаа сонгох",
                                    fontSize: 18,
                                  ),
                                  looping: true,
                                  smooth: 100,
                                  cancel: Container(),
                                  confirmText: "Сонгох",
                                  confirmTextStyle: const TextStyle(
                                      color: MyColors.black,
                                      fontFamily: "Nunito"),
                                  onConfirm: (Picker picker, List value) {
                                    _storeCtx.prepDuration.value =
                                        picker.getSelectedValues()[0];
                                  }).showDialog(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * .1)
              ],
            ),
          ),
          SizedBox(height: Get.height * 1.15),
          _storeCtx.prepDuration.value != 0
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    height: 60,
                    child: Builder(
                      builder: (contexts) {
                        return SlideAction(
                          height: 60,
                          outerColor: MyColors.black,
                          innerColor: MyColors.primary,
                          elevation: 1,
                          key: slideActionKey,
                          submittedIcon: const Icon(
                            FontAwesomeIcons.check,
                            color: MyColors.white,
                          ),
                          onSubmit: onPressed,
                          alignment: Alignment.centerRight,
                          sliderButtonIcon: const Icon(
                            Icons.double_arrow_rounded,
                            color: MyColors.white,
                          ),
                          sliderButtonIconPadding: 8,
                          child: const Text(
                            "Бэлдэж эхлэх",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Container()
        ],
      ),
    ),
  );
}

Widget storeOrdersToDeliveryBody(context, data, onPressed) {
  return Material(
    color: Colors.white,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
    ),
    child: Container(
      padding: const EdgeInsets.all(24),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(),
                    Column(
                      children: [
                        const CustomText(
                          text: "Захиалгын код:",
                          color: MyColors.gray,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          text: data["orderId"].toString(),
                          color: MyColors.black,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                    CustomInkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 1,
                            color: MyColors.black,
                          ),
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(bottom: Get.height * .1),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
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
                      return CustomInkWell(
                        onTap: () {
                          showProductDetailDialog(product);
                        },
                        child: Container(
                          color: MyColors.white,
                          child: ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: MyColors.black,
                                  width: 1,
                                ),
                              ),
                              child: CustomText(
                                text: "${index + 1}",
                              ),
                            ),
                            title: CustomText(
                              text: product["name"],
                              fontSize: 16,
                            ),
                            subtitle: CustomText(
                                text: convertToCurrencyFormat(
                              int.parse(product["price"]),
                            )),
                            trailing: CustomText(
                                text: "${product["quantity"]} ширхэг"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          data["orderStatus"] == "preparing"
              ? Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: Get.width * .075),
                    width: Get.width,
                    height: 60,
                    child: Builder(
                      builder: (contexts) {
                        return SlideAction(
                          height: 60,
                          outerColor: MyColors.black,
                          innerColor: MyColors.primary,
                          elevation: 0,
                          key: slideActionKey,
                          sliderButtonIconPadding: 8,
                          submittedIcon: const Icon(
                            FontAwesomeIcons.check,
                            color: MyColors.white,
                          ),
                          onSubmit: onPressed,
                          alignment: Alignment.centerRight,
                          sliderButtonIcon: const Icon(
                            Icons.double_arrow_rounded,
                            color: MyColors.white,
                          ),
                          child: const Text(
                            "Хүргэлтэнд гаргах",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Container()
        ],
      ),
    ),
  );
}

Widget notifyToDriversBody() {
  return Dialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
    child: Container(
      width: Get.width * .8,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomInkWell(
                onTap: Get.back,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColors.fadedGrey,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
          Lottie.asset(
            'assets/json/calling.json',
            height: Get.width * .4,
            width: Get.width * .4,
          ),
          const SizedBox(height: 24),
          const CustomText(
            textAlign: TextAlign.center,
            text: "Хамгийн ойрхон байгаа жолоочтой \n холбогдож байна...",
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}

void showProductDetailDialog(data) {
  Get.dialog(Center(
    child: Material(
      color: Colors.transparent,
      child: Container(
        width: Get.width * .9,
        padding:
            const EdgeInsets.only(top: 24, right: 24, left: 24, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImage(
                width: Get.width * .4,
                height: Get.width * .4,
                url: "${URL.AWS}/products/${data["id"]}/small/1.png"),
            const SizedBox(height: 12),
            Text(data["name"]),
            const SizedBox(height: 12),
            _item("Үнэ", data["price"] ?? "", true),
            _item("Авсан үнэ", data["price1"] ?? "0", true),
            _item("Баркод", data["barcode"] ?? "", false),
            _item("Үлдэгдэл", "${data["available"] ?? ""} ширхэг", false),
            const SizedBox(height: 24),
            CustomButton(
              text: "Close",
              isFullWidth: false,
              onPressed: Get.back,
              bgColor: Colors.white,
              textColor: Colors.grey,
              elevation: 0,
            ),
          ],
        ),
      ),
    ),
  ));
}

Widget _item(String title, String text, bool isCurrency) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            isCurrency
                ? convertToCurrencyFormat(
                    double.parse(text),
                  )
                : text,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        )
      ],
    ),
  );
}
