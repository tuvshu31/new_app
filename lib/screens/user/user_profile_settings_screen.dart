import 'dart:convert';
import 'dart:io';
import 'package:Erdenet24/api/dio_requests.dart';
import 'package:Erdenet24/api/restapi_helper.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/image_picker.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  final Widget _divider = const Divider(height: 0.7, color: MyColors.grey);
  dynamic _category = [];
  dynamic _pickedData = [];
  bool _loading = false;
  bool _passwordVisible = false;
  int userId = RestApiHelper.getUserId();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _passRepeat = TextEditingController();

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    String response =
        await rootBundle.loadString('assets/json/categories.json');
    dynamic data = await json.decode(response);
    setState(() {
      _category = data;
    });
  }

  void submit() async {
    if (_pass.text != _passRepeat.text) {
      errorSnackBar("Нууц үг тохирохгүй байна", 2, context);
    } else {
      _loading = true;
      setState(() {});
      var _body = {
        "name": _name.text,
        "phone": _phoneNumber.text,
        "password": _pass.text,
      };
      _body.removeWhere((key, value) => value.isEmpty);
      dynamic response = await RestApi().updateUser(userId, _body);

      if (_croppedFile != null) {
        await RestApi().uploadImage("users", userId, File(_croppedFile!.path));
      }
      _loading = false;
      setState(() {});
      if (response["success"]) {
        successSnackBar("Амжилттай хадгалагдлаа", 2, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      title: "Миний тохиргоо",
      customActions: Container(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: Get.width * .05),
        child: Column(
          children: [
            const SizedBox(height: 12),
            CustomImagePicker(imageLimit: 1),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: "Нэр",
              controller: _name,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              hintText: "Утасны дугаар",
              controller: _phoneNumber,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _pass,
              hintText: "Нууц үг",
              obscureText: !_passwordVisible,
              suffixButton: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: Icon(
                    _passwordVisible ? IconlyLight.show : IconlyLight.hide,
                    color: MyColors.gray,
                  )),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: _passRepeat,
              hintText: "Нууц үг давтах",
              obscureText: !_passwordVisible,
              suffixButton: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                  icon: Icon(
                    _passwordVisible ? IconlyLight.show : IconlyLight.hide,
                    color: MyColors.gray,
                  )),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                    isActive: false,
                    isLoading: _loading,
                    text: "Хадгалах",
                    onPressed: () {}),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
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
                  Get.back();
                },
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.fadedGrey,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Image(
                        image: AssetImage("assets/images/png/app/camera.png"),
                        width: 30,
                      ),
                    )),
              ),
              SizedBox(height: 12),
              CustomText(
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
                  Get.back();
                },
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.fadedGrey,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Image(
                        image: AssetImage("assets/images/png/app/gallery.png"),
                        width: 30,
                      ),
                    )),
              ),
              SizedBox(height: 12),
              CustomText(text: "Галерей")
            ],
          ),
        ],
      ),
    ));
  }

  void uploadImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
    );
    setState(() {
      _pickedFile = pickedFile;
    });

    cropImage();
  }

  void cropImage() async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _pickedFile!.path,
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
        _croppedFile = croppedFile;
      });
    }
  }
}
