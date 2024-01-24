import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/image.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

Widget showIncomingOrderDialogBody(onPressed) {
  return WillPopScope(
    onWillPop: () async => false,
    child: Dialog(
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
        )),
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
                url: data["image"]),
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
