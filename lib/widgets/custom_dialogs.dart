import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'button.dart';

class CustomDialogs {
  Future<dynamic> showDialog(BuildContext context, Widget content) async {
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
          child: content,
          // _moreDialogBody(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static Future<dynamic> showSuccessDialog(bool isSuccess, String middleText) {
    // final player = AudioCache();
    // player
    //     .play(isSuccess ? "sounds/success_bell.wav" : "sounds/error_bell.wav");
    return Get.dialog(successdDialogBody(isSuccess, middleText),
        barrierDismissible: false);
  }

  // Future showLoadingDialog(dynamic context) {
  //   return showDialog(context, _loadingdDialogBody());
  // }

  Future showTestingInfoDialog(dynamic context) {
    return showDialog(context, _showTestingVersionWarningBody());
  }

  Future showLogoutDialog(dynamic context, dynamic onTap) {
    return showDialog(context, _logoutWarningBody(onTap));
  }

  Future showCustomDialog(dynamic context, dynamic body) {
    return showDialog(context, _customDialogBody(body));
  }
}

Widget successdDialogBody(bool isSuccess, String middleText) {
  return WillPopScope(
      onWillPop: () async => false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.all(40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width * .2,
                    height: Get.width * .2,
                    decoration: BoxDecoration(
                        color: isSuccess ? MyColors.green : MyColors.primary,
                        borderRadius: BorderRadius.circular(50)),
                    child: Icon(
                      isSuccess
                          ? FontAwesomeIcons.check
                          : FontAwesomeIcons.times,
                      color: MyColors.white,
                      size: 34,
                    ),
                  ),
                  SizedBox(height: Get.height * .03),
                  CustomText(
                    text: isSuccess ? "Амжилттай" : "Уучлаарай",
                    fontSize: MyFontSizes.large,
                    color: isSuccess ? MyColors.green : MyColors.primary,
                  ),
                  SizedBox(height: Get.height * .02),
                  CustomText(
                    text: middleText,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Get.height * .04),
                  SizedBox(
                    width: Get.width * .3,
                    child: CustomButton(
                      isActive: true,
                      cornerRadius: 50,
                      text: "Хаах",
                      textFontWeight: FontWeight.normal,
                      isFullWidth: true,
                      onPressed: () => Get.back(),
                      bgColor: isSuccess ? MyColors.green : MyColors.primary,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ));
}

Widget _showTestingVersionWarningBody() {
  return AlertDialog(
    // backgroundColor: Theme.of(context).ba
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: Get.height * .02),
        Image(
          image: AssetImage("assets/images/png/app/warning.png"),
          width: Get.width * .25,
        ),
        SizedBox(height: Get.height * .05),
        CustomText(
          textAlign: TextAlign.center,
          text: "Туршилтын хувилбар тул захиалга хийгдэхгүйг анхаарна уу",
          fontSize: 14,
        ),
        SizedBox(height: Get.height * .05),
        SizedBox(
          width: Get.width * .3,
          child: CustomButton(
            bgColor: MyColors.warning,
            text: "Хаах",
            onPressed: () => Get.back(),
            isFullWidth: false,
          ),
        )
      ],
    ),
  );
}

Widget _logoutWarningBody(dynamic onTap) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    title: Container(
      color: MyColors.background,
      height: Get.height * .1,
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: Get.height * .02),
        Container(
          width: double.infinity,
          color: MyColors.primary,
        ),
        // Container(
        //   padding: const EdgeInsets.all(12),
        //   decoration:
        //       BoxDecoration(color: MyColors.fadedGrey, shape: BoxShape.circle),
        //   child: Image(
        //     image: const AssetImage("assets/images/png/app/dial.png"),
        //     width: Get.width * .15,
        //   ),
        // ),
        SizedBox(height: Get.height * .02),
        const CustomText(
            textAlign: TextAlign.center, text: "Нэвтрэх эрхээ сонгоно уу"),
        SizedBox(height: Get.height * .02),
        RadioListTile(
          dense: true,
          activeColor: MyColors.primary,
          value: true,
          groupValue: true,
          onChanged: ((value) {}),
          title: const CustomText(
            text: "Хэрэглэгч",
            fontSize: 14,
          ),
        ),
        RadioListTile(
          dense: true,
          activeColor: MyColors.primary,
          value: false,
          groupValue: true,
          onChanged: ((value) {}),
          title: const CustomText(
            text: "Байгууллага",
            fontSize: 14,
          ),
        ),
        SizedBox(height: Get.height * .03),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomButton(
              bgColor: MyColors.primary,
              text: "Нэвтрэх",
              onPressed: onTap,
              isFullWidth: false,
            ),
          ],
        )
      ],
    ),
  );
}

Widget _customDialogBody(dynamic body) {
  return AlertDialog(
      // backgroundColor: Theme.of(context).ba
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: body);
}
