import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image_picker.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreSettingsView extends StatefulWidget {
  const StoreSettingsView({super.key});

  @override
  State<StoreSettingsView> createState() => _StoreSettingsViewState();
}

class _StoreSettingsViewState extends State<StoreSettingsView> {
  TextEditingController storeName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController storeDescription = TextEditingController();

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
              const CustomImagePicker(imageLimit: 1),
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
                controller: storeName,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: Get.height * .05),
              CustomButton(
                isActive: true,
                text: "Хадгалах",
                onPressed: (() {}),
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
