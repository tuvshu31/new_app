import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:get/get.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController bank = TextEditingController();
  TextEditingController account = TextEditingController();
  final _driverCtx = Get.put(DriverController());
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Профайл",
      customActions: Container(),
      body: Padding(
        padding: EdgeInsets.all(Get.width * .03),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Хувийн мэдээлэл"),
              SizedBox(height: Get.width * .04),
              _item("Овог", _driverCtx.driverInfo["lastName"] ?? "n/a"),
              SizedBox(height: Get.width * .04),
              _item("Нэр", _driverCtx.driverInfo["firstName"] ?? "n/a"),
              SizedBox(height: Get.width * .04),
              _item("Утас", _driverCtx.driverInfo["phone"] ?? "n/a"),
              SizedBox(height: Get.width * .04),
              const Text("Дансны мэдээлэл"),
              const SizedBox(height: 12),
              _item("Банк", _driverCtx.driverInfo["bank"] ?? "n/a"),
              SizedBox(height: Get.width * .04),
              _item("Дансны дугаар", _driverCtx.driverInfo["account"] ?? "n/a"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title:",
          style: const TextStyle(color: MyColors.gray),
        ),
        Text(value)
      ],
    );
  }
}
