import 'dart:async';
import 'dart:developer';
import 'package:Erdenet24/screens/driver/messaging_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/separator.dart';
import "package:flutter/material.dart";
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    _determinePosition();
  }

  void getToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print('TOken is updated');
      // TODO: If necessary send token to application server.

      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    }).onError((err) {
      // Error getting token.
    });
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(49.02818, 104.04740),
    zoom: 16.5,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 79.440717697143555,
    zoom: 16.151926040649414,
  );
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
                        onPressed: (() {
                          _goToTheLake();
                        }),
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition();

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
    print(position.latitude);
    print(position.longitude);
    return position;
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
            drawer: const Drawer(),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: MyColors.primary),
              backgroundColor: MyColors.white,
              elevation: 0,
              centerTitle: true,
              titleSpacing: 0,
              title: CustomText(
                text: "Online",
                color: MyColors.black,
                fontSize: 16,
              ),
              actions: [
                CupertinoSwitch(
                  // This bool value toggles the switch.
                  value: true,
                  thumbColor: MyColors.primary,
                  trackColor: CupertinoColors.systemRed.withOpacity(0.14),
                  activeColor: MyColors.grey,
                  onChanged: (bool? value) {
                    // This is called when the user toggles the switch.
                    setState(() {});
                  },
                ),
              ],
            ),
            // body: CustomButton(
            //   text: "Press me",
            //   onPressed: getToken,
            // ),
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
