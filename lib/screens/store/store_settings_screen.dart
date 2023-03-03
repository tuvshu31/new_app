import 'dart:io';

import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/help_controller.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image_picker.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';

class StoreSettingsScreen extends StatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  dynamic _user = [];
  bool loading = false;
  String imageListBefore = "";
  final _helpCtrl = Get.put(HelpController());
  TextEditingController storeName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController description = TextEditingController();

  void initState() {
    super.initState();
    DefaultCacheManager().emptyCache();
    _helpCtrl.chosenImage.clear();
    getStoreInfo();
  }

  void getStoreInfo() async {
    loading = true;
    dynamic res = await RestApi().getUser(RestApiHelper.getUserId());
    dynamic data = Map<String, dynamic>.from(res);
    setState(() {
      _user = data["data"];
      storeName.text = _user["name"] ?? "";
      phoneNumber.text = _user["phone"] ?? "";
      description.text = _user["description"] ?? "";
    });
    var file = await DefaultCacheManager()
        .getSingleFile("${URL.AWS}/users/${_user["id"]}/small/1.png");
    _helpCtrl.chosenImage.add(file.path);
    loading = false;
    imageListBefore = _helpCtrl.chosenImage.toString();
    setState(() {});
  }

  void submit() async {
    loadingDialog(context);
    if (imageListBefore != _helpCtrl.chosenImage.toString()) {
      if (imageListBefore != [].toString()) {
        await RestApi().deleteImage("users", _user["id"]);
      }
      await RestApi()
          .uploadImage("users", _user["id"], File(_helpCtrl.chosenImage[0]));
    }

    var body = {
      "id": _user["id"],
      "name": storeName.text,
      "phone": phoneNumber.text,
      "description": description.text,
    };
    dynamic product = await RestApi().updateUser(_user["id"], body);
    dynamic data = Map<String, dynamic>.from(product);
    if (data["success"]) {
      Get.back();
      successSnackBar("Амжилттай засагдлаа", 2, context);
    } else {
      Get.back();
      errorSnackBar("Алдаа гарлаа", 2, context);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Тохиргоо",
      customActions: Container(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * .04),
              loading
                  ? MyShimmers().imagePickerShimmer(1)
                  : const CustomImagePicker(imageLimit: 1),
              _title("Дэлгүүрийн нэр"),
              CustomTextField(
                controller: storeName,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              _title("Утасны дугаар"),
              CustomTextField(
                controller: phoneNumber,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              _title("Танилцуулга"),
              CustomTextField(
                controller: description,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: Get.height * .05),
              CustomButton(
                isActive: true,
                text: "Хадгалах",
                onPressed: submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(left: 4),
          child: CustomText(
            text: text,
            fontSize: 12,
            color: MyColors.gray,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
