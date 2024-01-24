import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/custom_loading_widget.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreSettingsScreen extends StatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  Map data = {};
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getStoreInfo();
  }

  void getStoreInfo() async {
    loading = true;
    setState(() {});
    dynamic getStoreInfo = await StoreApi().getStoreInfo();
    loading = false;
    setState(() {});
    if (getStoreInfo != null) {
      dynamic response = Map<String, dynamic>.from(getStoreInfo);
      if (response["success"]) {
        data = response["data"];
        nameController.text = data["name"] ?? "";
        phoneController.text = data["phone"] ?? "";
        descriptionController.text = data["description"] ?? "";
        setState(() {});
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Тохиргоо",
      customActions: Container(),
      body: loading
          ? customLoadingWidget()
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Get.height * .02),
                  CircleAvatar(
                    backgroundImage: NetworkImage(data["image"]),
                    radius: Get.width * .1,
                  ),
                  _infoWidget("Дэлгүүрийн нэр", nameController),
                  _infoWidget("Утасны дугаар", phoneController),
                  _infoWidget("Танилцуулга", descriptionController),
                  const SizedBox(height: 24),
                  CustomButton(
                    isActive: false,
                    text: "Хадгалах",
                    onPressed: () {},
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoWidget(
    String title,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.only(left: 4),
          child: CustomText(
            text: title,
            fontSize: 12,
            color: MyColors.gray,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: controller,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
