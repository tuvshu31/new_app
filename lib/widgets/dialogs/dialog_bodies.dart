import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/button.dart';

Widget showLogoutDialogBody(dynamic onPressed) {
  return Column(
    children: [
      const Text(
        "Та системээс гарахдаа итгэлтэй байна уу?",
        textAlign: TextAlign.center,
      ),
      SizedBox(height: Get.height * .04),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: CustomButton(
            onPressed: Get.back,
            bgColor: Colors.white,
            text: "Үгүй",
            elevation: 0,
            textColor: Colors.black,
          )),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              elevation: 0,
              bgColor: Colors.amber,
              text: "Тийм",
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget showAccountDeleteDialogBody(dynamic onPressed) {
  return Column(
    children: [
      const Text(
        "Бүртгэлээ устгаснаар таны бүх мэдээлэл апликейшн дээрээс устгагдана. Та бүртгэлээ устгахдаа итгэлтэй байна уу? ",
        textAlign: TextAlign.center,
      ),
      SizedBox(height: Get.height * .04),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: CustomButton(
            onPressed: Get.back,
            bgColor: Colors.white,
            text: "Үгүй",
            elevation: 0,
            textColor: Colors.black,
          )),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              elevation: 0,
              bgColor: Colors.amber,
              text: "Тийм",
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget showNetworkErrorDialogBody(dynamic onPressed) {
  return Column(
    children: [
      const Text(
        "Интернэт холболтоо шалгана уу",
        textAlign: TextAlign.center,
      ),
      SizedBox(height: Get.height * .04),
      CustomButton(
        isFullWidth: false,
        elevation: 0,
        bgColor: Colors.red,
        text: "OK",
        onPressed: () {
          Get.back();
        },
      ),
    ],
  );
}

Widget showAlcoholWarningDialogBody(dynamic onPressed) {
  return Column(
    children: [
      const Text(
        "Хүргэлт хийх үед бичиг баримтаа баталгаажуулахыг анхаарна уу",
        textAlign: TextAlign.center,
      ),
      SizedBox(height: Get.height * .04),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            isFullWidth: false,
            onPressed: Get.back,
            bgColor: Colors.white,
            text: "Үгүй",
            elevation: 0,
            textColor: Colors.black,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              elevation: 0,
              bgColor: Colors.amber,
              text: "Тийм",
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget showNewVersionDialogBody(dynamic onPressed) {
  return Column(
    children: [
      const Text(
        "Аппликейшнд нэмэлт өөрчлөлт орсон тул шинэчлэлт хийх шаардлагатай. Хэрэв шинэчлэлт хийгээгүй тохиолдолд аппликейшнийг бүрэн ашиглах боломжгүйг анхаарна уу.",
        textAlign: TextAlign.center,
      ),
      SizedBox(height: Get.height * .04),
      CustomButton(
        elevation: 0,
        bgColor: Colors.amber,
        text: "Шинэчлэх",
        onPressed: onPressed,
      ),
    ],
  );
}
