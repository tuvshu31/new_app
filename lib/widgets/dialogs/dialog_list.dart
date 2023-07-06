import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:quickalert/quickalert.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_bodies.dart';
import 'package:Erdenet24/screens/user/user_product_detail_screen.dart';

Color _getDialogColors(DialogType dialogType) {
  switch (dialogType) {
    case DialogType.error:
      return Colors.red;
    case DialogType.warning:
      return Colors.amber;
    case DialogType.success:
    default:
      return Colors.red;
  }
}

String _getDialogTitle(DialogType dialogType) {
  switch (dialogType) {
    case DialogType.error:
      return "Уучлаарай";
    case DialogType.warning:
      return "Анхааруулга";
    case DialogType.success:
      return "Амжилттай";
    default:
      return "Уучлаарай";
  }
}

void customDialog(DialogType dialogType, Widget body) {
  showGeneralDialog(
    context: Get.context!,
    barrierLabel: "",
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (ctx, a1, a2) {
      return Container();
    },
    transitionBuilder: (ctx, a1, a2, child) {
      var curve = Curves.bounceInOut.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: Center(
          child: Container(
            width: Get.width,
            margin: EdgeInsets.all(Get.width * .09),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            padding: EdgeInsets.only(
              right: Get.width * .09,
              left: Get.width * .09,
              top: Get.height * .04,
              bottom: Get.height * .03,
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    IconlyBold.info_circle,
                    size: Get.width * .15,
                    color: _getDialogColors(dialogType),
                  ),
                  SizedBox(height: Get.height * .02),
                  Text(
                    _getDialogTitle(dialogType),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyColors.gray,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: Get.height * .02),
                  body,
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class CustomDialogs {
  void showLoadingDialog() {
    showGeneralDialog(
      context: Get.context!,
      barrierLabel: "",
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.bounceInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: showLoadingDialogBody(),
        );
      },
    );
  }

  void showLogoutDialog(dynamic onPressed) {
    customDialog(
      DialogType.warning,
      showLogoutDialogBody(onPressed),
    );
  }

  void showAccountDeleteDialog(dynamic onPressed) {
    customDialog(
      DialogType.warning,
      showAccountDeleteDialogBody(onPressed),
    );
  }

  void showNetworkErrorDialog(dynamic onPressed) {
    customDialog(
      DialogType.error,
      showNetworkErrorDialogBody(onPressed),
    );
  }

  void showSameStoreProductsDialog(dynamic onPressed) {
    customDialog(
      DialogType.warning,
      showSameStoreProductsDialogBody(onPressed),
    );
  }

  void showNotAvailableProductsDialog(
      List availableZeroProducts, dynamic onPressed) {
    customDialog(
      DialogType.error,
      showNotAvailableProductsDialogBody(availableZeroProducts, onPressed),
    );
  }
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
              child: CachedImage(
                  image: "${URL.AWS}/products/${data["id"]}/small/1.png")),
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

// void QarningDialog(BuildContext context, String text) async {
//   showGeneralDialog(
//     context: context,
//     barrierLabel: "",
//     barrierDismissible: false,
//     transitionDuration: const Duration(milliseconds: 400),
//     pageBuilder: (ctx, a1, a2) {
//       return Container();
//     },
//     transitionBuilder: (ctx, a1, a2, child) {
//       var curve = Curves.bounceInOut.transform(a1.value);
//       return Transform.scale(
//         scale: curve,
//         child: Center(
//           child: Container(
//             width: Get.width,
//             margin: EdgeInsets.all(Get.width * .09),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: Colors.white,
//             ),
//             padding: EdgeInsets.only(
//               right: Get.width * .09,
//               left: Get.width * .09,
//               top: Get.height * .04,
//               bottom: Get.height * .03,
//             ),
//             child:
//           ),
//         ),
//       );
//     },
//   );
// }

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

// void accountDeleteModal(dynamic context, dynamic onTap) {
//   QuickAlert.show(
//       context: context,
//       animType: QuickAlertAnimType.slideInDown,
//       widget: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: const [
//           SizedBox(height: 8),
//           CustomText(
//             textAlign: TextAlign.center,
//             text:
//                 "Бүртгэлээ устгаснаар таны бүх мэдээлэл апликейшн дээрээс устгагдахыг анхаарна уу",
//             fontSize: 14,
//             color: MyColors.gray,
//           )
//         ],
//       ),
//       title: "Бүртгэлээ устгах уу?",
//       confirmBtnColor: MyColors.warning,
//       type: QuickAlertType.info,
//       showCancelBtn: true,
//       onCancelBtnTap: Get.back,
//       cancelBtnText: "Болих",
//       onConfirmBtnTap: onTap,
//       confirmBtnText: "Устгах",
//       cancelBtnTextStyle: TextStyle(
//         fontSize: 14,
//         color: MyColors.gray,
//         fontWeight: FontWeight.bold,
//       ),
//       confirmBtnTextStyle: TextStyle(
//         color: MyColors.white,
//         fontSize: 14,
//         fontWeight: FontWeight.bold,
//       ));
// }

void driverDeliveryCodeApproveDialog(
    dynamic context, TextEditingController controller, dynamic onTap) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.custom,
    barrierDismissible: true,
    customAsset: 'assets/images/png/app/webp.webp',
    showCancelBtn: false,
    cancelBtnText: "Болих",
    onConfirmBtnTap: onTap,
    confirmBtnText: "Баталгаажуулах",
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
    widget: CustomTextField(
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      maxLength: 4,
      autoFocus: true,
      controller: controller,
      hintText: "4 оронтой код оруулна уу",
    ),
  );
}

void showAwesomDialog(context) {
  AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    // dialogType: DialogType.info,
    customHeader: Container(
      padding: const EdgeInsets.all(12),
      child: Image.asset(
        "assets/images/png/app/exclamation.png",
      ),
    ),
    body: Column(
      children: const [
        Text("Анхааруулга"),
        Text(
          'If the body is specified, then title and description will be ignored, this allows to 											further customize the dialogue.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    ),
    title: 'This is Ignored',
    desc: 'This is also Ignored',
    btnOkOnPress: () {},
    btnOkColor: Colors.redAccent,
    btnOkText: "Шинэчлэх",
  ).show();
}

// final player = AudioCache();
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
    barrierDismissible: false,
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
              'Таны захиалгыг хүлээн авлаа. Миний захиалга хэсгээс хүргэлтийн мэдээллийг харах боломжтой.',
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
