import 'package:get/get.dart';
import "package:flutter/material.dart";
// import 'package:custom_marker/marker_icon.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverMapScreen extends StatefulWidget {
  const DriverMapScreen({super.key});

  @override
  State<DriverMapScreen> createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  final _driverCtx = Get.put(DriverController());
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    markerIconGenerator();
  }

  void markerIconGenerator() async {
    // markerIcon = await MarkerIcon.pictureAsset(
    //   assetPath: "assets/images/png/app/driver.png",
    //   width: 100,
    //   height: 100,
    // );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            zoomGesturesEnabled: false,
            mapType: MapType.normal,
            buildingsEnabled: true,
            myLocationButtonEnabled: true,
            // onCameraMove: _driverCtx.onCameraMove,
            rotateGesturesEnabled: true,
            trafficEnabled: false,
            compassEnabled: false,
            markers: {
              Marker(
                markerId: const MarkerId('1'),
                icon: markerIcon,
                position: _driverCtx.driverPosition.value,
                // rotation: _driverCtx.driverRotation.value,
              ),
            },
            initialCameraPosition: CameraPosition(
              target: _driverCtx.driverPosition.value,
              zoom: 14.4746,
            ),
            onMapCreated: _driverCtx.onMapCreated,
          ),
        ],
      ),
    );
  }
}
