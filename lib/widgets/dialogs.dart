import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:quickalert/quickalert.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Erdenet24/widgets/text.dart';

final player = AudioCache();
String message = "Hello";
late AnimationController localAnimationController;
void showLoadingDialog() {
  WillPopScope(
      onWillPop: () async => false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Material(
            color: Colors.transparent,
            child: Center(
              child: SpinKitCircle(
                color: MyColors.white,
                size: 45,
              ),
            ),
          ),
        ],
      ));
}

void successOrderModal(context, onTap) {
  // player.play("sounds/success_bell.wav");
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    title: "Амжилттай",
    showCancelBtn: false,
    confirmBtnColor: MyColors.green,
    confirmBtnTextStyle: TextStyle(
      fontSize: 14,
      color: MyColors.white,
      fontWeight: FontWeight.bold,
    ),
    cancelBtnTextStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: MyColors.gray,
    ),
    onConfirmBtnTap: onTap,
    confirmBtnText: "Okey",
    widget: Column(
      children: [
        SizedBox(height: 6),
        CustomText(
          text:
              'Таны захиалгыг хүлээн авлаа. Миний захиалгууд хэсгээс хүргэлтийн явцыг харах боломжтой.',
          fontSize: 14,
          color: MyColors.gray,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

void warningModal(String text, int duration, dynamic context) {
  QuickAlert.show(
    context: context,
    animType: QuickAlertAnimType.slideInDown,
    widget: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          textAlign: TextAlign.center,
          text: "Туршилтын хувилбар тул захиалга хийгдэхгүйг анхаарна уу",
          fontSize: 14,
        )
      ],
    ),
    title: "Уучлаарай...",
    confirmBtnColor: MyColors.warning,
    type: QuickAlertType.warning,
  );
}

void errorModal(String text, int duration, dynamic context) {
  QuickAlert.show(
    context: context,
    animType: QuickAlertAnimType.slideInDown,
    widget: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          textAlign: TextAlign.center,
          text: "Туршилтын хувилбар тул захиалга хийгдэхгүйг анхаарна уу",
          fontSize: 14,
        )
      ],
    ),
    title: "Уучлаарай...",
    confirmBtnColor: MyColors.warning,
    type: QuickAlertType.error,
  );
}

void testingVersionModal(dynamic context) {
  QuickAlert.show(
    context: context,
    animType: QuickAlertAnimType.slideInDown,
    widget: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          textAlign: TextAlign.center,
          text: "Туршилтын хувилбар тул захиалга хийгдэхгүйг анхаарна уу",
          fontSize: 14,
        )
      ],
    ),
    title: "Уучлаарай...",
    confirmBtnColor: MyColors.warning,
    type: QuickAlertType.info,
  );
}

void customModal(String text, int duration, dynamic context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.custom,
    barrierDismissible: true,
    confirmBtnText: 'Save',
    customAsset: 'assets/images/png/app/webp.webp',
    widget: TextFormField(
      decoration: const InputDecoration(
        alignLabelWithHint: true,
        hintText: 'Enter Phone Number',
        prefixIcon: Icon(
          Icons.phone_outlined,
        ),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.phone,
      onChanged: (value) {},
    ),
    onConfirmBtnTap: () async {
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        text: 'Please input something',
      );

      Navigator.pop(context);
      await Future.delayed(const Duration(milliseconds: 1000));
      await QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: "Phone number '$message' has been saved!.",
      );
    },
  );
}

void loadingModal(String text, int duration, dynamic context) {
  QuickAlert.show(
    context: context,
    animType: QuickAlertAnimType.slideInDown,
    widget: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          textAlign: TextAlign.center,
          text: "Туршилтын хувилбар тул захиалга хийгдэхгүйг анхаарна уу",
          fontSize: 14,
        )
      ],
    ),
    title: "Уучлаарай...",
    confirmBtnColor: MyColors.warning,
    type: QuickAlertType.loading,
  );
}

void closeStoreModal(dynamic context, String title, String content,
    String confirmText, dynamic onTap) {
  QuickAlert.show(
      context: context,
      animType: QuickAlertAnimType.slideInDown,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          CustomText(
            textAlign: TextAlign.center,
            text: content,
            fontSize: 14,
            color: MyColors.gray,
          )
        ],
      ),
      title: title,
      confirmBtnColor: MyColors.warning,
      type: QuickAlertType.info,
      showCancelBtn: true,
      cancelBtnText: "Болих",
      onConfirmBtnTap: onTap,
      confirmBtnText: confirmText,
      cancelBtnTextStyle: TextStyle(
        fontSize: 14,
        color: MyColors.gray,
        fontWeight: FontWeight.bold,
      ),
      confirmBtnTextStyle: TextStyle(
        color: MyColors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ));
}

void logOutModal(dynamic context, dynamic onTap) {
  QuickAlert.show(
      context: context,
      animType: QuickAlertAnimType.slideInDown,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          CustomText(
            textAlign: TextAlign.center,
            text: "Та аппаас гарахдаа итгэлтэй байна уу?",
            fontSize: 14,
            color: MyColors.gray,
          )
        ],
      ),
      title: "Аппаас гарах уу?",
      confirmBtnColor: MyColors.warning,
      type: QuickAlertType.info,
      showCancelBtn: true,
      cancelBtnText: "Болих",
      onConfirmBtnTap: onTap,
      confirmBtnText: "Гарах",
      cancelBtnTextStyle: TextStyle(
        fontSize: 14,
        color: MyColors.gray,
        fontWeight: FontWeight.bold,
      ),
      confirmBtnTextStyle: TextStyle(
        color: MyColors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ));
}

void loginTypeModal(dynamic context, dynamic onTap) {
  // QuickAlert.show(
  //     context: context,
  //     animType: QuickAlertAnimType.slideInDown,
  //     widget: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         RadioListTile(
  //             value: () {},
  //             groupValue: () {},
  //             onChanged: (val) {},
  //             title: CustomText(text: "Хэрэглэгч")),
  //         RadioListTile(
  //             value: () {},
  //             groupValue: () {},
  //             onChanged: (val) {},
  //             title: CustomText(text: "Байгууллага"))
  //       ],
  //     ),
  //     title: "Нэвтрэх төрлөө сонгоно уу",
  //     confirmBtnColor: MyColors.warning,
  //     type: QuickAlertType.confirm,
  //     showCancelBtn: true,
  //     cancelBtnText: "Болих",
  //     onConfirmBtnTap: onTap,
  //     confirmBtnText: "Гарах",
  //     cancelBtnTextStyle: TextStyle(
  //       fontSize: 14,
  //       color: MyColors.gray,
  //       fontWeight: FontWeight.bold,
  //     ),
  //     confirmBtnTextStyle: TextStyle(
  //       color: MyColors.white,
  //       fontSize: 14,
  //       fontWeight: FontWeight.bold,
  //     ));
}

void changeLeftOverCount(
    dynamic context, dynamic data, dynamic controller, dynamic onTap) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.custom,
    barrierDismissible: true,
    customAsset: 'assets/images/png/app/webp.webp',
    showCancelBtn: true,
    cancelBtnText: "Болих",
    onConfirmBtnTap: onTap,
    confirmBtnText: "Өөрчлөх",
    confirmBtnColor: MyColors.green,
    cancelBtnTextStyle: TextStyle(
      fontSize: 14,
      color: MyColors.gray,
      fontWeight: FontWeight.bold,
    ),
    confirmBtnTextStyle: TextStyle(
      color: MyColors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    widget: Column(
      children: [
        ListTile(
          leading: Container(
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child:
                  CachedImage(image: "${URL.AWS}/products/${data["id"]}.png")),
          title: CustomText(text: data["name"]),
          subtitle: Row(
            children: [
              const CustomText(text: "Үлдэгдэл: ", fontSize: 12),
              const SizedBox(width: 4),
              SizedBox(
                width: Get.width * .2,
                child: CustomTextField(
                  controller: controller,
                  hintText: data["available"],
                  autoFocus: true,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    // onConfirmBtnTap: () async {
    // await QuickAlert.show(
    //   context: context,
    //   type: QuickAlertType.error,
    //   text: 'Please input something',
    // );

    // Navigator.pop(context);
    // await Future.delayed(const Duration(milliseconds: 1000));
    // await QuickAlert.show(
    //   context: context,
    //   type: QuickAlertType.success,
    //   text: "Phone number '$message' has been saved!.",
    // );
    // },
  );
}

void deleteProduct(dynamic context, dynamic data, dynamic onTap) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.custom,
    barrierDismissible: true,
    customAsset: 'assets/images/png/app/webp.webp',
    showCancelBtn: true,
    cancelBtnText: "Болих",
    onConfirmBtnTap: onTap,
    confirmBtnText: "Устгах",
    confirmBtnColor: MyColors.green,
    cancelBtnTextStyle: TextStyle(
      fontSize: 14,
      color: MyColors.gray,
      fontWeight: FontWeight.bold,
    ),
    confirmBtnTextStyle: TextStyle(
      color: MyColors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    ),
    widget: ListTile(
      leading: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: CachedImage(image: "${URL.AWS}/products/${data["id"]}.png")),
      title: CustomText(text: data["name"]),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: data["price"]),
          CustomText(text: "Үлдэгдэл: ${data["available"]}", fontSize: 12),
        ],
      ),
    ),
    // onConfirmBtnTap: () async {
    // await QuickAlert.show(
    //   context: context,
    //   type: QuickAlertType.error,
    //   text: 'Please input something',
    // );

    // Navigator.pop(context);
    // await Future.delayed(const Duration(milliseconds: 1000));
    // await QuickAlert.show(
    //   context: context,
    //   type: QuickAlertType.success,
    //   text: "Phone number '$message' has been saved!.",
    // );
    // },
  );
}

void loadingDialog(BuildContext context) async {
  showGeneralDialog(
    context: context,
    barrierLabel: "",
    barrierDismissible: true,
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.bounceInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: Center(
          child: CircularProgressIndicator(
            color: MyColors.white,
          ),
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

void delvieryCostWarningModal(dynamic context, dynamic onTap) {
  QuickAlert.show(
      context: context,
      animType: QuickAlertAnimType.slideInDown,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          CustomText(
            textAlign: TextAlign.center,
            text:
                "Өөр дэлгүүрээс худалдан авалт хийсэн тохиолдолд хүргэлтийн төлбөр нэмэгдэж тооцогдохыг анхаарна уу",
            fontSize: 14,
            color: MyColors.gray,
          )
        ],
      ),
      title: "Анхаар",
      confirmBtnColor: MyColors.warning,
      type: QuickAlertType.info,
      showCancelBtn: false,
      cancelBtnText: "Болих",
      onConfirmBtnTap: onTap,
      confirmBtnText: "Okey",
      cancelBtnTextStyle: TextStyle(
        fontSize: 14,
        color: MyColors.gray,
        fontWeight: FontWeight.bold,
      ),
      confirmBtnTextStyle: TextStyle(
        color: MyColors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ));
}

void accountDeleteModal(dynamic context, dynamic onTap) {
  QuickAlert.show(
      context: context,
      animType: QuickAlertAnimType.slideInDown,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          SizedBox(height: 8),
          CustomText(
            textAlign: TextAlign.center,
            text:
                "Бүртгэлээ устгаснаар таны бүх мэдээлэл апликейшн дээрээс устгагдахыг анхаарна уу",
            fontSize: 14,
            color: MyColors.gray,
          )
        ],
      ),
      title: "Бүртгэлээ устгах уу?",
      confirmBtnColor: MyColors.warning,
      type: QuickAlertType.info,
      showCancelBtn: true,
      onCancelBtnTap: Get.back,
      cancelBtnText: "Болих",
      onConfirmBtnTap: onTap,
      confirmBtnText: "Устгах",
      cancelBtnTextStyle: TextStyle(
        fontSize: 14,
        color: MyColors.gray,
        fontWeight: FontWeight.bold,
      ),
      confirmBtnTextStyle: TextStyle(
        color: MyColors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ));
}
