import 'dart:async';
import 'dart:developer';
import 'package:Erdenet24/screens/driver/driver_drawer_screen.dart';
import 'package:Erdenet24/screens/driver/driver_screen_helpers.dart';
import 'package:Erdenet24/screens/driver/messaging_widget.dart';
import 'package:Erdenet24/screens/driver/timer.dart';
import 'package:Erdenet24/widgets/inkwell.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animarker/core/ripple_marker.dart';
import 'package:flutter_animarker/widgets/animarker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Erdenet24/widgets/button.dart';
import 'package:Erdenet24/widgets/separator.dart';
import "package:flutter/material.dart";
import 'package:Erdenet24/utils/styles.dart';
import 'package:Erdenet24/widgets/text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:iconly/iconly.dart';

CameraPosition _camera(lat, lng, tilted) {
  return CameraPosition(
    target: LatLng(lat, lng),
    zoom: 16.5,
    tilt: tilted ? 79.440717697143555 : 0,
  );
}

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  bool isDriverActive = false;
  double latitude = 49.02818;
  double longitude = 104.04740;
  int waitingSeconds = 30;
  Timer? countdownTimer;
  Duration myDuration = const Duration(hours: 3);
  String strDigits(int n) => n.toString().padLeft(2, '0');
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  final CountDownController _countDownController = CountDownController();
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    determineUsersPosition();
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(_camera(latitude, longitude, false)));
  }

  void turnOn(value) {
    isDriverActive = !isDriverActive;
    myDuration = const Duration(hours: 3);
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      const reduceSecondsBy = 1;
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      setState(() {
        if (seconds < 0) {
          countdownTimer!.cancel();
        } else {
          myDuration = Duration(seconds: seconds);
        }
      });
    });
    _goToTheLake();
    setState(() {});
  }

  Future<Position> determineUsersPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
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
      if (position != null) {
        setState(() {
          latitude = position.latitude;
          longitude = position.longitude;
        });
      }
    });
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });

    return position;
  }

  void showPrivacy() async {
    playSound("incoming");
    _countDownController.start();
    showOrderDetailsBottomSheet();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(12, 12)),
      "assets/images/png/app/pin-map.png",
    ).then(
      (icon) {
        setState(() {
          markerIcon = icon;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours = strDigits(myDuration.inHours.remainder(60));
    final minutes = strDigits(myDuration.inMinutes.remainder(60));
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Container(
      color: MyColors.white,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: MyColors.white,
            drawer: driverDrawer(),
            appBar: AppBar(
              iconTheme: const IconThemeData(color: MyColors.primary),
              backgroundColor: MyColors.white,
              elevation: 0,
              centerTitle: true,
              titleSpacing: 0,
              title: CustomText(
                text: isDriverActive ? "Online" : "Offline",
                color: MyColors.black,
                fontSize: 16,
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: CupertinoSwitch(
                    value: isDriverActive,
                    thumbColor:
                        isDriverActive ? MyColors.primary : MyColors.gray,
                    trackColor: MyColors.background,
                    activeColor: MyColors.black,
                    onChanged: ((value) {
                      turnOn(value);
                    }),
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                Animarker(
                  useRotation: false,
                  rippleRadius: 1,
                  rippleColor: MyColors.primary,
                  mapId: _googleMapController.future
                      .then<int>((value) => value.mapId), //Grab Google Map Id
                  // Other properties
                  curve: Curves.easeInQuint,
                  duration: const Duration(milliseconds: 2000),
                  markers: <Marker>{
                    Marker(
                      markerId: MarkerId('MarkerId2'),
                      position: LatLng(latitude, longitude),
                    )
                  },
                  child: GoogleMap(
                    markers: {
                      // Marker(
                      //   markerId: const MarkerId("marker1"),
                      //   position: LatLng(latitude, longitude),
                      //   draggable: true,
                      //   onDragEnd: (value) {
                      //     // value is the new position
                      //   },
                      //   icon: markerIcon,
                      // ),
                    },
                    mapType: MapType.normal,
                    initialCameraPosition: _camera(latitude, longitude, false),
                    onMapCreated: (GoogleMapController controller) {
                      _googleMapController.complete(controller);
                    },
                  ),
                ),
                isDriverActive
                    ? Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration:
                              const BoxDecoration(color: MyColors.white),
                          child: CustomText(
                            text: "$hours:$minutes:$seconds",
                            color: MyColors.primary,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Container(),
                // countDownTimer(_countDownController),
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
