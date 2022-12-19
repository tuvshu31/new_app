import 'package:Erdenet24/controller/help_controller.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import '../utils/styles.dart';

class CustomListItems extends StatefulWidget {
  final dynamic list;

  CustomListItems({
    required this.list,
    super.key,
  });

  @override
  State<CustomListItems> createState() => _CustomListItemsState();
}

class _CustomListItemsState extends State<CustomListItems> {
  final _helpCtrl = Get.put(HelpController());
  @override
  Widget build(BuildContext context) {
    return CustomHeader(
        title: "Ангилал",
        customActions: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.close),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              ListView.separated(
                separatorBuilder: (context, index) => Container(
                  height: 0.4,
                  width: double.infinity,
                  color: MyColors.grey,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  return CustomInkWell(
                    onTap: () {
                      _helpCtrl.chosenCategory.value = widget.list[index];
                      Get.back();
                    },
                    borderRadius: BorderRadius.circular(0),
                    child: Container(
                      padding: EdgeInsets.all(Get.width * .04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(text: widget.list[index]["name"]),
                          const Icon(
                            IconlyLight.arrow_right_2,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: Get.height * .05)
            ],
          ),
        ));
  }
}
