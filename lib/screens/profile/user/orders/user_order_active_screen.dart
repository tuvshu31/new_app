import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/header.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:percent_indicator/percent_indicator.dart';

class UserOrderActiveScreen extends StatefulWidget {
  const UserOrderActiveScreen({super.key});

  @override
  State<UserOrderActiveScreen> createState() => _UserOrderActiveScreenState();
}

class _UserOrderActiveScreenState extends State<UserOrderActiveScreen> {
  List statusList = ["Баталгаажсан", "Бэлтгэж байна", 'Хүргэж байна'];
  PageController pageController = PageController();
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CustomHeader(
        withTabBar: true,
        customLeading: Container(),
        centerTitle: true,
        customTitle: CustomText(
          text: "Захиалга",
          color: MyColors.black,
          fontSize: 16,
        ),
        customActions: Container(),
        body: Column(
          children: [
            _stepper(),
            Expanded(
                child: PageView(
              onPageChanged: (value) {
                setState(() {
                  step = value;
                });
                pageController.animateToPage(
                  value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.bounceInOut,
                );
              },
              controller: pageController,
              children: [
                step0(),
                step0(),
                step1(),
                step2(),
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget _stepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearPercentIndicator(
            backgroundColor: MyColors.black,
            alignment: MainAxisAlignment.center,
            barRadius: const Radius.circular(12),
            lineHeight: 8.0,
            percent: step == 0
                ? 0
                : step == 1
                    ? 0.25
                    : step == 2
                        ? 0.5
                        : 1,
            progressColor: MyColors.primary,
            curve: Curves.bounceIn,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _buildRowList(),
          )
        ],
      ),
    );
  }

  List<Widget> _buildRowList() {
    List<Widget> lines = [];
    statusList.asMap().forEach((index, value) {
      bool active = index + 1 == step;
      lines.add(Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: value,
            color: active ? MyColors.black : MyColors.gray,
          ),
          const SizedBox(height: 4),
          active
              ? CustomText(
                  text: "2022-12-28 09:30",
                  color: MyColors.gray,
                  fontSize: 10,
                )
              : Container(),
        ],
      ));
    });
    return lines;
  }

  Widget step0() {
    return Column(
      children: [
        _orderInfoView(),
        const Image(image: AssetImage("assets/images/png/app/banner1.jpg"))
      ],
    );
  }

  Widget step1() {
    return Column(
      children: [
        _orderInfoView(),
        const Image(image: AssetImage("assets/images/png/app/banner1.jpg"))
      ],
    );
  }

  Widget step2() {
    return Column(
      children: [
        _orderInfoView(),
        Expanded(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {},
          ),
        ),
      ],
    );
  }

  Widget _orderInfoView() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Container(
            height: 7,
            color: MyColors.fadedGrey,
          ),
          CustomInkWell(
            onTap: () {},
            borderRadius: BorderRadius.zero,
            child: SizedBox(
              height: Get.height * .09,
              child: Center(
                child: ListTile(
                  leading: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(text: "Захиалгын дугаар: 8450"),
                      const SizedBox(height: 4),
                      CustomText(
                        text: "2023.01.30 08:47",
                        color: MyColors.gray,
                        fontSize: 10,
                      )
                    ],
                  ),
                  trailing: Icon(IconlyLight.arrow_right_2),
                ),
              ),
            ),
          ),
          Container(
            height: 7,
            color: MyColors.fadedGrey,
          ),
        ],
      ),
    );
  }
}
