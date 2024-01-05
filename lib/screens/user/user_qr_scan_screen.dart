import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:Erdenet24/api/dio_requests/store.dart';
import 'package:Erdenet24/api/dio_requests/user.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/custom_loading_widget.dart';
import 'package:Erdenet24/widgets/dialogs/dialog_list.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class UserQRScanScreen extends StatefulWidget {
  const UserQRScanScreen({super.key});

  @override
  State<UserQRScanScreen> createState() => _UserQRScanScreenState();
}

class _UserQRScanScreenState extends State<UserQRScanScreen> {
  final qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          buildQRView(context),
          Positioned(
            bottom: Get.height * .10,
            child: CustomText(
              text: "QR кодоо уншуулна уу",
              color: MyColors.white,
              fontSize: 16,
            ),
          ),
          Positioned(
              top: Get.width * .05,
              right: Get.width * .05,
              child: CustomInkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyColors.fadedGrey,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    ));
  }

  Widget buildQRView(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: MyColors.primary,
              borderWidth: 8,
              borderRadius: 2,
              cutOutSize: Get.width * .7,
            ),
          ),
        ],
      );
  void onQRViewCreated(QRViewController controller) {
    controller.resumeCamera();
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((barcode) async {
      final data = json.decode(barcode.code!);
      if (data["type"] == "navigate") {
        Get.back();
        CustomDialogs().showLoadingDialog();
        String route = data["argument1"];
        int storeId = int.parse(data["argument2"]);
        dynamic getStoreInfo = await UserApi().getStoreInfo(storeId);
        Get.back();
        if (getStoreInfo != null) {
          dynamic response = Map<String, dynamic>.from(getStoreInfo);
          String storeName = response["data"]['name'];
          bool isOpen = response["data"]["isOpen"];
          Get.toNamed("/$route", arguments: {
            "title": storeName,
            "id": storeId,
            "isOpen": isOpen,
          });
        } else {
          customSnackbar(ActionType.error, "QR code буруу байна!", 2);
        }
      }
    });
  }
}
