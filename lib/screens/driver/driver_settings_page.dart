import 'dart:developer';

import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class DriverSettingsPage extends StatefulWidget {
  const DriverSettingsPage({super.key});

  @override
  State<DriverSettingsPage> createState() => _DriverSettingsPageState();
}

class _DriverSettingsPageState extends State<DriverSettingsPage> {
  final _driverCtx = Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Тохиргоо",
      customActions: Container(),
      body: Column(
        children: [
          _listTile(
            "Утас",
            _driverCtx.driverInfo["phone"],
            IconlyLight.call,
            true,
          ),
          _listTile(
            "Имэйл хаяг",
            _driverCtx.driverInfo["email"] ?? "@",
            IconlyLight.message,
            true,
          ),
          _listTile(
            "Данс",
            _driverCtx.driverInfo["account"],
            IconlyLight.wallet,
            false,
          ),
          _listTile(
            "Хувийн дугаар",
            _driverCtx.driverInfo["privateNumber"],
            IconlyLight.tick_square,
            false,
          )
        ],
      ),
    );
  }

  Widget _listTile(String title, String value, IconData icon, bool editable) {
    return CustomInkWell(
      onTap: () => editable
          ? Get.to(() => DriverSettingsEditView(
                title: title,
                value: value,
              ))
          : null,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: MyColors.black,
              size: 22,
            ),
          ],
        ),
        title: CustomText(text: title),
        subtitle: CustomText(text: value),
        trailing: editable
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    IconlyLight.arrow_right_2,
                    size: 20,
                    color: MyColors.black,
                  ),
                ],
              )
            : Container(width: 12),
      ),
    );
  }
}

class DriverSettingsEditView extends StatefulWidget {
  final String title;
  final String value;
  const DriverSettingsEditView({
    this.title = "",
    this.value = "",
    super.key,
  });

  @override
  State<DriverSettingsEditView> createState() => _DriverSettingsEditViewState();
}

class _DriverSettingsEditViewState extends State<DriverSettingsEditView> {
  bool isEdited = false;
  final _driverCtx = Get.put(DriverController());
  TextEditingController controller = TextEditingController();
  void updateDriverInfo() {
    var body = {_fieldTitle(widget.title): controller.text};
    _driverCtx.updateDriverInfo(body);
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.value;
  }

  _fieldTitle(String text) {
    switch (text) {
      case "Утас":
        return 'phone';
      case "Имэйл хаяг":
        return 'email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Мэдээлэл засах",
      customActions: Container(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: Get.height * .1, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: widget.title),
              const SizedBox(height: 12),
              CustomTextField(
                autoFocus: true,
                controller: controller,
                onChanged: ((p0) {
                  setState(() {
                    isEdited = p0 != widget.value && p0.length == 8;
                  });
                }),
              ),
              const SizedBox(height: 24),
              CustomButton(
                isActive: isEdited,
                onPressed: updateDriverInfo,
                text: "Хадгалах",
              )
            ],
          ),
        ),
      ),
    );
  }
}
