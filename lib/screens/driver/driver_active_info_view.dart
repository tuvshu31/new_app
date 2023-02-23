import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:Erdenet24/utils/helpers.dart';
import 'package:Erdenet24/controller/driver_controller.dart';

class DriverActiveInfoView extends StatefulWidget {
  const DriverActiveInfoView({super.key});

  @override
  State<DriverActiveInfoView> createState() => _DriverActiveInfoViewState();
}

class _DriverActiveInfoViewState extends State<DriverActiveInfoView> {
  final _driverCtx = Get.put(DriverController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _driverCtx.isOnline.value
          ? Container(
              height: Get.height * .075,
              width: double.infinity,
              color: MyColors.white,
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            IconlyLight.wallet,
                          ),
                        ],
                      ),
                      title: const CustomText(
                        text: "Өнөөдрийн орлого:",
                        fontSize: 12,
                      ),
                      subtitle: CustomText(
                          text: convertToCurrencyFormat(
                        int.parse("0"),
                        locatedAtTheEnd: true,
                        toInt: true,
                      )),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(
                            IconlyLight.time_circle,
                          ),
                        ],
                      ),
                      title: const CustomText(
                        text: "Идэвхтэй хугацаа:",
                        fontSize: 12,
                      ),
                      subtitle: CustomText(
                        text: _driverCtx.time.value,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}
