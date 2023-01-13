import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/controller/help_controller.dart';
import 'package:Erdenet24/screens/store/edit_products/create_product.dart';
import 'package:Erdenet24/screens/user/home/product_screen.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image_picker.dart';
import 'package:Erdenet24/widgets/list_items.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class EditProductInfo extends StatefulWidget {
  const EditProductInfo({super.key});

  @override
  State<EditProductInfo> createState() => _EditProductInfoState();
}

class _EditProductInfoState extends State<EditProductInfo> {
  final _incoming = Get.arguments;
  final _helpCtrl = Get.put(HelpController());
  TextEditingController productName = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  TextEditingController productCount = TextEditingController();
  var controllerList = <TextEditingController>[];
  dynamic otherInfo = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    prepareScreen();
    _incoming["otherInfo"].isNotEmpty
        ? _incoming["otherInfo"].forEach((el) {
            var controller = TextEditingController();
            controllerList.add(controller);
          })
        : null;
    productName.text = _incoming["name"] ?? "";
    productPrice.text = _incoming["price"] ?? "";
    productCount.text = _incoming["available"] ?? "";
  }

  void prepareScreen() async {
    _helpCtrl.chosenImage.clear();
    loading = true;
    dynamic response = await RestApi().getProductImgCount(_incoming["id"]);
    dynamic d = Map<String, dynamic>.from(response);
    if (d["success"]) {
      var list = List<int>.generate(d["data"], (i) => i + 1);
      for (var element in list) {
        var file = await DefaultCacheManager().getSingleFile(
            "${URL.AWS}/products/${_incoming["id"]}/small/$element.png");
        _helpCtrl.chosenImage.add(file.path);
        DefaultCacheManager().removeFile(file.path);
      }
    }
    dynamic res =
        await RestApi().getCategory(int.parse(_incoming["categoryId"]));
    dynamic data = Map<String, dynamic>.from(res);
    if (data["success"]) {
      setState(() {
        _helpCtrl.chosenCategory.value = data["data"];
        print(_helpCtrl.chosenCategory);
      });
    }

    loading = false;
    setState(() {});
  }

  // void generateOtherInfo() {
  //   otherInfo.clear();
  //   for (int i = 0; i < _helpCtrl.chosenCategory["descriptions"].length; i++) {
  //     var item = {
  //       _helpCtrl.chosenCategory["descriptions"][i]: controllerList[i].text
  //     };
  //     otherInfo.add(item);
  //     setState(() {});
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomHeader(
        title: "Барааны мэдээлэл засах",
        customActions: Container(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * .02),
                loading
                    ? MyShimmers().imagePickerShimmer()
                    : CustomImagePicker(imageLimit: 6),
                _title("Барааны нэр"),
                CustomTextField(
                  controller: productName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                _title("Үнэ"),
                CustomTextField(
                  controller: productPrice,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                _title("Тоо ширхэг"),
                CustomTextField(
                  controller: productCount,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                ),
                _title("Ангилал"),
                GestureDetector(
                  onTap: () {
                    Get.to(CustomListItems(
                      parentId: int.parse(_incoming["typeId"]),
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: MyColors.white,
                        border: Border.all(
                          width: 0.7,
                          color: MyColors.grey,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: _helpCtrl.chosenCategory["name"],
                        ),
                        const Icon(
                          IconlyLight.arrow_right_2,
                          size: 18,
                        )
                      ],
                    ),
                  ),
                ),
                _incoming["otherInfo"].isNotEmpty &&
                        _helpCtrl.chosenCategory["descriptions"] != null
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _incoming["otherInfo"].length,
                        itemBuilder: (BuildContext context, int index) {
                          var data = Map<String, dynamic>.from(
                              _incoming["otherInfo"][index]);
                          var key = removeBracket(data.keys.toString());
                          var value = removeBracket(data.values.toString());
                          controllerList[index].text = value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _title(key),
                              CustomTextField(
                                controller: controllerList[index],
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                              ),
                            ],
                          );
                        },
                      )
                    : Container(),
                SizedBox(height: Get.height * .05),
                CustomButton(
                  isActive: true,
                  text: "Хадгалах",
                  onPressed: () {},
                ),
              ],
            ),
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
