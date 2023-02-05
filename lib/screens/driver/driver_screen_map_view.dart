import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:Erdenet24/controller/driver_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverScreenMapView extends StatefulWidget {
  const DriverScreenMapView({Key? key}) : super(key: key);

  @override
  State<DriverScreenMapView> createState() => DriverScreenMapViewState();
}

class DriverScreenMapViewState extends State<DriverScreenMapView> {
  Set<Marker> markers = {};
  final _driverCtx = Get.put(DriverController());

  @override
  void initState() {
    super.initState();
    _driverCtx.getCurrentLocation();
    _driverCtx.setMarker(_driverCtx.driverLocation.value, markers, "driver");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: _driverCtx.driverLocation.value),
        onMapCreated: (GoogleMapController controller) {
          _driverCtx.googleMapController.value.complete(controller);
        },
        markers: markers,
      ),
    );
  }
}
