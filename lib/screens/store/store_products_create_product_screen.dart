import 'dart:developer';
import 'dart:io';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/controller/help_controller.dart';
import 'package:Erdenet24/screens/store/store_products_preview_screen.dart';
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

class StoreProductsCreateProductScreen extends StatefulWidget {
  const StoreProductsCreateProductScreen({super.key});

  @override
  State<StoreProductsCreateProductScreen> createState() =>
      _StoreProductsCreateProductScreenState();
}

class _StoreProductsCreateProductScreenState
    extends State<StoreProductsCreateProductScreen> {
  dynamic _category = [];
  int typeId = 0;
  var otherInfo = [];
  bool _productNameOk = false;
  bool _productPriceOk = false;
  bool _productCountOk = false;
  final _helpCtrl = Get.put(HelpController());
  var controllerList = <TextEditingController>[];

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productPrice = TextEditingController();
  final TextEditingController _productSpecs = TextEditingController();
  final TextEditingController _productCount = TextEditingController();

  @override
  void initState() {
    super.initState();
    _helpCtrl.chosenImage.clear();
    _helpCtrl.chosenCategory.clear();
    getCategoryList();
  }

  void getCategoryList() async {
    dynamic user = await RestApi().getUsers({"id": RestApiHelper.getUserId()});
    dynamic userData = Map<String, dynamic>.from(user);
    setState(() {
      typeId = userData["data"][0]["category"];
    });
  }

  void generateOtherInfo() {
    otherInfo.clear();
    for (int i = 0; i < _helpCtrl.chosenCategory["descriptions"].length; i++) {
      var item = {
        _helpCtrl.chosenCategory["descriptions"][i]: controllerList[i].text
      };
      otherInfo.add(item);
      setState(() {});
    }
  }

  void refreshPage() {
    _helpCtrl.chosenImage.clear();
    _productName.clear();
    _productPrice.clear();
    _helpCtrl.chosenCategory.clear();
    otherInfo.clear();
    controllerList.clear();
    getCategoryList();
  }

  void submit() async {
    loadingDialog(context);
    var query = {"id": RestApiHelper.getUserId()};
    dynamic userInfo = await RestApi().getUsers(query);
    dynamic res = Map<String, dynamic>.from(userInfo);
    generateOtherInfo();
    var body = {
      "name": _productName.text,
      "price": _productPrice.text,
      "barcode": "",
      "available": _productCount.text,
      "typeId": typeId,
      "categoryId": _helpCtrl.chosenCategory["id"],
      "store": RestApiHelper.getUserId(),
      "storeName": res["data"][0]["name"],
      "description": _productSpecs.text,
      "otherInfo": otherInfo
    };
    dynamic product = await RestApi().createProduct(body);
    dynamic data = Map<String, dynamic>.from(product);

    for (var element in _helpCtrl.chosenImage) {
      await RestApi()
          .uploadImage("products", data["data"]["id"], File(element));
    }
    refreshPage();
    Get.back();
    if (data["success"]) {
      successSnackBar("Амжилттай хадгалагдлаа", 2, context);
    } else {
      errorSnackBar("Алдаа гарлаа", 2, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                    parentId: typeId,
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
              _helpCtrl.chosenCategory.isNotEmpty &&
                      _helpCtrl.chosenCategory["descriptions"] != null
                  ? Descriptions(controllerList: controllerList)
                  : Container(),
              SizedBox(height: Get.height * .05),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                        elevation: 0,
                        isFullWidth: false,
                        hasBorder: false,
                        bgColor: MyColors.fadedGrey,
                        textColor: MyColors.primary,
                        isActive: _helpCtrl.chosenImage.isNotEmpty &&
                            _productName.text.isNotEmpty &&
                            _productPrice.text.isNotEmpty &&
                            _helpCtrl.chosenCategory.isNotEmpty,
                        text: "Урьдчилж харах",
                        onPressed: () {
                          generateOtherInfo();
                          Get.to(() => const StoreProductsPreviewScreen(),
                              arguments: {
                                "image": _helpCtrl.chosenImage,
                                "name": _productName.text,
                                "price": _productPrice.text,
                                "otherInfo": otherInfo,
                              });
                        }),
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
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Descriptions extends StatefulWidget {
  dynamic controllerList;
  Descriptions({super.key, this.controllerList});

  @override
  State<Descriptions> createState() => _DescriptionsState();
}

class _DescriptionsState extends State<Descriptions> {
  final _helpCtrl = Get.put(HelpController());
  dynamic descriptions = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      descriptions = _helpCtrl.chosenCategory["descriptions"];
      widget.controllerList.isEmpty
          ? descriptions.forEach((el) {
              var controller = TextEditingController();
              widget.controllerList.add(controller);
            })
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.controllerList.length,
      itemBuilder: (BuildContext context, int index) {
        return CustomTextField(
          hintText: descriptions[index],
          controller: widget.controllerList[index],
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}
