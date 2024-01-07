import 'package:Erdenet24/api/dio_requests/driver.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:Erdenet24/utils/enums.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/shimmer.dart';
import 'package:Erdenet24/widgets/snackbar.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

class DriverDeliveredView extends StatefulWidget {
  const DriverDeliveredView({super.key});

  @override
  State<DriverDeliveredView> createState() => _DriverDeliveredViewState();
}

class _DriverDeliveredViewState extends State<DriverDeliveredView> {
  bool fetching = false;
  bool loading = false;
  Map order = {};
  TextEditingController controller = TextEditingController();
  final _driverCtx = Get.put(DriverController());
  @override
  void initState() {
    super.initState();
    getCurrentOrderInfo();
  }

  void getCurrentOrderInfo() async {
    fetching = true;
    dynamic getCurrentOrderInfo = await DriverApi().getCurrentOrderInfo();
    fetching = false;
    if (getCurrentOrderInfo != null) {
      dynamic response = Map<String, dynamic>.from(getCurrentOrderInfo);
      if (response["success"]) {
        order = response["data"];
      }
    }
    setState(() {});
  }

  void driverDelivered() async {
    loading = true;
    dynamic driverDelivered = await DriverApi().driverDelivered();
    loading = false;
    if (driverDelivered != null) {
      dynamic response = Map<String, dynamic>.from(driverDelivered);
      if (response["success"]) {
        controller.clear();
        Get.back();
        _driverCtx.driverStatus.value = DriverStatus.finished;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: fetching
          ? _listItemShimmer()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(
                    backgroundColor: MyColors.white,
                    radius: 20,
                    child: Image(
                      width: 32,
                      image: AssetImage(
                        "assets/images/png/app/home.png",
                      ),
                    ),
                  ),
                  title: CustomText(
                    text: order["address"] ?? "No data",
                    fontSize: 16,
                  ),
                  subtitle: CustomText(
                      text: "Орцны код: ${order["entrance"] ?? "N/a"}"),
                  trailing: GestureDetector(
                      onTap: () {
                        makePhoneCall("+976-${order["phone"] ?? 000}");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                      )),
                ),
                SizedBox(height: Get.height * .03),
                CustomButton(
                  text: "Хүлээлгэн өгсөн",
                  onPressed: () {
                    showGeneralDialog(
                      context: context,
                      barrierLabel: "",
                      barrierDismissible: false,
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (ctx, a1, a2) {
                        return Container();
                      },
                      transitionBuilder: (ctx, a1, a2, child) {
                        var curve = Curves.bounceInOut.transform(a1.value);
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: Transform.scale(
                            scale: curve,
                            child: Center(
                              child: Container(
                                width: Get.width,
                                margin: EdgeInsets.all(Get.width * .09),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.only(
                                  right: Get.width * .09,
                                  left: Get.width * .09,
                                  top: Get.height * .04,
                                  bottom: Get.height * .03,
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        IconlyBold.lock,
                                        size: Get.width * .15,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(height: Get.height * .02),
                                      const Text(
                                        "Баталгаажуулах код",
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: Get.height * .02),
                                      Column(
                                        children: [
                                          SizedBox(
                                            width: Get.width * .3,
                                            child: CustomTextField(
                                              autoFocus: true,
                                              maxLength: 4,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: controller,
                                            ),
                                          ),
                                          SizedBox(height: Get.height * .04),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                  child: CustomButton(
                                                onPressed: Get.back,
                                                bgColor: Colors.white,
                                                text: "Хаах",
                                                elevation: 0,
                                                textColor: Colors.black,
                                              )),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: CustomButton(
                                                  elevation: 0,
                                                  bgColor: Colors.amber,
                                                  text: "Submit",
                                                  onPressed: () {
                                                    if (controller.text.length <
                                                        4) {
                                                      customSnackbar(
                                                        ActionType.error,
                                                        "Баталгаажуулах кодоо зөв оруулна уу",
                                                        2,
                                                      );
                                                    } else {
                                                      if (controller.text ==
                                                          order["code"]
                                                              .toString()) {
                                                        driverDelivered();
                                                      } else {
                                                        customSnackbar(
                                                          ActionType.error,
                                                          "Баталгаажуулах код буруу байна",
                                                          2,
                                                        );
                                                      }
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
    );
  }

  Widget _listItemShimmer() {
    return SizedBox(
      height: Get.width * .2 + 16,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: Get.width * .04),
            Stack(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: Get.width * 0.15,
                    maxHeight: Get.width * 0.15,
                  ),
                  child: CustomShimmer(
                    width: Get.width * .15,
                    height: Get.width * .15,
                    borderRadius: 50,
                  ),
                ),
              ],
            ),
            SizedBox(width: Get.width * .04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomShimmer(width: Get.width * .7, height: 16),
                  CustomShimmer(width: Get.width * .7, height: 16),
                  CustomShimmer(width: Get.width * .7, height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
