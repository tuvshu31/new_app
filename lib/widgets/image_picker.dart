import 'dart:io';
import 'package:Erdenet24/controller/help_controller.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:dotted_border/dotted_border.dart';
import "package:flutter/material.dart";
import 'package:Erdenet24/utils/styles.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatefulWidget {
  final int imageLimit;
  const CustomImagePicker({
    this.imageLimit = 4,
    super.key,
  });

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  dynamic imageList = [];
  final _helpCtrl = Get.put(HelpController());
  void uploadImage(ImageSource source) async {
    Get.back();
    final pickedFile = await ImagePicker().pickImage(
      source: source,
    );
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
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
      setState(() {
        imageList.add(croppedFile.path);
      });
      _helpCtrl.chosenImage.value = imageList;
    }
  }

  void showImagePicker() {
    Get.bottomSheet(Container(
      height: Get.height * .2,
      color: MyColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomInkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  uploadImage(ImageSource.camera);
                },
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.fadedGrey,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Image(
                        image: AssetImage("assets/images/png/app/camera.png"),
                        width: 30,
                      ),
                    )),
              ),
              const SizedBox(height: 12),
              const CustomText(
                text: "Камер",
                color: MyColors.black,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomInkWell(
                borderRadius: BorderRadius.circular(300),
                onTap: () {
                  uploadImage(ImageSource.gallery);
                },
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.fadedGrey,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Image(
                        image: AssetImage("assets/images/png/app/gallery.png"),
                        width: 30,
                      ),
                    )),
              ),
              const SizedBox(height: 12),
              const CustomText(text: "Зургийн цомог")
            ],
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: imageList.length < widget.imageLimit
                ? imageList.length + 1
                : imageList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              if (index < imageList.length) {
                return Stack(
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: Image.file(
                        File(imageList[index]),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            imageList.remove(imageList[index]);
                          });
                        },
                        child: Icon(
                          Icons.cancel_rounded,
                          size: 28,
                          color: MyColors.primary.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return GestureDetector(
                    onTap: showImagePicker,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      radius: Radius.circular(20),
                      dashPattern: [10, 10],
                      color: MyColors.black,
                      strokeWidth: 0.2,
                      child: const Center(
                        child: Icon(
                          Icons.add_a_photo_outlined,
                          size: 28,
                          color: MyColors.black,
                        ),
                      ),
                    ));
              }
            }),
        const SizedBox(height: 12),
        widget.imageLimit > 1 && imageList.length != widget.imageLimit
            ? CustomText(
                text:
                    "*Хамгийн ихдээ ${widget.imageLimit} ширхэг зураг оруулах боломжтой",
                fontSize: 12,
                color: MyColors.gray,
              )
            : Container()
      ],
    );
  }
}
