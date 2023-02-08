import 'dart:developer';

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
  List settingsList = [
    {
      "icon": IconlyLight.call,
      "name": "Утас",
      "value": "99921312",
      "editable": true,
      "type": "number"
    },
    {
      "icon": IconlyLight.message,
      "name": "Имэйл",
      "value": "eet12@gmail.com",
      "editable": true,
      "type": "text",
    },
    {
      "icon": IconlyLight.lock,
      "name": "Нууц үг",
      "value": "******",
      "editable": true,
      "type": "password",
    },
    {
      "icon": IconlyLight.wallet,
      "name": "Данс",
      "value": "5020405012",
      "editable": false,
      "type": "text",
    },
    {
      "icon": IconlyLight.tick_square,
      "name": "Хувийн дугаар",
      "value": "1234",
      "editable": false,
      "type": "text"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Тохиргоо",
      customActions: Container(),
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          // padding: const EdgeInsets.symmetric(horizontal: 12),
          shrinkWrap: true,
          itemCount: settingsList.length,
          itemBuilder: (context, index) {
            var data = settingsList[index];
            return CustomInkWell(
              borderRadius: BorderRadius.zero,
              onTap: () {
                data["editable"]
                    ? Get.to(
                        () => DriverSettingsEditView(
                          data: data,
                        ),
                      )
                    : null;
              },
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      data["icon"],
                      color: MyColors.black,
                      size: 22,
                    ),
                  ],
                ),
                title: CustomText(text: data["name"]),
                subtitle: CustomText(text: data["value"]),
                trailing: data["editable"]
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
          }),
    );
  }
}

class DriverSettingsEditView extends StatefulWidget {
  final dynamic data;
  const DriverSettingsEditView({this.data, super.key});

  @override
  State<DriverSettingsEditView> createState() => _DriverSettingsEditViewState();
}

class _DriverSettingsEditViewState extends State<DriverSettingsEditView> {
  bool isEdited = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.data["value"];
    log(widget.data.toString());
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
              CustomText(text: widget.data["name"]),
              const SizedBox(height: 12),
              CustomTextField(
                suffixButton: widget.data["type"] == "password"
                    ? Icon(IconlyLight.lock)
                    : Icon(IconlyLight.unlock),
                autoFocus: true,
                controller: controller,
                onChanged: ((p0) {
                  setState(() {
                    isEdited = p0 != widget.data["value"];
                  });
                }),
              ),
              const SizedBox(height: 24),
              CustomButton(
                isActive: isEdited,
                onPressed: () {},
                text: "Хадгалах",
              )
            ],
          ),
        ),
      ),
    );
  }
}
