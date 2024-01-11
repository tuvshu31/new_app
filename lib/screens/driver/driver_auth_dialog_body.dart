import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverAuthDialogBody extends StatefulWidget {
  Map item;
  String type;
  DriverAuthDialogBody({required this.item, this.type = "auth", super.key});

  @override
  State<DriverAuthDialogBody> createState() => _DriverAuthDialogBodyState();
}

class _DriverAuthDialogBodyState extends State<DriverAuthDialogBody> {
  bool _validate = true;
  bool loading = false;
  String text = "";
  final _driverCtx = Get.put(DriverController());
  String title(type) {
    if (type == "auth") {
      return "Баталгаажуулах кодоо оруулна уу";
    } else if (type == "secret") {
      return "Захиалгын код оруулна уу";
    } else {
      return "";
    }
  }

  void onPressed(type) {
    if (type == "auth") {
      Get.back();
      _driverCtx.driverAcceptOrder(widget.item);
    } else if (type == "secret") {
      Get.back();
      _driverCtx.driverDelivered(widget.item);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title(widget.type),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
      content: TextField(
        keyboardType: TextInputType.number,
        autofocus: true,
        obscureText: true,
        maxLength: 5,
        decoration: InputDecoration(
          errorText: !_validate ? 'Нууц үг буруу байна!' : null,
          hintStyle: const TextStyle(fontSize: 14),
          hintText: "********************",
          suffixIcon: const Icon(Icons.lock, color: Colors.black),
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12))),
        ),
        style: const TextStyle(
          fontSize: 24,
          color: MyColors.black,
        ),
        cursorColor: MyColors.primary,
        cursorWidth: 2,
        onChanged: (val) {
          text = val;
          _validate = true;
          setState(() {});
        },
      ),
      actions: <Widget>[
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  isActive: text.isNotEmpty,
                  isFullWidth: false,
                  text: "Accept",
                  isLoading: loading,
                  bgColor: Colors.green,
                  elevation: 0,
                  height: 48,
                  cornerRadius: 8,
                  onPressed: () => onPressed(widget.type),
                ),
              ],
            ),
            SizedBox(height: Get.width * .02)
          ],
        ),
      ],
    );
  }
}
