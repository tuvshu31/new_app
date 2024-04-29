import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddressController extends GetxController {
  RxMap selectedSection = {}.obs;
  RxMap selectedLocation = {}.obs;
  RxBool isSectionOk = false.obs;
  RxBool isLocationOk = false.obs;
  RxBool isAddressOk = false.obs;
  RxBool isPhoneOk = false.obs;
  RxBool isEntranceOk = false.obs;
  RxInt totalDeliveryPrice = 0.obs;
  Rx<TextEditingController> phoneController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> entranceController = TextEditingController().obs;
}
