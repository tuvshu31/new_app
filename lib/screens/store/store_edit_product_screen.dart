import 'dart:developer';

import 'package:Erdenet24/utils/shimmers.dart';
import 'package:Erdenet24/widgets/custom_empty_widget.dart';
import 'package:Erdenet24/widgets/custom_loading_widget.dart';
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

class StoreEditProductScreen extends StatefulWidget {
  const StoreEditProductScreen({super.key});

  @override
  State<StoreEditProductScreen> createState() => _StoreEditProductScreenState();
}

class _StoreEditProductScreenState extends State<StoreEditProductScreen> {
  int typeId = 0;
  List images = [];
  List categories = [];
  Map category = {};
  List otherInfo = [];
  bool imageIsOk = true;
  bool nameIsOk = true;
  bool priceIsOk = true;
  bool availableIsOk = true;
  var controllerList = <TextEditingController>[];
  Map productInfo = {};
  bool loading = false;
  final _arguments = Get.arguments;

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

  void getProductInfo() async {
    loading = true;
    dynamic getProductInfo = await StoreApi().getProductInfo(_arguments["id"]);
    loading = false;
    if (getProductInfo != null) {
      dynamic response = Map<String, dynamic>.from(getProductInfo);
      if (response["success"]) {
        productInfo = response["data"];
        if (productInfo["images"] != null && productInfo["images"].isNotEmpty) {
          images = productInfo["images"];
          for (var i = 0; i < images.length; i++) {
            var element = images[i];
            var obj = {
              "id": i,
              "url": element,
              "network": true,
            };
            images[i] = obj;
          }
          log(images.toString());
        }

        _nameController.text = productInfo["name"];
        _priceController.text = productInfo["price"].toString();
        _countController.text = productInfo["available"].toString();
        int index = categories
            .indexWhere((element) => element["id"] == productInfo["category"]);
        if (index > -1) {
          category = categories[index];
        }
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void updateProductInfo() async {
    CustomDialogs().showLoadingDialog();
    Map<String, dynamic> body = {
      "name": _nameController.text,
      "price": _priceController.text,
      "available": _countController.text,
      "typeId": category["id"],
      "otherInfo": generateOtherInfo(),
    };
    dynamic updateProductInfo =
        await StoreApi().updateProductInfo(_arguments["id"], body);
    if (updateProductInfo != null) {
      dynamic response = Map<String, dynamic>.from(updateProductInfo);
      if (response["success"]) {
        List newImages = [];
        List oldImages = [];
        for (var i = 0; i < images.length; i++) {
          var element = images[i];
          if (element["network"]) {
            oldImages.add(element["id"]);
          } else {
            newImages.add(element["url"]);
          }
        }
        dynamic updateProductPhoto = await StoreApi()
            .updateProductPhoto(_arguments["id"], oldImages, newImages);
        Get.back();
        if (updateProductPhoto != null) {
          dynamic response = Map<String, dynamic>.from(updateProductPhoto);
          if (response["success"]) {
            // refreshInfo();
            Get.back();
            customSnackbar(ActionType.success, "Бараа амжилттай засагдлаа", 2);
          }
        } else {
          customSnackbar(ActionType.error, "Бараа засах үед алдаа гарлаа", 2);
        }
      }
    } else {
      Get.back();
      customSnackbar(ActionType.error, "Алдаа гарлаа", 2);
    }
  }

  void getStoreRelatedCategory() async {
    loading = true;
    dynamic getStoreRelatedCategory =
        await StoreApi().getStoreRelatedCategory();
    loading = false;
    if (getStoreRelatedCategory != null) {
      dynamic response = Map<String, dynamic>.from(getStoreRelatedCategory);
      if (response["success"]) {
        categories = response["data"];
        getProductInfo();
      } else {
        customSnackbar(ActionType.error, "Алдаа гарлаа", 2);
      }
    }
    setState(() {});
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      backgroundColor: MyColors.white,
      isScrollControlled: true,
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      backgroundColor: MyColors.white,
      isScrollControlled: true,
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
      var obj = {
        "id": images.length,
        "url": croppedFile.path,
        "network": false,
      };
      images.add(obj);
      imageIsOk = images.isNotEmpty;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Барааны мэдээлэл засах",
      customActions: Container(),
      body: loading && productInfo.isEmpty
          ? listShimmerWidget()
          : !loading && productInfo.isEmpty
              ? customEmptyWidget("Барааны мэдээлэл байхгүй байна")
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              if (images.isEmpty) {
                                return hasNoImageWidget(
                                    () => showImagePicker());
                              } else if (index < images.length) {
                                if (images[index]["network"]) {
                                  return hasImageFromNetworkWidget(
                                    images[index]["url"],
                                    () => removeImage(index),
                                  );
                                } else {
                                  return hasImageWidget(
                                    images[index]["url"],
                                    () => removeImage(index),
                                  );
                                }
                              } else {
                                return hasNoImageWidget(
                                    () => showImagePicker());
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
                        const Text(
                          "Барааны нэр",
                          style: TextStyle(color: MyColors.gray),
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
                        const Text(
                          "Барааны үнэ",
                          style: TextStyle(color: MyColors.gray),
                        ),
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
                        Text("Барааны үлдэгдэл",
                            style: TextStyle(color: MyColors.gray)),
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
                        _errorText(
                            "Барааны тоо ширхэг оруулна уу", availableIsOk),
                        const SizedBox(height: 12),
                        Text("Ангилал", style: TextStyle(color: MyColors.gray)),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            categories.isEmpty
                                ? null
                                : showCategoryPicker(categories);
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
                                  color: categories.isEmpty
                                      ? MyColors.grey
                                      : MyColors.black,
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: category["descriptions"].length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      var item =
                                          category["descriptions"][index];
                                      return CustomTextField(
                                        hintText: item,
                                        controller: _infoControllers[index],
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 36),
                                  CustomButton(
                                    text: "Бараа засах",
                                    onPressed: () {
                                      imageIsOk = images.isNotEmpty;
                                      nameIsOk =
                                          _nameController.text.isNotEmpty;
                                      priceIsOk =
                                          _priceController.text.isNotEmpty;
                                      availableIsOk =
                                          _countController.text.isNotEmpty;
                                      setState(() {});
                                      if (imageIsOk &&
                                          nameIsOk &&
                                          priceIsOk &&
                                          availableIsOk) {
                                        updateProductInfo();
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
