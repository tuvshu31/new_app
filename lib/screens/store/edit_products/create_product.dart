import 'dart:developer';
import 'dart:io';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/help_controller.dart';
import 'package:Erdenet24/controller/login_controller.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/dialogs.dart';
import 'package:Erdenet24/widgets/image_picker.dart';
import 'package:Erdenet24/widgets/list_items.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class CreateProduct extends StatefulWidget {
  const CreateProduct({super.key});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  dynamic _category = [];
  int typeId = 0;
  bool _productNameOk = false;
  bool _productPriceOk = false;
  bool _productCountOk = false;
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  final TextEditingController _productSpecs = TextEditingController();
  final TextEditingController _productCount = TextEditingController();
  final _loginCtrl = Get.put(LoginController());
  final _helpCtrl = Get.put(HelpController());
  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  void getCategoryList() async {
    dynamic user = await RestApi().getUsers({"id": RestApiHelper.getUserId()});
    dynamic userData = Map<String, dynamic>.from(user);
    setState(() {
      typeId = userData["data"][0]["category"];
    });
    if (userData["success"]) {
      dynamic res = await RestApi().getCategories({"parentId": typeId});
      dynamic data = Map<String, dynamic>.from(res);
      setState(() {
        _category = data["data"];
      });
    } else {}
  }

  void submit() async {
    loadingDialog(context);
    var query = {"id": RestApiHelper.getUserId()};
    dynamic produc = await RestApi().getUsers(query);
    dynamic res = Map<String, dynamic>.from(produc);
    var body = {
      "name": _productName.text,
      "price": _productPrice.text,
      "barcode": "",
      "available": _productCount.text,
      "typeId": typeId,
      "categoryId": _helpCtrl.chosenCategory["id"],
      "store": RestApiHelper.getUserId(),
      "storeName": res["data"][0]["name"]
    };
    _helpCtrl.chosenImage.forEach((element) {
      print(element);
    });
    // dynamic product = await RestApi().createProduct(body);
    // dynamic data = Map<String, dynamic>.from(product);
    // _helpCtrl.chosenImage.map((element) async => await RestApi()
    //     .uploadImage("products", data["data"]["id"], File(element)));

    Get.back();
    Get.back();
    // if (data["success"]) {
    //   successSnackBar("Амжилттай хадгалагдлаа", 2, context);
    // } else {
    //   errorSnackBar("Алдаа гарлаа", 2, context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * .04),
              const CustomImagePicker(imageLimit: 6),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "Барааны нэр",
                controller: _productName,
                textInputAction: TextInputAction.next,
                onChanged: ((val) {
                  setState(() {
                    _productNameOk = val.length > 2 ? true : false;
                  });
                }),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "Барааны үнэ",
                controller: _productPrice,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Get.to(CustomListItems(
                    list: _category,
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
                        text: _helpCtrl.chosenCategory.isEmpty
                            ? "Ангилал сонгох"
                            : _helpCtrl.chosenCategory["name"],
                        color: _helpCtrl.chosenCategory.isEmpty
                            ? MyColors.grey
                            : MyColors.black,
                      ),
                      _helpCtrl.chosenCategory.isEmpty
                          ? const Icon(
                              IconlyLight.arrow_right_2,
                              size: 18,
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "Дэлгэрэнгүй мэдээлэл",
                controller: _productSpecs,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                maxLength: 8,
                hintText: "Тоо ширхэг",
                controller: _productCount,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 12),
              SizedBox(height: Get.height * .05),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                        isFullWidth: false,
                        hasBorder: false,
                        bgColor: MyColors.white,
                        textColor: MyColors.primary,
                        isActive: false,
                        text: "Урьдчилж харах",
                        onPressed: () {}),
                  ),
                  SizedBox(width: Get.width * .03),
                  Expanded(
                    child: CustomButton(
                      isFullWidth: false,
                      isActive: _productNameOk,
                      text: "Хадгалах",
                      onPressed: submit,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
