import 'package:Erdenet24/api/dio_requests.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/routes.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/screens/store/store_bottom_sheet_views.dart';

int selectedTime = 0;

void notifyToDrivers(data) {
  showDialog(
    context: Get.context!,
    builder: (context) {
      return notifyToDriversBody();
    },
  );
}
