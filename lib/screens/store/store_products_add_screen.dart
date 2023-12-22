import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/screens/store/store_screen_views.dart';

class StoreProductsAddScreen extends StatefulWidget {
  const StoreProductsAddScreen({super.key});

  @override
  State<StoreProductsAddScreen> createState() => _StoreProductsAddScreenState();
}

class _StoreProductsAddScreenState extends State<StoreProductsAddScreen> {
  int typeId = 0;
  List<String> images = [];
  List categories = [];
  Map category = {};
  List otherInfo = [];
  bool imageIsOk = true;
  bool nameIsOk = true;
  bool priceIsOk = true;
  bool availableIsOk = true;
  var controllerList = <TextEditingController>[];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  final List<TextEditingController> _infoControllers = [];

  @override
  void initState() {
    super.initState();
    getStoreRelatedCategory();
  }

  List generateOtherInfo() {
    List a = [];
    for (var i = 0; i < otherInfo.length; i++) {
      a.add({otherInfo[i]: _infoControllers[i].text});
    }
    return a;
  }

  void refreshInfo() {
    images.clear();
    _nameController.text = "";
    _priceController.text = "";
    _countController.text = "";
    category.clear();
    setState(() {});
  }

  void addProduct() async {
    CustomDialogs().showLoadingDialog();
    Map<String, dynamic> body = {
      "name": _nameController.text,
      "price": _priceController.text,
      "available": _countController.text,
      "typeId": category["id"],
      "otherInfo": generateOtherInfo(),
    };
    dynamic addProduct = await StoreApi().addProduct(body);
    if (addProduct != null) {
      dynamic response = Map<String, dynamic>.from(addProduct);
      if (response["success"]) {
        int id = response["id"];
        dynamic addProductPhoto = await StoreApi().addProductPhoto(id, images);
        Get.back();
        if (addProductPhoto != null) {
          dynamic response = Map<String, dynamic>.from(addProductPhoto);
          if (response["success"]) {
            refreshInfo();
            customSnackbar(ActionType.success, "Бараа амжилттай нэмэгдлээ", 2);
          }
        } else {
          customSnackbar(
              ActionType.error, "Барааны зураг нэмэх үед алдаа гарлаа", 2);
        }
      }
    } else {
      Get.back();
      customSnackbar(ActionType.error, "Алдаа гарлаа", 2);
    }
  }

  void getStoreRelatedCategory() async {
    dynamic getStoreRelatedCategory =
        await StoreApi().getStoreRelatedCategory();
    if (getStoreRelatedCategory != null) {
      dynamic response = Map<String, dynamic>.from(getStoreRelatedCategory);
      if (response["success"]) {
        categories = response["data"];
        setState(() {});
      } else {}
    }
  }

  void showImagePicker() {
    Get.bottomSheet(
      imagePickerOptionsWidget(() {
        Get.back();
        uploadImage(ImageSource.camera);
      }, () {
        Get.back();
        uploadImage(ImageSource.gallery);
      }),
      backgroundColor: MyColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }

  void showCategoryPicker(List categories) {
    Get.bottomSheet(
      SizedBox(
        height: Get.height,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Ангилал сонгох",
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.close_rounded),
                  )
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Container(
                    height: 7,
                    color: MyColors.fadedGrey,
                  );
                },
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  var item = categories[index];
                  return CustomInkWell(
                    borderRadius: BorderRadius.zero,
                    onTap: () {
                      Get.back();
                      category = item;
                      otherInfo = category["descriptions"] ?? [];
                      if (otherInfo.isNotEmpty) {
                        for (var i = 0; i < otherInfo.length; i++) {
                          _infoControllers.add(TextEditingController());
                        }
                      }
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item["name"]),
                          const Icon(
                            IconlyLight.arrow_right_2,
                            size: 20,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      backgroundColor: MyColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
    );
  }

  void uploadImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
    );
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
    imageIsOk = images.isNotEmpty;
    setState(() {});
  }

  void cropImage(dynamic pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile!.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      cropStyle: CropStyle.rectangle,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            hideBottomControls: true,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort:
              const CroppieViewPort(width: 480, height: 480, type: 'circle'),
          enableExif: true,
          enableZoom: false,
          showZoomer: false,
        ),
      ],
    );
    if (croppedFile != null) {
      images.add(croppedFile.path);
      imageIsOk = images.isNotEmpty;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Бараа нэмэх",
      customActions: Container(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 12),
              GridView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: images.isEmpty
                      ? 1
                      : images.length < 4
                          ? images.length + 1
                          : images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    if (images.isEmpty) {
                      return hasNoImageWidget(() => showImagePicker());
                    } else if (index < images.length) {
                      return hasImageWidget(
                        images[index],
                        () => removeImage(index),
                      );
                    } else {
                      return hasNoImageWidget(() => showImagePicker());
                    }
                  }),
              const SizedBox(height: 12),
              CustomText(
                text: imageIsOk
                    ? "*Хамгийн ихдээ 4 ширхэг зураг оруулах боломжтой"
                    : "*Барааны зургаа оруулна уу",
                fontSize: 12,
                color: imageIsOk ? MyColors.gray : Colors.red,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "Барааны нэр",
                controller: _nameController,
                textInputAction: TextInputAction.next,
                onChanged: ((val) {
                  nameIsOk = val.isNotEmpty;
                  setState(() {});
                }),
              ),
              _errorText("Барааны нэр оруулна уу", nameIsOk),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "Барааны үнэ",
                controller: _priceController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onChanged: (val) {
                  priceIsOk = val.isNotEmpty;
                  setState(() {});
                },
              ),
              _errorText("Барааны үнэ оруулна уу", priceIsOk),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: "Тоо ширхэг",
                controller: _countController,
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  availableIsOk = val.isNotEmpty;
                  setState(() {});
                },
              ),
              _errorText("Барааны тоо ширхэг оруулна уу", availableIsOk),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  categories.isEmpty ? null : showCategoryPicker(categories);
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
                        text: category.isEmpty
                            ? "Ангилал сонгох"
                            : category["name"],
                        color:
                            categories.isEmpty ? MyColors.grey : MyColors.black,
                      ),
                      const Icon(
                        IconlyLight.arrow_down_2,
                        size: 18,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              category["descriptions"] != null &&
                      category["descriptions"].isNotEmpty
                  ? Column(
                      children: [
                        ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 12);
                          },
                          padding: const EdgeInsets.only(top: 8),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: category["descriptions"].length,
                          itemBuilder: (BuildContext context, int index) {
                            var item = category["descriptions"][index];
                            return CustomTextField(
                              hintText: item,
                              controller: _infoControllers[index],
                            );
                          },
                        ),
                        const SizedBox(height: 36),
                        CustomButton(
                          text: "Бараа нэмэх",
                          onPressed: () {
                            imageIsOk = images.isNotEmpty;
                            nameIsOk = _nameController.text.isNotEmpty;
                            priceIsOk = _priceController.text.isNotEmpty;
                            availableIsOk = _countController.text.isNotEmpty;
                            setState(() {});
                            if (imageIsOk &&
                                nameIsOk &&
                                priceIsOk &&
                                availableIsOk) {
                              addProduct();
                            }
                            // submit();
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorText(String text, bool isOk) {
    return isOk
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              "*$text",
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          );
  }
}
