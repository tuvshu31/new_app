import 'dart:async';

import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/separator.dart';
import "package:flutter/material.dart";
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Erdenet24/screens/user/home/navigation_drawer.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(49.02818, 104.04740),
    zoom: 16,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void showPrivacy() {
    Get.bottomSheet(
      isDismissible: false,
      SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            color: MyColors.white,
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * .06, vertical: Get.width * .06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.circleDot,
                          size: 20,
                        ),
                        Icon(Icons.location_pin),
                      ],
                    ),
                    Column(
                      children: [
                        CustomText(text: "Tesoro restaurant"),
                        CustomText(text: "6-20-31")
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 24),
                MySeparator(color: MyColors.gray),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        bgColor: MyColors.white,
                        textColor: MyColors.gray,
                        elevation: 0,
                        isActive: true,
                        onPressed: () {
                          Get.back();
                        },
                        text: "Татгалзах",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        isActive: true,
                        onPressed: (() {}),
                        text: "Зөвшөөрөх",
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColors.white,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: MyColors.white,
            drawer: Drawer(),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: MyColors.primary),
              backgroundColor: MyColors.white,
              elevation: 0,
              centerTitle: true,
              titleSpacing: 0,
              title: CustomText(
                text: "Идэвхтэй",
                color: MyColors.black,
                fontSize: 16,
              ),
              actions: [
                Switch(
                    activeColor: MyColors.primary,
                    value: true,
                    onChanged: (val) {}),
              ],
            ),
            body: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: CustomButton(
                      text: "Show New Order",
                      onPressed: () {
                        showPrivacy();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
