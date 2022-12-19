import 'dart:io';

import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
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
          )
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
    controller.scannedDataStream.listen((barcode) {
      print(barcode);
    });
  }
}
