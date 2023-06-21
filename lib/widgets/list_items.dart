import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/help_controller.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import '../utils/styles.dart';

class CustomListItems extends StatefulWidget {
  final int parentId;

  CustomListItems({
    required this.parentId,
    super.key,
  });

  @override
  State<CustomListItems> createState() => _CustomListItemsState();
}

class _CustomListItemsState extends State<CustomListItems> {
  final _helpCtrl = Get.put(HelpController());
  dynamic categoryList = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    fetchCategory();
  }

  void fetchCategory() async {
    loading = true;
    dynamic categories =
        await RestApi().getCategories({"parentId": widget.parentId});
    dynamic response = Map<String, dynamic>.from(categories);
    if (response["success"]) {
      setState(() {
        categoryList = response["data"];
      });
    }
    loading = false;
    setState(() {});
  }

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
                itemCount: loading ? 6 : categoryList.length,
                itemBuilder: (context, index) {
                  if (loading) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomShimmer(
                        width: double.infinity,
                        height: Get.height * .03,
                      ),
                    );
                  } else {
                    return CustomInkWell(
                      onTap: () {
                        _helpCtrl.chosenCategory.value = categoryList[index];
                        Get.back();
                      },
                      borderRadius: BorderRadius.circular(0),
                      child: Container(
                        padding: EdgeInsets.all(Get.width * .04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(text: categoryList[index]["name"]),
                            const Icon(
                              IconlyLight.arrow_right_2,
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: Get.height * .05)
            ],
          ),
        ));
  }
}
