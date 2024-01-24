import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/custom_loading_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_bodies.dart';

Color _getDialogColors(ActionType actionType) {
  switch (actionType) {
    case ActionType.error:
      return Colors.red;
    case ActionType.warning:
      return Colors.amber;
    case ActionType.success:
    default:
      return Colors.red;
  }
}

String _getDialogTitle(ActionType actionType) {
  switch (actionType) {
    case ActionType.error:
      return "Уучлаарай";
    case ActionType.warning:
      return "Анхааруулга";
    case ActionType.success:
      return "Амжилттай";
    default:
      return "Уучлаарай";
  }
}

void customDialog(ActionType ActionType, Widget body, {onWillPop = true}) {
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
      return WillPopScope(
        onWillPop: () async => onWillPop,
        child: Transform.scale(
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
                      color: _getDialogColors(ActionType),
                    ),
                    SizedBox(height: Get.height * .02),
                    Text(
                      _getDialogTitle(ActionType),
                      style: const TextStyle(
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
          child: customLoadingWidget(),
        );
      },
    );
  }

  void showLogoutDialog(dynamic onPressed) {
    customDialog(
      ActionType.warning,
      showLogoutDialogBody(onPressed),
    );
  }

  void showAccountDeleteDialog(dynamic onPressed) {
    customDialog(
      ActionType.warning,
      showAccountDeleteDialogBody(onPressed),
    );
  }

  void showNetworkErrorDialog(dynamic onPressed) {
    customDialog(
      ActionType.error,
      showNetworkErrorDialogBody(onPressed),
    );
  }

  void showAlcoholWarningDialog(dynamic onPressed, {onWillPop = true}) {
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
        return WillPopScope(
          onWillPop: () async => onWillPop,
          child: Transform.scale(
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
                        color: Colors.amber,
                      ),
                      SizedBox(height: Get.height * .02),
                      const Text(
                        "Та +21 нас хүрсэн үү?",
                        style: TextStyle(
                          color: MyColors.gray,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: Get.height * .02),
                      showAlcoholWarningDialogBody(onPressed),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showNewVersionDialog(dynamic onPressed) {
    customDialog(
      ActionType.warning,
      showNewVersionDialogBody(onPressed),
      onWillPop: false,
    );
  }

  void showDriverAuthDialog(dynamic onPressed) {
    customDialog(
      ActionType.warning,
      showNewVersionDialogBody(onPressed),
      onWillPop: false,
    );
  }
}

void driverDeliveryCodeApproveDialog(
    TextEditingController controller, dynamic onTap) {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async =>
            false, // False will prevent and true will allow to dismiss
        child: AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          title: const Text(
            'Захиалгын код',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actionsPadding: const EdgeInsets.only(bottom: 14),
          actionsAlignment: MainAxisAlignment.center,
          content: CustomTextField(
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            maxLength: 4,
            autoFocus: true,
            controller: controller,
            hintText: "4 оронтой код оруулна уу",
          ),
          actions: <Widget>[
            CustomButton(
              isFullWidth: false,
              text: "Баталгаажуулах",
              onPressed: onTap,
            ),
          ],
        ),
      );
    },
  );
}

// final player = AudioCache();
String message = "Hello";
late AnimationController localAnimationController;

void showCustomDialog(
    ActionType actionType, String title, VoidCallback onPressed,
    {bool onWillPop = true}) {
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
      return WillPopScope(
        onWillPop: () async => onWillPop,
        child: Transform.scale(
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
                      color: _getDialogColors(actionType),
                    ),
                    SizedBox(height: Get.height * .02),
                    Text(
                      _getDialogTitle(actionType),
                      style: const TextStyle(
                        color: MyColors.gray,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: Get.height * .02),
                    Column(
                      children: [
                        Text(
                          title,
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
                                bgColor: _getDialogColors(actionType),
                                text: "Тийм",
                                onPressed: onPressed,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
