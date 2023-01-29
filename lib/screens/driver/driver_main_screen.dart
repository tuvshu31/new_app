import 'dart:async';
import 'package:Erdenet24/screens/driver/driver_drawer_screen.dart';
import 'package:Erdenet24/screens/driver/driver_screen_bottomsheet_views.dart';
import 'package:Erdenet24/screens/driver/driver_screen_map_view.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:Erdenet24/widgets/button.dart';
import "package:flutter/material.dart";
import 'package:Erdenet24/utils/styles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  bool isDriverActive = false;
  double sourceLat = 49.02818;
  double sourceLng = 104.04740;
  double desticationLat = 49.02818;
  double desticationLng = 104.04740;
  int waitingSeconds = 30;
  Timer? countdownTimer;
  Duration myDuration = const Duration(hours: 3);

  BitmapDescriptor sourceMarker = BitmapDescriptor.defaultMarker;

  final CountDownController _countDownController = CountDownController();
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    addCustomIcon();
  }

  // void _goToTheLake() async {
  //   final GoogleMapController controller = await _googleMapController.future;
  //   controller.animateCamera(
  //       CameraUpdate.newCameraPosition(_camera(sourceLat, sourceLng, true)));
  // }

  void turnOn(value) {
    isDriverActive = !isDriverActive;
    startTimer();
    // _goToTheLake();
    setState(() {});
  }

  void startTimer() {
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
  }

  void showPrivacy() async {
    // playSound("incoming");
    _countDownController.start();
  }

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(12, 12)),
      "assets/images/png/app/pin-map.png",
    ).then(
      (icon) {
        setState(() {
          sourceMarker = icon;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: MyColors.white,
          drawer: driverDrawer(),
          appBar: appBar(isDriverActive, turnOn),
          body: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        googleMap(
            _googleMapController, 49.02818, 104.04740, 49.02818, 104.04740),
        timer(isDriverActive, myDuration),
        // countDownTimer(_countDownController),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(12),
            child: CustomButton(
              text: "Show New Order",
              onPressed: () {
                // showPrivacy();
                gotNewOrder();
              },
            ),
          ),
        ),
      ],
    );
  }
}
