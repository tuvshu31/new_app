import 'dart:developer';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/controller/store_controller.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:Erdenet24/screens/store/store_bottom_sheet_views.dart';

final _storeCtx = Get.put(StoreController());
int selectedTime = 0;

void showOrdersSetTimeView(context, data) {
  Get.bottomSheet(
    showOrdersSetTimeViewBody(
      context,
      data,
      () {
        Future.delayed(const Duration(milliseconds: 300), () {
          slideActionKey.currentState!.reset();
          CustomDialogs().showLoadingDialog();
          var body = {
            "orderStatus": "preparing",
            "prepDuration": _storeCtx.prepDuration.value.toString(),
          };
          _storeCtx.updateOrder(data["id"], body);
          Get.back();
          data["orderStatus"] = "preparing";
          data["prepDuration"] = _storeCtx.prepDuration.value.toString();
          _storeCtx.filterOrders(0);
          _storeCtx.startTimer(Duration(minutes: _storeCtx.prepDuration.value));
          _storeCtx.prepDuration.value = 0;
          Get.back();
          Get.toNamed(storeOrdersScreenRoute);
        });
      },
    ),
  );
}

void storeOrdersToDelivery(context, data) {
  Get.bottomSheet(storeOrdersToDeliveryBody(context, data, () {
    Future.delayed(
      const Duration(milliseconds: 300),
      () async {
        slideActionKey.currentState!.reset();
        Get.back();
        CustomDialogs().showLoadingDialog();
        dynamic req = await RestApi().checkDriverAccepted(data["id"]);
        Get.back();
        if (req != null) {
          dynamic reqResponse = Map<String, dynamic>.from(req);
          if (reqResponse["driverAccepted"]) {
            customSnackbar(DialogType.error,
                "Хүргэлтийн жолооч ирж байгаа тул түр хүлээнэ үү", 4);
          } else {
            dynamic response = await RestApi().assignDriver(data["id"]);
            dynamic d = Map<String, dynamic>.from(response);
            if (d["success"]) {
              notifyToDrivers(data);
            }
          }
        }
      },
    );
  }));
}

void notifyToDrivers(data) {
  showDialog(
    context: Get.context!,
    builder: (context) {
      return notifyToDriversBody();
    },
  );
}

void saveIcomingOrder(context, data) {
  CustomDialogs().showLoadingDialog();
  AwesomeNotifications().dismiss(1);
  var body = {"orderStatus": "received"};
  _storeCtx.updateOrder(data["id"], body);
  data["orderStatus"] = "received";
  _storeCtx.storeOrderList.insert(0, data);
  _storeCtx.filterOrders(0);
  Get.back();
}

void showIncomingOrderDialog(context) {
  _storeCtx.playSound("incoming", loop: true);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return showIncomingOrderDialogBody(() {
        _storeCtx.stopSound();
        Get.back();
        Get.toNamed(storeOrdersScreenRoute);
      });
    },
  );
}
